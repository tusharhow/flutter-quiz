import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuizController extends GetxController {
  var currentQuestionIndex = 0;
  int seconds = 10;
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
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  void onInit() {
    quiz = getQuiz();
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    timer!.cancel();
    super.onClose();
  }
}
