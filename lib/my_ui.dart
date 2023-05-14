

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

SideTitles get leftTitles => SideTitles(
  interval: 50,
  showTitles: true,
  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {
      case -50:
        text = '-50';
        break;
      case 0:
        text = '0';
        break;
      case 50:
        text = '50';
        break;
      case 100:
        text = '100';
        break;
    }

    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);


SideTitles get leftTitlesHistory => SideTitles(
  //interval: 50,
  showTitles: true,
  getTitlesWidget: (double value, meta) {
    //print('## value ${value.toString()}');
    String text = '';
    switch (value.toString()) {
      // case '23.0':
      //   text = '23.0';
      //   break;
      // case '23.5':
      //   text = '23.5';
      //   break;
      // case '24.0':
      //   text = '24.0';
      //   break;
      // case '24.5':
      //   text = '24.5';
      //   break;
      // case '25.0':
      //   text = '25.0';
      //   break;
    }

    return Text(
      value.toString(),
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);


SideTitles  bottomTimeTitles(int eachTime, List<String> timeList) {
  return SideTitles(
  interval: 1,
  showTitles: true,
  getTitlesWidget: (value, meta) {
    int index =value.toInt();
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