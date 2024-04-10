import 'package:cubex_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingUtil {
  late BuildContext context;

  LoadingUtil(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: CustomColor().appWhite,
                secondRingColor: CustomColor().appWhite,
                thirdRingColor: CustomColor().appWhite,
                size: 50,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }
}