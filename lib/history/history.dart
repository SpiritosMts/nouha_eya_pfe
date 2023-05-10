import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:server_room/history/history_ctr.dart';
import 'package:server_room/home_page/home_page_ctr.dart';
import 'package:intl/intl.dart';

import '../my_ui.dart';
import '../my_voids.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  final HistoryCtr gc = Get.put<HistoryCtr>(HistoryCtr());


 Widget chartGraph(dataName,dataList,minVal,maxVal,wid){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${dataName} History', textAlign: TextAlign.left, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: MediaQuery.of(context).size.height /3,
            width: MediaQuery.of(context).size.height *wid,
            //SingleChildScrollView / scrollDirection: Axis.horizontal,
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
                                formatNumberAfterComma('${dataList[touchedSpot.spotIndex]}'),
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
                    minY:minVal,
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
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      //leftTitles: AxisTitles(sideTitles: leftTitlesHistory),
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
                        curveSmoothness: 0.25,
                        preventCurveOvershootingThreshold: 10.0,
                        lineChartStepData: LineChartStepData(stepDirection: 0),
                        //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                        color: Colors.blue,
                        //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),

                        spots: gc.generateSpots(dataList),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:  GetBuilder<HomePageCtr>(
            id:'appBar',
            builder: (_) {
              return Text('History');
            }
        ),

      ),
      body: GetBuilder<HomePageCtr>(
          id: 'chart',
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: (gc.gas_history.isNotEmpty && gc.noise_history.isNotEmpty && gc.temp_history.isNotEmpty ) ?
              SingleChildScrollView(
                child: Column(
                  //shrinkWrap: true,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    chartGraph(
                        'temperature',
                        gc.temp_history,
                        double.parse(getMinValue(gc.temp_history))-1.1,
                        double.parse(getMaxValue(gc.temp_history))+1.0,
                        gc.temp_history.length/13
                    ),
                    chartGraph(
                        'gas',
                        gc.gas_history,
                        double.parse(getMinValue(gc.gas_history))-2.0,
                        double.parse(getMaxValue(gc.gas_history))+2.0,
                        gc.gas_history.length/13
                    ),
                    chartGraph(
                        'sound',
                        gc.noise_history,
                        double.parse(getMinValue(gc.noise_history))-2.0,
                        double.parse(getMaxValue(gc.noise_history))+2.0,
                        gc.noise_history.length/13
                    ),
                    SizedBox(height: 20)
                  ],
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
