import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:server_room/main.dart';
import 'package:server_room/models/user.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

SrUser currentUser = SrUser();
 FirebaseDatabase? get database => FirebaseDatabase.instance;

var usersColl = FirebaseFirestore.instance.collection('users');

Future<List<DocumentSnapshot>> getDocumentsByColl(coll) async {
  QuerySnapshot snap = await coll.get();

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection docs number => (${documentsFound.length})');

  return documentsFound;
}

toastShow(text, {Color? color}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor:color?? Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

double getDoubleMinValue(List<double> values) {
  return values.reduce((currentMin, value) => value < currentMin ? value : currentMin);
}
double getDoubleMaxValue(List<double> values) {
  return values.reduce((currentMax, value) => value > currentMax ? value : currentMax);
}

double replaceWithClosestHalf(double value) {
  int intValue = value.toInt();
  double decimalPart = value - intValue;

  if (decimalPart < 0.25) {
    return intValue.toDouble();
  } else if (decimalPart >= 0.25 && decimalPart < 0.75) {
    return intValue.toDouble() + 0.5;
  } else {
    return intValue.toDouble() + 1.0;
  }
}

double getMinValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double minValue = doubleList.reduce((currentMin, value) => value < currentMin ? value : currentMin);
  return minValue;
}

double getMaxValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double maxValue = doubleList.reduce((currentMax, value) => value > currentMax ? value : currentMax);
  return maxValue;
}

// String getMinValue(List<String> values) {
//   return values.reduce((currentMin, value) {
//     return (value.compareTo(currentMin) < 0) ? value : currentMin;
//   });
// }
// String getMaxValue(List<String> values) {
//   return values.reduce((currentMax, value) {
//     return (value.compareTo(currentMax) > 0) ? value : currentMax;
//   });
// }

String formatNumberAfterComma(String number) {
  //final string = number.toString();
  if(number.contains('.')){
    final decimalIndex = number.indexOf('.');
    final end = min(decimalIndex + 3, number.length);
    return number.substring(0, end);
  }else{
    return number;
  }

}

dialogShow(title, desc, {bool isSuccessful = false, bool autoHide = false}) {
  AwesomeDialog(
    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.leftSlide,
    dialogType: isSuccessful ? DialogType.success : DialogType.error,
    //showCloseIcon: true,
    title: title,
    autoHide: autoHide ? Duration(seconds: 1) : null,

    btnOkColor: isSuccessful ? Color(0xFF00B962) : Color(0xFFD0494A),
    descTextStyle: TextStyle(
      height: 1.8,
      fontSize: 14,
    ),
    desc: desc,
    btnOkText: 'Ok',

    btnOkOnPress: () {},
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}

Future<bool> showNoHeader({String? txt,String? btnOkText='delete',Color btnOkColor=Colors.red,IconData? icon=Icons.delete}) async {
  bool shouldDelete = false;

  await AwesomeDialog(
    context: navigatorKey.currentContext!,
    autoDismiss: true,
    isDense: true,
    dismissOnTouchOutside: true,
    showCloseIcon: false,
    headerAnimationLoop: false,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnCancelIcon: Icons.close,
    btnCancelColor: Colors.grey,
    btnOkIcon: icon ?? Icons.delete,
    btnOkColor: btnOkColor,
    buttonsTextStyle: TextStyle(fontSize: 17),
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    // texts
    title: 'Verification',
    desc: txt ?? 'Are you sure you want to deny this user request',
    btnCancelText: 'cancel',
    btnOkText: btnOkText! ,

    // buttons functions
    btnOkOnPress: () {
      shouldDelete = true;
    },
    btnCancelOnPress: () {
      shouldDelete = false;
    },




  ).show();
  return shouldDelete;
}


/// add DOCUMENT to fireStore
Future<void> addDocument({required fieldsMap, required String collName, bool addID = true}) async {
  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.add(fieldsMap).then((value) async {
    print("## DOC ADDED TO <$collName>");

    //add id to doc
    if (addID) {
      String docID = value.id;
      //set id
      coll.doc(docID).update(
        {
          'id': docID,
        },
        //SetOptions(merge: true),
      );
    }
  }).catchError((error) {
    print("## Failed to add doc to <$collName>: $error");
  });
}
