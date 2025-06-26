import 'package:toastification/toastification.dart';

import 'package:flutter/material.dart';

void showCustomToast({
  required String title,
  required String description,
  ToastificationType type = ToastificationType.success,
  Duration duration = const Duration(seconds: 4),
}) {
  toastification.show(
    type: type,
    style: ToastificationStyle.flat,
    title: Text(
      title,
    ),
    description: Text(
      description,
    ),
    alignment: Alignment.topRight,
    autoCloseDuration: duration,
    icon: Icon(Icons.check_circle),
    backgroundColor: Colors.white,
    dragToClose: true,
    borderRadius: BorderRadius.circular(10),
    showProgressBar: true,
  );
}
