import 'dart:async'; // Import untuk Future.delayed
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var firstNumber = 0.obs;
  var secondNumber = 0.obs;
  var userAnswer = ''.obs;
  var answerColor = Rx<Color>(Colors.blue);
  var outlineColor = Rx<Color>(Colors.white);
  var starColors = List<Rx<Color>>.generate(2, (_) => Rx<Color>(Colors.green));
  var iconColor = Rx<Color>(Colors.green);
  var buttonIcon = Rx<IconData>(Icons.check);
  var iconColor1 = Rx<Color>(Colors.white);
  var showLottieAnimation = RxBool(false);

  final animationDuration = Duration(seconds: 2); // Durasi animasi

  @override
  void onInit() {
    super.onInit();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    firstNumber.value = random.nextInt(100);
    secondNumber.value = random.nextInt(100);
    userAnswer.value = '';
    answerColor.value = Colors.blue;
    outlineColor.value = Colors.white;
    iconColor.value = Colors.green;
    iconColor1.value = Colors.white;
    buttonIcon.value = Icons.check;

    for (var star in starColors) {
      star.value = Colors.green;
    }
    showLottieAnimation.value = false; // Reset animasi
  }

  void addNumber(String number) {
    userAnswer.value += number;
    answerColor.value = Colors.blue;
    outlineColor.value = Colors.white;
  }

  void checkAnswer() {
    int correctAnswer = firstNumber.value + secondNumber.value;
    if (int.tryParse(userAnswer.value) == correctAnswer) {
      answerColor.value = Colors.green;
      outlineColor.value = Colors.green;
      iconColor.value = Colors.green;
      iconColor1.value = Colors.green;
      buttonIcon.value = Icons.arrow_forward_ios_outlined;
      showLottieAnimation.value = true; // Tampilkan animasi saat jawaban benar
      _hideAnimationAfterDelay(); // Panggil metode untuk menyembunyikan animasi setelah delay
    } else {
      answerColor.value = Colors.red;
      outlineColor.value = Colors.red;
      updateStarColor();
      if (buttonIcon.value == Icons.check) {
        iconColor.value = Colors.red;
      }
    }
  }

  void _hideAnimationAfterDelay() {
    Future.delayed(animationDuration, () {
      showLottieAnimation.value = false; // Sembunyikan animasi setelah durasi
    });
  }

  void updateStarColor() {
    for (int i = 0; i < starColors.length; i++) {
      if (starColors[i].value == Colors.green) {
        starColors[i].value = Colors.red;
        break;
      }
    }
  }

  void onButtonPressed() {
    if (buttonIcon.value == Icons.arrow_forward_ios_outlined) {
      generateRandomNumbers();
    } else {
      checkAnswer();
    }
  }
}
