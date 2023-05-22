import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:server_room/awesomeNotif.dart';
import 'package:server_room/main.dart';

import '../models/user.dart';
import '../my_voids.dart';
import 'package:intl/intl.dart';

class HomePageCtr extends GetxController {
   StreamSubscription<DatabaseEvent>? streamData;

   String newestChartValue ='0';
   bool isGasActive = true;
   bool isTemperatureActive = true;
   bool isNoiseActive = true;


   Color chartColTem = Colors.green;
   bool shouldSnoozeTem = false;//true
   bool isInDangerTem = false;
   checkDangerTemState(){
     inDangerMake(){
       isInDangerTem = true;
       if(shouldSnoozeTem){

         Future.delayed(const Duration(milliseconds: 500), () {
           if(isTemperatureActive){
             NotificationController.createNewStoreNotification('temperature out of expected range', 'value: ${tem_data}');
           }
         });
         print('## --- S N O O Z E --- ');
         shouldSnoozeTem = false;
       }
     }

     if(double.parse(tem_data) <= 24 ){
       chartColTem = Colors.green;
       isInDangerTem = false;
       shouldSnoozeTem = true;

     }else if(double.parse(tem_data) >24 && double.parse(tem_data)<=27){
       chartColTem = Colors.orange;
       inDangerMake();
   }else{
   chartColTem = Colors.red;
   inDangerMake();

   }




   }


   Color chartColGas = Colors.green;
   bool shouldSnoozeGas = false;//true
   bool isInDangerGas = false;
   checkDangerGasState(){
     inDangerMake(){
       isInDangerGas = true;
       if(shouldSnoozeGas){

         Future.delayed(const Duration(milliseconds: 500), () {
           if(isGasActive){
             NotificationController.createNewStoreNotification('gas out of expected range', 'value: ${gas_data}');
           }
         });
         print('## --- S N O O Z E --- ');
         shouldSnoozeGas = false;
       }
     }

     if(double.parse(gas_data) >=500 ){
       chartColGas = Colors.red;
       inDangerMake();

     }else{
       chartColGas = Colors.green;
       isInDangerGas = false;
       shouldSnoozeGas = true;

     }





   }

   Color chartColNoise = Colors.green;
   bool shouldSnoozeNoise = false;//true
   bool isInDangerNoise = false;
   checkDangerNoiseState(){
     inDangerMake(){
       isInDangerNoise = true;
       if(shouldSnoozeNoise){

         Future.delayed(const Duration(milliseconds: 500), () {
           if(isNoiseActive){
             NotificationController.createNewStoreNotification('noise out of expected range', 'value: ${noise_data}');
           }
         });
         print('## --- S N O O Z E --- ');
         shouldSnoozeNoise = false;
       }
     }
     if(double.parse(noise_data) >=4000 ){
       chartColNoise = Colors.red;
       inDangerMake();

     }else{
       chartColNoise = Colors.green;
       isInDangerNoise = false;
       shouldSnoozeNoise = true;
     }






   }



  int periodicUpdateData = 1000;
  //String gas_tapped_val = '00.00';
  String gas_data = '0';
  String noise_data = '0';
  String tem_data = '0';
  String? selectedServer ;
  bool showTime = true;
  int serversNumber = 0 ;
  List<String> servers = [];
  int tickPeriod = 5;
  String bottomTitleTime = '';
  List<double> tempDataPts = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ]; // initial data points
  List<double> noiseDataPts = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ]; // initial data points
  List<double> gasDataPts = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ]; // initial data points
  int xIndexsGas = 0;
  int xIndexsTem = 0;
  int xIndexsNoise = 0;
  DateTime startDateTime = DateTime.now();



  @override
  void onInit() {
    super.onInit();
    startDateTime =  startDateTime.subtract(Duration(seconds:gasDataPts.length -1));

    Future.delayed(const Duration(milliseconds: 0), () async {//time to start readin data
      periodicFunction();

        await getChildrenLength().then((value) {
          serversNumber=value;
        if(servers.isNotEmpty){

          print('## servers.isNotEmpty');
          changeServer(servers[0]);
          //realTimeListen();// start streamData
          // update(['chart']);
          // update(['chart0']);
          // update(['chart1']);
          // update(['appBar']);
        }else{
          print('## servers = Empty');

          selectedServer='';
        }
      }); //1

    });
  }




  changeServer(server) async {
    selectedServer = server;
    print('## change server to server => ${selectedServer}');

    if(streamData != null) await streamData!.cancel();

    realTimeListen(server);


    // update(['appBar']);
    // update(['chart']);
  }


Future<int> getChildrenLength() async {
    String userID = currentUser.id!;
    int serverNumbers = 0;
  DatabaseReference serverData = database!.ref('Leoni/LTN4');
    //servers = sharedPrefs!.getStringList('servers') ?? ['server1'];

    final snapshot = await serverData.get();

  if (snapshot.exists) {
    serverNumbers = snapshot.children.length;
     snapshot.children.forEach((element) {
      //print('## ele ${element.key}');
      servers.add(element.key.toString());
    });
    print('## <$userID> exists with [${serverNumbers}]servers:<$servers> server');
  } else {
    print('## <$userID> DONT exists');
  }

    //update(['chart']);
  return serverNumbers;
}



/// ADD-SERVER ////////////////:
   Future<String?> getServerNameDialog(BuildContext context) {
      TextEditingController _textEditingController = TextEditingController();
      final _serverFormKey = GlobalKey<FormState>();


      return showDialog<String>(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Server Name'),
           content: Form(
             key: _serverFormKey,
             child: TextFormField(
               controller: _textEditingController,
               decoration: InputDecoration(
                 labelText: 'Enter Server Name',
               ),
               validator: (value) {
                 if (value!.isEmpty) {
                   return 'Server name cannot be empty';
                 }
                 if(servers.contains(value)){
                   return 'Server name already exist';

                 }
                 return null;
               },
             ),
           ),

           actions: [
             ElevatedButton(
               onPressed: () {
                String sName = _textEditingController.text;
                 //if(sName.isNotEmpty && servers.contains(sName))
                if(_serverFormKey.currentState!.validate()){
                  Navigator.of(context).pop(sName);
                }
               },
               child: Text('Save'),
             ),
           ],
         );
       },
     );
   }
   addServer(context) async {
    //String serverName = 'server${serversNumber + 1}';

    String serverName = await getServerNameDialog(context)??'null';
    print('## serverName<written>: $serverName');
    if(serverName=='null') return;



    serverAdded() async {
      print('## <$serverName> ADDED!');
      //servers.insert(0, serverName);
      //sharedPrefs!.setStringList('servers', servers);
      servers.clear();
      serversNumber = await getChildrenLength();
      changeServer(serverName);
      print('## +saved servers: <$serversNumber>:<$servers>');
    }

    DatabaseReference serverData = database!.ref('Leoni/LTN4');
    await serverData.update({
      "$serverName": {
        "gas_once": 0.0,
        "sound_once": 0,
        "temperature_once": 0.0,
      }
    }).then((value) async {
      await serverAdded();
    });



    //update(['chart']);

  }
   removeServer(serverName) async {
     await database!.ref('Leoni/LTN4/$serverName').remove().then((value) async {
       print('##  < $serverName > removed!');
     });
     servers.remove(serverName);
     update(['appBar']);
   }
   /// /////////////////////



  List<FlSpot> generateSpotsGas(dataPts) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 + xIndexsGas; i < dataPts.length + xIndexsGas; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              //isLast? bottomTitleTime :i.toDouble(),//X
              i.toDouble(),//X
              dataPts[i - xIndexsGas]
          )//Y
      );
    }
    xIndexsGas++;
    return spots;
  }

  List<FlSpot> generateSpotsTem(dataPts) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 + xIndexsTem; i < dataPts.length + xIndexsTem; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              //isLast? bottomTitleTime :i.toDouble(),//X
              i.toDouble(),//X
              dataPts[i - xIndexsTem]
          )//Y
      );
    }
    xIndexsTem++;
    return spots;
  }

  List<FlSpot> generateSpotsNoise(dataPts) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 + xIndexsNoise; i < dataPts.length + xIndexsNoise; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              //isLast? bottomTitleTime :i.toDouble(),//X
              i.toDouble(),//X
              dataPts[i - xIndexsNoise]
          )//Y
      );
    }
    xIndexsNoise++;
    return spots;
  }


  /// UPDATE-DATA-PTS //////
   updateGasDataPoints(newData) {
    double getNewDataPoint= double.parse(newData); // your code to retrieve new data point here
    // update data points and rebuild chart
    gasDataPts.removeAt(0); // remove oldest data point
    gasDataPts.add(getNewDataPoint); // add new data point
  }
   updateTempDataPoints(newData) {
    double getNewDataPoint= double.parse(newData); // your code to retrieve new data point here
    // update data points and rebuild chart
    tempDataPts.removeAt(0); // remove oldest data point
    tempDataPts.add(getNewDataPoint); // add new data point
  }
   updateSoundDataPoints(newData) {
    double getNewDataPoint= double.parse(newData); // your code to retrieve new data point here
    // update data points and rebuild chart
    noiseDataPts.removeAt(0); // remove oldest data point
    noiseDataPts.add(getNewDataPoint); // add new data point
  }
  /// //////////////////////


  periodicFunction() {
    //print('## start periodic ...');

    Timer.periodic(Duration(milliseconds: 1000), (timer) {

      updateGasDataPoints(gas_data);
      updateTempDataPoints(tem_data);
      updateSoundDataPoints(noise_data);

      update(['chart']);
      update(['appBar']);

    });

  }

  realTimeListen(String ser) async {
    print('## realTimeListen <Leoni/LTN4/$ser> ...');
    //DatabaseReference serverData = database!.ref('Leoni/LTN4/$server');
    DatabaseReference serverData = database!.ref('Leoni/LTN4/$ser');
      streamData = serverData.onValue.listen((DatabaseEvent event) {


      // /////////////
      gas_data = event.snapshot.child('gas_once').value.toString();
      noise_data = event.snapshot.child('sound_once').value.toString();
      tem_data = event.snapshot.child('temperature_once').value.toString();


      print('## LAST_read_data: <gas: $gas_data /tem: $tem_data /noise: $noise_data >');
      //print('## gas_data_pointd:$gasValueList');

     // update(['chart']);

    });
  }


   // void sendNotif({String? name,String? idNotifRecever,String? bpm }){ // just the patient do THIS
   //
   //   print('## sending notif ..... ');
   //
   //
   //   NotificationController.createNewStoreNotification('', '');
   //
   //
   // }

// realTimeOnceListen(userID, server)  {
  //
  //   Timer.periodic(Duration(milliseconds: periodicUpdateData), (timer) async {
  //     DatabaseReference serverData = database!.ref('rooms/$userID/$server');
  //
  //     final snapshot = await serverData.get();
  //
  //     if (snapshot.exists) {
  //       gas_data = snapshot.child('gas').value.toString();
  //       updateDataPoints(gas_data);
  //
  //       print('## value_changing... <$gas_data>');
  //
  //
  //     } else {
  //       print('## No data available.');
  //     }
  //   });
  // }
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
