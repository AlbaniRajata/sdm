import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class CustomLoading{
  static void showLoading(BuildContext context ){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds:  100),
          builder: (context, value, child){
            return LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 60,
            );
          }
        );
      }
    );
  }
  static void closeLoading(BuildContext context){
    Navigator.of(context, rootNavigator: true).pop();
  }
}