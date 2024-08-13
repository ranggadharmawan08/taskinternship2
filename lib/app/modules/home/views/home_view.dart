import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_game/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => controller.addNumber(text),
      child: Text(text, style: const TextStyle(fontSize: 24, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 65, 60, 60),
        fixedSize: const Size(50, 50),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildOutlinedContainer(String text, {double fontSize = 48}) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: controller.outlineColor.value,
              width: 2.0,
            ),
            borderRadius:
                BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: controller.answerColor.value,
            ),
          ),
        ));
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.starColors.length, (index) {
        return Obx(() => Icon(
              Icons.star,
              color: controller.starColors[index].value,
              size: 35,
            ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 21, 21),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.arrow_upward_outlined, color: Colors.white),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.refresh_outlined, color: Colors.white),
              onPressed: controller.generateRandomNumbers,
            ),
            const SizedBox(width: 40),
            _buildStars(),
            Spacer(),
            Obx(() => Icon(
              Icons.arrow_forward_ios_outlined,
              color: controller.iconColor1.value,
              size: 30,
            )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Stack(
                    alignment: Alignment.center,
                    children: [
                      // Menampilkan angka
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 150),
                                child: Text(
                                  '${controller.firstNumber.value}',
                                  style: const TextStyle(fontSize: 60, color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '+ ${controller.secondNumber.value}',
                            style: const TextStyle(fontSize: 60, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                      // Menampilkan animasi jika ada
                      if (controller.showLottieAnimation.value)
                        Positioned.fill(
                          child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              'assets/animation/firework.gif', // Pastikan file GIF berada di folder assets
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  )),
              const Divider(
                thickness: 2,
                indent: 100,
                endIndent: 100,
              ),
              const SizedBox(height: 20),
              Obx(() => _buildOutlinedContainer(controller.userAnswer.value)),
              const SizedBox(height: 70),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildButton('0'),
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                ],
              ),
              const SizedBox(height: 30),
              Obx(() => ElevatedButton.icon(
                onPressed: controller.onButtonPressed,
                icon: Icon(controller.buttonIcon.value, size: 24, color: controller.iconColor.value),
                label: const Text(''),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), backgroundColor: Color.fromARGB(255, 65, 60, 60),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
