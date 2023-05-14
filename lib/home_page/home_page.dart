import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_room/admin/approvedList.dart';
import 'package:server_room/main.dart';
import 'package:server_room/models/user.dart';
import 'package:server_room/my_voids.dart';
import 'package:server_room/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:server_room/auth/login.dart';
import 'package:server_room/profile/manage_profile.dart';
import 'package:intl/intl.dart';

import '../history/history.dart';
import 'dart:async';
import '../my_ui.dart';
import 'home_page_ctr.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
String formattedTime = '';


class _HomePageState extends State<HomePage> {
  final HomePageCtr gc = Get.put<HomePageCtr>(HomePageCtr());
  Widget drawer = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: const Center(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            //Get.put<HomePageCtr>(HomePageCtr()).deleteFirstValues(5);
            Get.back();
            Get.to(() => HomePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('View History'),
          onTap: () {
            Get.back();
            Get.to(() => HistoryView());
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Manage Profile'),
          onTap: () {
            Get.back();

            Get.to(() => ManageProfile());
          },
        ),
        if (currentUser.isAdmin)
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin Panel'),
            onTap: () {
              Get.back();
              Get.to(() => ApprovedListView());
            },
          ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            Get.back();
            Get.to(() => NotificationsPage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: (){
            logoutUser();
          },
        ),
      ],
    ),
    width: 200,
  );

  //final homePageCtr gc = Get.find<homePageCtr>();

  SideTitles get _bottomTitles => SideTitles(
    interval: 1,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String bottomText = '';

     //print('## ${value.toInt()}');

      //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
      DateTime newDateTime = gc.startDateTime.add(Duration(seconds: value.toInt()));
      //bottomText = DateFormat('mm:ss').format(newDateTime);
      //bottomText = (value.toInt() ).toString();

      switch (value.toInt() % 7 ) {

      case 0:
        bottomText = DateFormat('HH:mm:ss').format(newDateTime);
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
      // if(gc.showTime) {
      //   gc.showTime =false;
      //   //bottomText = gc.bottomTitleTime;
      //  //gc.bottomTitleTime ='';
      //
      //   return Text(
      //     bottomText,
      //     maxLines: 1,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(fontSize: 11),
      //   );
      // }
      //formattedTime = DateFormat('HH:mm:ss').format(now);

      //return Text('-');
    },
  );


  Widget chartGraph(type_data,type_name,data_points,minVal,maxVal){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(type_name, textAlign: TextAlign.left, style: TextStyle(fontSize: 24)),
              SizedBox(width: 10,),
              Text('(${formatNumberAfterComma(type_data)})', textAlign: TextAlign.left, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black54))
            ],
          ),
        ),
        Container(
          //height: MediaQuery.of(context).size.height /1.5,
          //SingleChildScrollView / scrollDirection: Axis.horizontal,
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                color: Colors.grey[200],
                //width: MediaQuery.of(context).size.width /1.02,
                //height: MediaQuery.of(context).size.height / 3,
                child: LineChart(
                  swapAnimationDuration: Duration(milliseconds: 40),
                  swapAnimationCurve: Curves.linear,
                  LineChartData(
                    clipData: FlClipData.all(),
                    // no overflow
                    lineTouchData: LineTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.blue,
                          tooltipRoundedRadius: 20.0,

                          showOnTopOfTheChartBoxArea: false,
                          //true
                          fitInsideHorizontally: true,
                          tooltipMargin: 50,
                          tooltipHorizontalOffset: 20,
                          fitInsideVertically: true,
                          tooltipPadding: EdgeInsets.all(8.0),
                          //maxContentWidth: 40,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
                              const textStyle = TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              );
                              return LineTooltipItem(
                                formatNumberAfterComma('${data_points[touchedSpot.spotIndex]}'),
                                textStyle,
                              );
                            },
                            ).toList();
                          },
                        ),
                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                          return indicators.map(
                                (int index) {
                              final line = FlLine(color: Colors.blue, strokeWidth: 2, dashArray: [2, 5]);
                              return TouchedSpotIndicatorData(
                                line,
                                FlDotData(show: false),
                              );
                            },
                          ).toList();
                        },
                        getTouchLineEnd: (_, __) => double.infinity),
                    baselineY: 0,
                    minY: minVal,
                    maxY: maxVal,

                    ///rangeAnnotations
                    rangeAnnotations:RangeAnnotations(
                      // verticalRangeAnnotations:[
                      //   VerticalRangeAnnotation(x1: 1,x2: 2),
                      //   VerticalRangeAnnotation(x1: 3,x2: 4)
                      // ],
                        horizontalRangeAnnotations: [
                          //HorizontalRangeAnnotation(y1: 89,y2: 90,color: Colors.redAccent),
                          // HorizontalRangeAnnotation(y1: 3,y2: 4),
                          // HorizontalRangeAnnotation(y1: 5,y2: 6),
                        ]
                    ) ,

                    backgroundColor: Colors.white10,
                    borderData: FlBorderData(
                        border: const Border(
                          bottom: BorderSide(),
                          left: BorderSide(),
                          top: BorderSide(),
                          //right: BorderSide(),
                        )),
                    gridData: FlGridData(show: false, horizontalInterval: 50, verticalInterval: 1),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                      //leftTitles: AxisTitles(sideTitles: leftTitles),
                      topTitles: AxisTitles(sideTitles: topTitles),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        ///fill
                        // belowBarData: BarAreaData(
                        //     color: Colors.blue,
                        //     //cutOffY: 0,
                        //     //ap aplyCutOffY: true,
                        //     spotsLine: BarAreaSpotsLine(
                        //       show: true,
                        //     ),
                        //     show: true
                        // ),
                        dotData: FlDotData(
                          show: false,
                        ),
                        show: true,
                        preventCurveOverShooting: false,
                        //showingIndicators:[0,5,6],
                        isCurved: true,
                        isStepLineChart: false,
                        isStrokeCapRound: false,
                        isStrokeJoinRound: false,

                        barWidth: 3.0,
                        curveSmoothness: 0.02,
                        preventCurveOvershootingThreshold: 10.0,
                        lineChartStepData: LineChartStepData(stepDirection: 0),
                        //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                        color: Colors.blue,
                        //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),

                        spots: gc.generateSpots(data_points),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //#################################################################
  //#################################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  GetBuilder<HomePageCtr>(
            id:'appBar',
            builder: (_) {
            return Text('${ DateFormat('HH:mm:ss').format(DateTime.now())}');
          }
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(left: 0.0),
            icon: const Icon(Icons.add),
            onPressed: () {
              gc.addServer(context);
              //sharedPrefs!.clear();
            },
          ),
          GetBuilder<HomePageCtr>(
            id:'appBar',
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: Container(),
                  dropdownColor: Colors.blue,
                  value: gc.selectedServer,
                  items: gc.servers.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                         if(gc.selectedServer != value) GestureDetector(
                            child: Icon(
                              size: 20,
                              Icons.close,
                              color: Colors.red,
                            ),
                            onTap: () {
                              showNoHeader(txt: 'Are you sure you want to remove this server ?').then((toRemove) {
                                if (toRemove) {
                                  gc.removeServer('$value');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    gc.changeServer(newValue);
                  },
                ),
              );
            }
          ),
        ],
      ),
      drawer: drawer,
      body: GetBuilder<HomePageCtr>(
        id: 'chart',
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: gc.selectedServer != null ? gc.selectedServer != ''?
            SingleChildScrollView(
              child: Column(
                //shrinkWrap: true,
                //mainAxisAlignment: MainAxisAlignment.end,

                children: [


                  chartGraph(
                    gc.gas_data,
                      'Gas',
                      gc.gasDataPts,
                    getDoubleMinValue(gc.gasDataPts)-20.0,
                    getDoubleMaxValue(gc.gasDataPts)+20.0,
                  ),
                  SizedBox(height: 20,),
                  chartGraph(
                    gc.tem_data,
                      'Temperature',
                      gc.tempDataPts,
                    getDoubleMinValue(gc.tempDataPts)-20.0,
                    getDoubleMaxValue(gc.tempDataPts)+20.0,
                  ),
                  SizedBox(height: 20,),
                  chartGraph(
                    gc.noise_data,
                      'Noise',
                      gc.noiseDataPts,
                    getDoubleMinValue(gc.noiseDataPts)-200.0,
                    getDoubleMaxValue(gc.noiseDataPts)+200.0,
                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ):Center(
              child: Text(
                'no server selected',
                style: TextStyle(
                    fontSize: 17
                ),
              ),
            ):Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
      // floatingActionButton: ElevatedButton.icon(
      //   onPressed: () {
      //     setState(() {
      //       _isRunning = !_isRunning;
      //       if(!_isRunning){
      //         gc.realTimeListen();
      //       }
      //     });
      //   },
      //
      //   icon: _isRunning ? Icon(Icons.stop,color:  Colors.red,) : Icon(Icons.play_arrow,color: Colors.green,),
      //   label: Text(_isRunning ? 'Stop' : 'Start'),
      //   //textColor: Colors.white,
      // )
    );
  }
}
