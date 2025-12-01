import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import '../../widgets/liquid_glass_container.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.mainBackgroundGradient,
            ),
          ),
          Positioned(
            top: -100,
            left: -100,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyanAccent.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyanAccent.withOpacity(0.2),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(
                      begin: const Offset(0, 0),
                      end: const Offset(50, 50),
                      duration: 4000.ms,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.2, 1.2),
                      duration: 4000.ms,
                    ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child:
                Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.mutedPurple.withOpacity(0.4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mutedPurple.withOpacity(0.3),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(
                      begin: const Offset(0, 0),
                      end: const Offset(-30, -30),
                      duration: 5000.ms,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 5000.ms,
                    ),
          ),

          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.contents.length,
                  itemBuilder: (context, index) {
                    final content = controller.contents[index];
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiquidGlassContainer(
                            width: 200,
                            height: 200,
                            borderRadius: 100,
                            child: Icon(
                              content.icon,
                              size: 80,
                              color: Colors.white,
                            ),
                          ).animate().fadeIn(duration: 600.ms).scale(),
                          const SizedBox(height: 40),
                          Text(
                                content.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),
                          Text(
                                content.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicators and Button
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.contents.length,
                        (index) => Obx(
                          () => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: controller.currentPage.value == index
                                ? 24
                                : 8,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? AppColors.cyanAccent
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () =>
                          controller.currentPage.value ==
                              controller.contents.length - 1
                          ? GestureDetector(
                              onTap: controller.getStarted,
                              child: LiquidGlassContainer(
                                height: 60,
                                width: double.infinity,
                                borderRadius: 30,
                                child: Center(
                                  child: Text(
                                    'Get Started',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn().scale()
                          : const SizedBox(height: 60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
