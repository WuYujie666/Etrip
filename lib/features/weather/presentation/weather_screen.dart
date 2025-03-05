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

class WeatherScreen extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());
  final TextEditingController searchController = TextEditingController();

  WeatherScreen({super.key}){
    controller.getWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const VerticalSpace(7),
                TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.fetchWeatherDataByCity(value);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    hintText: "Enter city name",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (searchController.text.isNotEmpty) {
                          controller
                              .fetchWeatherDataByCity(searchController.text);
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const VerticalSpace(1),
                Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.city.value,
                                style: TextStyle(
                                    fontSize: SizeConfig.defaultSize! * 2.7,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text(
                                "${controller.dayOfWeek.value}, ${controller.currentTime.value}",
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.defaultSize! * 1.7, color: Colors.white)),
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
                                      fontSize: SizeConfig.defaultSize! * 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const VerticalSpace(1),
                              ForecastList(
                                  forecastData: controller.forecastData)
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
