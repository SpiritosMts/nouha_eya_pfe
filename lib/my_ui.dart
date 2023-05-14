

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

SideTitles get topTitles => SideTitles(
  //interval: 1,
  showTitles: true,
  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {

    }

    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);

// SideTitles get leftTitles => SideTitles(
//   interval: 50,
//   showTitles: true,
//   getTitlesWidget: (value, meta) {
//     String text = '';
//     switch (value.toInt()) {
//       case -50:
//         text = '-50';
//         break;
//       case 0:
//         text = '0';
//         break;
//       case 50:
//         text = '50';
//         break;
//       case 100:
//         text = '100';
//         break;
//     }
//
//     return Text(
//       text,
//       maxLines: 1,
//       textAlign: TextAlign.center,
//       style: TextStyle(fontSize: 11),
//     );
//   },
// );


SideTitles get leftTitlesHistory => SideTitles(
  //interval: 50,
  showTitles: true,
  getTitlesWidget: (double value, meta) {


    return Text(
      value.toString(),
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);


SideTitles  bottomTimeTitles(int eachTime, List<String> timeList) { //gas_times
  return SideTitles(
  interval: 1,
  showTitles: true,
  getTitlesWidget: (value, meta) {
    int index = value.toInt(); // 0 , 1 ,2 ...
    String bottomText = '';


    //print('## ${value.toInt()}');

    //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
    //bottomText = (value.toInt() ).toString();

    switch (value.toInt() % eachTime ) {

      case 0:
//        bottomText = DateFormat('HH:mm:ss').format(newDateTime);
        bottomText=timeList[index];

        break;
    // case 0:
    //   bottomText = DateFormat('mm:ss').format(newDateTime);
    //   break;

    }

    return Text(
      bottomText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);
}