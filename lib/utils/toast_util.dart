import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
 static void showToast(String message,
     {Toast time = Toast.LENGTH_SHORT,
       ToastGravity gravity = ToastGravity.BOTTOM,
       Color background = const Color(0x80000000),
       Color textColor = Colors.white,
       double fontSize = 14
     }) {
   Fluttertoast.showToast(msg: message,
       toastLength: time,
       gravity: gravity,
       backgroundColor: background,
       textColor:Colors.white,
       fontSize: fontSize);
 }
}