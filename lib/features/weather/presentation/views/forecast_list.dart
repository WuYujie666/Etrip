import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ForecastList extends StatelessWidget {
  final List<Map<String, dynamic>> forecastData;

  const ForecastList({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.defaultSize! * 15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          var forecast = forecastData[index];
          return Card(
            color: Colors.white.withOpacity(0.2),
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(DateTime.parse(forecast['dateTime'])),
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  const VerticalSpace(1),
                  Image.network(
                    "https://openweathermap.org/img/wn/${forecast['icon']}@2x.png",
                    width: SizeConfig.defaultSize! * 5,
                  ),
                  const VerticalSpace(1),
                  Text(
                    "${forecast['temperature'].toStringAsFixed(1)}°C",
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                  Text(
                    forecast['description'],
                    style: GoogleFonts.aclonica(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}