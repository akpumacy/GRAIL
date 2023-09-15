import 'package:flutter/material.dart';
import 'package:get/get.dart';

customSnackBar(title, subtitle, color) {
  Get.snackbar(title, subtitle,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withOpacity(0.8));
}