import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CustomProgressDialog {
  ProgressDialog? _progressDialog;

  CustomProgressDialog._privateConstructor();

  static final CustomProgressDialog instance =
      CustomProgressDialog._privateConstructor();

  showHideProgressDialog(
    BuildContext context,
    String message,
    Color color,
  ) {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);
    _progressDialog!.style(
      message: message,
      progressWidget: Container(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
      messageTextStyle: const TextStyle(
        fontFamily: 'Avenir',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );

    _progressDialog!.show();
  }

  hideProgressDialog(Function function) {
    if (_progressDialog != null) {
      _progressDialog!.hide().then((value) {
        function;
        return true;
      });
    }
  }

  showSnackBar(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: Colors.green,
      ),
    );
  }
}
