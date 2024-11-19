import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/utils/additional_info.dart';
import 'package:weather_app/utils/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  double currentTemp = 0;
  String currentSkyCondition = '';
  double currentWindSpeed = 0;
  double currentHumidity = 0;
  double currentPressure = 0;

  TextEditingController cityController = TextEditingController();

  String cityName = 'London';
  @override
  void initState() {
    isLoading = false;
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    //try will catch any error
    try {
      String apikey = 'ef41a52ac4b2b9c92f769ca397603506';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentTemp = (data['main']['temp'] - 273.15);
          isLoading = false;
          currentSkyCondition = data['weather'][0]['main'];
          currentWindSpeed = data['wind']['speed'];
          currentHumidity = data['main']['humidity'];
          currentPressure = data['main']['pressure'];
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName[0].toUpperCase() + cityName.substring(1),
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              getCurrentWeather();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Text(
                            ' ${currentTemp.toStringAsFixed(2)}°C',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            currentSkyCondition == 'Clouds' ||
                                    currentSkyCondition == 'Mist' ||
                                    currentSkyCondition == 'Rain'
                                ? Icons.cloud
                                : Icons.wb_sunny,
                            size: 64,
                            color: currentSkyCondition == 'Clouds' ||
                                    currentSkyCondition == 'Mist' ||
                                    currentSkyCondition == 'Rain'
                                ? Colors.blueGrey
                                : Colors.yellow[700],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            currentSkyCondition,
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForecastCard(),
                        HourlyForecastCard(),
                        HourlyForecastCard(),
                        HourlyForecastCard(),
                        HourlyForecastCard(),
                        HourlyForecastCard(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional info',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdditionalInfo(
                        title: 'Wind',
                        value: currentWindSpeed.toStringAsFixed(2) + 'Km/h',
                        icon: Icons.air,
                      ),
                      AdditionalInfo(
                        title: 'Humidity',
                        value: currentHumidity.toString() + '%',
                        icon: Icons.water,
                      ),
                      AdditionalInfo(
                        title: 'Pressure',
                        value: currentPressure.toString() + 'hPa',
                        icon: Icons.arrow_downward,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Change Location'),
                                  content: TextField(
                                    controller: cityController,
                                    decoration: InputDecoration(
                                        hintText: 'Enter City Name'),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[a-zA-Z]'))
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            cityName = cityController.text;
                                            isLoading = true;
                                          });
                                          getCurrentWeather();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Change Location',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
