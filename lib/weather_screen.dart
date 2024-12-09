import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additionalinfo.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late  Future<Map<String , dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      
    String cityName = 'London';
    final res = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'
       ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      //data['list'][0]['main']['temp'];
      return data;

      
      
    } catch(e) {
      throw e.toString();
    }
  
    }
  
  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {
              setState(() { 
                weather = getCurrentWeather()  ; 
              });
            }, icon: const Icon(Icons.refresh),
            ) 
          ] ,
      ) ,
      body: FutureBuilder(
        future: weather,
        builder: (context,snapshot) {
  
          if (snapshot.connectionState == ConnectionState.waiting){
            return  const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError){
            return  Center(child: Text(snapshot.error.toString()));
          }
          

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];


          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
             SizedBox(
              width: double.infinity,
               child: Card(
                elevation: 10,
              //  color: Colors.grey.withOpacity(0.3),
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter (
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child:  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        
                        children: [
                          Text('$currentTemp K',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          const SizedBox(height: 16,),
                           Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud: Icons.sunny,size: 64),
                           const SizedBox(height: 16,),
                           Text(currentSky,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
               ),
             ),
          
            const SizedBox(height: 30,),
            const Text('Hourly Forecast',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 8),
            //weather forcast card
            //  SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       for (int i =0 ; i<6; i++)
            //        HourlyForecastItem(
            //         time: data['list'][i+1]['dt'].toString(),
            //         temperature:data['list'][i+1]['main']['temp'].toString(),
            //         icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds' || 
            //           data['list'][i+1]['weather'][0]['main'] == 'Rain' 
            //           ? Icons.cloud 
            //           :Icons.sunny),
                  
            //     ],
            //   ),
            // ),
           SizedBox(
            height: 120,
             child: ListView.builder(
              itemCount:6,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final hourlyForecast = data['list'][index +1];
                final hourlySky =data['list'][index+1]['weather'][0]['main'];
                final hourlyTemp = hourlyForecast['main']['temp'].toString();
                final time = DateTime.parse(hourlyForecast['dt_txt'].toString(),);
                return HourlyForecastItem(
                  //00:00  hour minute
                  time: DateFormat.j().format(time), 
                  temperature:hourlyTemp , 
                  icon:  hourlySky == 'Clouds' || hourlySky == 'Rain' 
                         ? Icons.cloud 
                         :Icons.sunny);
                         
                },
             ),
           ),
           const SizedBox(height: 20,),
           //information
           const Text('Additional Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 8,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Additionalinfoitem(icon: Icons.water_drop,label: 'Humidity',value: currentHumidity.toString(),),
                Additionalinfoitem(icon: Icons.air ,label:'Wind Speed' ,value:currentWindSpeed.toString() ,),
                Additionalinfoitem(icon:Icons.beach_access,label: 'Pressure',value:currentPressure.toString() ,),
                
              ],
            )
            ],
          ),
        );
        },
      )
    );
  }
}

