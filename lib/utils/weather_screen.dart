import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App',
      style: TextStyle(color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold
      ),),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(
          Icons.refresh,
          color: Colors.black,
        ),
        onPressed: (){},
        )
      ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Text('26 ^C',
                    style: TextStyle(fontSize: 32,
                    fontWeight: FontWeight.bold),),
                    Icon(Icons.wb_sunny,size: 64,color: Colors.orange,),
                    SizedBox(height: 16,),
                    Text('Sunny',style: TextStyle(fontSize: 24),)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Hourly Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
            ),
          
              SizedBox(
              height: 20,
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Card(
                    elevation: 6,
                    child: Column(
                      children: [],
                    ),
                  ),
                )
              ],
            )
        
          ],
        ),
      ),
    );
  }
}