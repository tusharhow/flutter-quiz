import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quiz/app/controllers/quiz_controller.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<QuizController>(
            init: QuizController(),
            builder: (controller) {
              return controller.seconds == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "Time Over",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            controller.resetColors();
                            controller.currentQuestionIndex = 0;
                            controller.seconds = 60;
                            controller.points = 0;
                            controller.getQuiz();
                            controller.update();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width - 150,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "Restart",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      child: FutureBuilder(
                        future: controller.quiz,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data["results"];

                            if (controller.isLoaded == false) {
                              controller.optionsList =
                                  data[controller.currentQuestionIndex]
                                      ["incorrect_answers"];
                              controller.optionsList.add(
                                  data[controller.currentQuestionIndex]
                                      ["correct_answer"]);
                              controller.optionsList.shuffle();
                              controller.isLoaded = true;
                            }

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.resetColors();
                                          controller.currentQuestionIndex = 0;
                                          controller.seconds = 60;
                                          controller.points = 0;
                                          controller.getQuiz();
                                          controller.update();
                                        },
                                        icon: const Icon(
                                          Icons.restart_alt,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          normalText(
                                              color: Colors.white,
                                              size: 20,
                                              text: "${controller.seconds}"),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              value: controller.seconds / 60,
                                              valueColor:
                                                  const AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      normalText(
                                          color: Colors.white,
                                          size: 35,
                                          text: "${controller.points}"),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Image.asset('assets/images/choose.png',
                                      width: 180),
                                  const SizedBox(height: 40),
                                  Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: normalText(
                                              color: lightgrey,
                                              size: 18,
                                              text:
                                                  "Question ${controller.currentQuestionIndex + 1} of ${data.length}")),
                                      const SizedBox(height: 20),
                                      normalText(
                                          color: Colors.white,
                                          size: 20,
                                          text: data[controller
                                                  .currentQuestionIndex]
                                              ["question"]),
                                      const SizedBox(height: 30),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            controller.optionsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var answer = data[controller
                                                  .currentQuestionIndex]
                                              ["correct_answer"];

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (answer.toString() ==
                                                    controller
                                                        .optionsList[index]
                                                        .toString()) {
                                                  controller
                                                          .optionsColor[index] =
                                                      Colors.green;

                                                  controller.points =
                                                      controller.points + 10;
                                                } else {
                                                  controller
                                                          .optionsColor[index] =
                                                      Colors.red;

                                                  controller.points =
                                                      controller.points - 5;
                                                }

                                                if (controller
                                                        .currentQuestionIndex <
                                                    data.length - 1) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    controller.isLoaded = false;
                                                    controller
                                                        .currentQuestionIndex++;
                                                    controller.resetColors();
                                                    controller.timer!.cancel();
                                                    controller.seconds = 60;
                                                    controller.startTimer();
                                                  });
                                                } else {
                                                  controller.timer!.cancel();
                                                }
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 15),
                                              alignment: Alignment.center,
                                              width: size.width - 100,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .optionsColor[index],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: headingText(
                                                color: Colors.black,
                                                size: 16,
                                                text: controller
                                                    .optionsList[index]
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            );
                          }
                        },
                      ),
                    );
            }),
      ),
    );
  }
}
