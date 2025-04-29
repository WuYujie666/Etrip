import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/weather/presentation/views/forecast_list.dart';
import 'package:egyptopia/features/weather/presentation/views/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'views/weather_controller.dart';
import 'package:app_settings/app_settings.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());
  final TextEditingController searchController = TextEditingController();

  WeatherScreen({super.key});

  void showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
            "Location permission is permanently denied. Please enable it from app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              AppSettings.openAppSettings();
              Navigator.pop(ctx);
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> smartGetWeatherByLocation(BuildContext context) async {
    try {
      await controller.getWeatherByLocation();
    } catch (e) {
      if (e.toString().contains("User denied permissions to access the device's location")) {
        // ignore: use_build_context_synchronously
        showLocationDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      smartGetWeatherByLocation(context);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() => Image.asset(controller.getWeatherBackground(),
                fit: BoxFit.cover)),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withValues(alpha: 0.2)),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.isSearching.value) {
                controller.isSearching.value = false; // إخفاء القائمة
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const VerticalSpace(7),
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.isSearching.value = value.isNotEmpty;
                      controller.filterCities(value);
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        controller.fetchWeatherDataByCity(value);
                        controller.isSearching.value =
                            false; // إخفاء القائمة بعد البحث
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.8),
                      hintText: "Enter city name",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (searchController.text.isNotEmpty) {
                            controller
                                .fetchWeatherDataByCity(searchController.text);
                            controller.isSearching.value = false;
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Obx(() => controller.isSearching.value
                      ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: SizeConfig.defaultSize! * 30,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: controller.filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = controller.filteredCities[index];
                                return ListTile(
                                  title: Text(city,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  onTap: () {
                                    searchController.text = city;
                                    controller.fetchWeatherDataByCity(city);
                                    controller.isSearching.value = false;
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox()),
                  const VerticalSpace(1),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${controller.city.value}, ${controller.country.value}",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.defaultSize! * 2.7,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Text(
                                      "${controller.dayOfWeek.value}, ${controller.currentTime.value}",
                                      style: GoogleFonts.lato(
                                          fontSize:
                                              SizeConfig.defaultSize! * 1.7,
                                          color: Colors.white)),
                                  controller.getWeatherIcon(),
                                  WeatherCard(
                                      city: controller.city.value,
                                      temperature: controller.temperature.value,
                                      description: controller.description.value,
                                      icon: controller.icon.value,
                                      humidity: controller.humidity.value,
                                      windSpeed: controller.windSpeed.value,
                                      pressure: controller.pressure.value,
                                      sunrise: controller.sunrise.value,
                                      sunset: controller.sunset.value),
                                  if (controller.forecastData.isNotEmpty) ...[
                                    const VerticalSpace(1),
                                    Text("5-Day Weather Forecast",
                                        style: GoogleFonts.lato(
                                            fontSize:
                                                SizeConfig.defaultSize! * 2,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    const VerticalSpace(1),
                                    ForecastList(
                                        forecastData: controller.forecastData)
                                  ],
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}