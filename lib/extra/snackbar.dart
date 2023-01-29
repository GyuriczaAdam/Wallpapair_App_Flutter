import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Snackbar{
  static void show(BuildContext context, String message, ContentType type){
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: type == ContentType.success ? 'Success' : 'Error',
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
  }
}