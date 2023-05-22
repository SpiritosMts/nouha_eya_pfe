import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page/home_page_ctr.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 100.0),
        child: GetBuilder<HomePageCtr>(
          builder: (gc) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSwitch('Gas', gc.isGasActive, (value) {

                  gc.isGasActive = value;
                  gc.update();
                  print('## isGasActive : ${gc.isGasActive}');
                }),
                buildSwitch('Temperature', gc.isTemperatureActive, (value) {
                    gc.isTemperatureActive = value;
                    gc.update();
                    print('## isTemperatureActive : ${gc.isTemperatureActive}');

                }),
                buildSwitch('Noise', gc.isNoiseActive, (value) {
                    gc.isNoiseActive = value;
                    gc.update();
                    print('## isNoiseActive : ${gc.isNoiseActive}');

                }),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(label,style: TextStyle(
          fontSize: 20
        )),
        SizedBox(width: 20,),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
