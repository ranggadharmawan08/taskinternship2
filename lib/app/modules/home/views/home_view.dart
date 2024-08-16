import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:math_game/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
            const SizedBox(width: 20),
            _buildStars(),
            const Spacer(),
            Obx(() => Icon(
              Icons.arrow_forward_ios_outlined,
              color: controller.iconColor1.value,
              size: 30,
            )),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Bagian utama UI
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 180),
                                      child: Text(
                                        '${controller.firstNumber.value}',
                                        style: const TextStyle(
                                            fontSize: 60,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '+ ${controller.secondNumber.value}',
                                  style: const TextStyle(
                                      fontSize: 60, color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            // Menampilkan animasi jika ada
                            if (controller.showLottieAnimation.value)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Image.asset(
                                    'assets/animation/firework.gif',
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
                    Obx(() =>
                        _buildOutlinedContainer(controller.userAnswer.value)),
                    const SizedBox(height: 70),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(10, (index) {
                        return GestureDetector(
                          onPanStart: (details) {
                            controller.updateArrow(details.globalPosition);
                          },
                          onPanUpdate: (details) {
                            controller.updateArrow(details.globalPosition);
                          },
                          onPanEnd: (details) {
                            controller.addNumber(index.toString());
                            controller.hideArrow();
                          },
                          child: ElevatedButton(
                            onPressed: null,
                            child: Text(index.toString(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 65, 60, 60),
                              fixedSize: const Size(50, 50),
                              shape: const CircleBorder(),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    Obx(() => ElevatedButton.icon(
                          onPressed: controller.onButtonPressed,
                          icon: Icon(controller.buttonIcon.value,
                              size: 24, color: controller.iconColor.value),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            backgroundColor:
                                const Color.fromARGB(255, 65, 60, 60),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            // Layer untuk animasi panah
            Obx(() {
              if (controller.arrowStart.value != null &&
                  controller.arrowEnd.value != null) {
                return CustomPaint(
                  painter: ArrowPainter(
                    start: controller.arrowStart.value!,
                    end: controller.arrowEnd.value!,
                  ),
                  child: Container(),
                );
              }
              return Container();
            }),
            // Menentukan posisi target untuk kolom jawaban
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100, // Sesuaikan dengan ukuran kolom jawaban
              child: LayoutBuilder(
                builder: (context, constraints) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.setAnswerPosition(Offset(
                        constraints.maxWidth / 2, constraints.maxHeight - 50));
                  });
                  return Container(
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: controller.outlineColor.value, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 36, color: controller.answerColor.value),
      ),
    );
  }

  Widget _buildStars() {
    return Obx(() {
      final stars = <Widget>[];
      for (var i = 0; i < 2; i++) {
        stars.add(
          Icon(
            Icons.star,
            color: controller.starColors[i].value,
            size: 30,
          ),
        );
        if (i < 2) stars.add(const SizedBox(width: 10));
      }
      return Row(children: stars);
    });
  }
}

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  ArrowPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green // Warna panah bisa disesuaikan
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    // Menambahkan kepala panah
    final arrowHead = _createArrowHead(start, end);
    path.addPath(arrowHead, Offset.zero);

    canvas.drawPath(path, paint);
  }

  Path _createArrowHead(Offset start, Offset end) {
    const arrowHeadSize = 20;
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final path = Path();

    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowHeadSize * cos(angle - pi / 3),
      end.dy - arrowHeadSize * sin(angle - pi / 3),
    );
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowHeadSize * cos(angle + pi / 3),
      end.dy - arrowHeadSize * sin(angle + pi / 3),
    );

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
