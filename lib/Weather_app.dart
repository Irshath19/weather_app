import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info.dart';
import 'package:weather_app/secret.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // double temp = 0;
  // bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // setState(() {
      //   isLoading = true;
      // });
      String cityname = 'London';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openapikey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      // });
      data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;
            final currenttemp = data['list'][0]['main']['temp'];
            final currentsky = data['list'][0]['weather'][0]['main'];

            final currentweatherdata = data['list'][0];
            final currentpressure = currentweatherdata['main']['pressure'];
            final currentwindspeed = currentweatherdata['wind']['speed'];
            final currenthumidity = currentweatherdata['main']['humidity'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      // color: Colors.grey,
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currenttemp K',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  currentsky == 'Clouds' || currentsky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  color: Colors.white,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '$currentsky',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Weather Forecast",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 5; i++)
                  //         WeatherForecastcard(
                  //           time: data['list'][i + 1]['dt'].toString(),
                  //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                  //                       'Clouds' ||
                  //                   data['list'][i + 1]['weather'][0]['main'] ==
                  //                       'Rain'
                  //               ? Icons.cloud
                  //               : Icons.sunny,
                  //           temperature: '301.22',
                  //         ),
                  //       // WeatherForecastcard(
                  //       //   time: '00.00',
                  //       //   icon: Icons.cloud,
                  //       //   temperature: '301.22',
                  //       // ),
                  //       // WeatherForecastcard(
                  //       //   time: '03.00',
                  //       //   icon: Icons.sunny,
                  //       //   temperature: '300.52',
                  //       // ),
                  //       // WeatherForecastcard(
                  //       //   time: '06.00',
                  //       //   icon: Icons.cloud,
                  //       //   temperature: '301.22',
                  //       // ),
                  //       // WeatherForecastcard(
                  //       //   time: '09.00',
                  //       //   icon: Icons.sunny,
                  //       //   temperature: '300.12',
                  //       // ),
                  //       // WeatherForecastcard(
                  //       //   time: '12.00',
                  //       //   icon: Icons.cloud,
                  //       //   temperature: '304.12',
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyforecast = data['list'][index + 1];
                        final hourlysky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final hourlytemp =
                            hourlyforecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyforecast['dt_txt']);
                        return WeatherForecastcard(
                            time: DateFormat.Hm().format(time),
                            temperature: hourlytemp,
                            icon: hourlysky == 'Clouds' || hourlysky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Additionalinfo(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currenthumidity.toString(),
                      ),
                      Additionalinfo(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentwindspeed.toString(),
                      ),
                      Additionalinfo(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentpressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
