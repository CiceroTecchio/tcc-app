import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext?.findRenderObject();
  return renderBox?.size;
}

Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    messageText: Text(message, style: TextStyle(fontSize: 20, color: Colors.white)),
    icon: Icon(
      Icons.check,
      size: 35.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    messageText: Text(message, style: TextStyle(fontSize: 20, color: Colors.white)),
    icon: Icon(
      Icons.error,
      size: 35.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}
