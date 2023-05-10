import 'dart:async';
import 'dart:ffi';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:server_room/main.dart';

import '../../models/user.dart';
import '../../my_voids.dart';
import 'package:intl/intl.dart';

class HistoryCtr extends GetxController {
  StreamSubscription<DatabaseEvent>? streamData;


  List<String> gas_history = [];
  List<String> noise_history = [];
  List<String> temp_history = [];



  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () async { //time to start readin history  data
      gas_history = await getHistoryData('Leoni/LTN4/SR1/gas'); // path history

      getMinValue(gas_history);

      print('## ${      getMinValue(gas_history)}');
      noise_history = await getHistoryData('Leoni/LTN4/SR1/sound');
      temp_history = await getHistoryData('Leoni/LTN4/SR1/temperature');
      update(['chart']);
      update(['appBar']);
    });
  }


  Future<List<String>> getHistoryData(dataTypePath) async {
    List<String> dataHis = [];
    DatabaseReference serverData = database!.ref(dataTypePath);
    //servers = sharedPrefs!.getStringList('servers') ?? ['server1'];

    final snapshot = await serverData.get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        //print('## ele ${element.key}');
        dataHis.add(element.value.toString());
        //print('## type... <${element.value.runtimeType}>');

      });

      print('## ${dataTypePath} history exists with <${dataHis.length}> values');
    } else {
      print('## ${dataTypePath} history DONT exists');
    }

    update(['chart']);
    print('## <<${dataHis.length}>> hisValues=<$dataHis> ');
    return dataHis;
  }
  List<FlSpot> generateSpots(List dataList) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 ; i < dataList.length ; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              i.toDouble(),
              double.parse(dataList[i])
          )
      );
    }

    return spots;
  }






}

///read once
// final ref = FirebaseDatabase.instance.ref();
// final snapshot = await ref.child('users/key0').get();
// if (snapshot.exists) {
//   print('## dataref: ${snapshot.value}');
//
// } else {
//   print('## No data available.');
// }
///
