import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget{
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
    });
  @override  
  Widget build(BuildContext context) {
    return  Card(
                    elevation: 6,
                   // color: Colors.grey.withOpacity(0.3),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  Column(
                        children: [
                          Text(time,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),maxLines:1 ,overflow: TextOverflow.ellipsis,),
                        const SizedBox(height: 8,),
                        Icon(icon),
                                      
                        const SizedBox(height: 8,),
                                      
                         Text(temperature),
                        ],
                      ),
                    ),
                  );
  }
}
