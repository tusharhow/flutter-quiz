import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuizController extends GetxController {
  var currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  late Future quiz;
  int points = 0;
  var isLoaded = false;
  var optionsList = [];
  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
      }
      update();
    });
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  var url = "https://opentdb.com/api.php?amount=20";

  Future<void> getQuiz() async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("Success, data: $data");
      return data;
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.red,
        borderWidth: 2,
      );
    }
  }

  @override
  void onInit() {
    quiz = getQuiz();
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    timer!.cancel();
    super.onClose();
  }
}
