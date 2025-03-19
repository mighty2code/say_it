import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoUtils {
  /// Show a snackbar message
  static void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  /// Show an info popup dialog
  static void showPopup(String title, String message) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    );
  }
}
