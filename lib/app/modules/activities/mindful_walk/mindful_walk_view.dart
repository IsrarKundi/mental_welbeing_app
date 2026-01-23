import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import 'mindful_walk_controller.dart';

class MindfulWalkView extends GetView<MindfulWalkController> {
  const MindfulWalkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mindful Walk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final env = controller.currentEnvironment;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(env.color).withOpacity(0.3),
                const Color(0xFF0F172A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildEnvironmentSelector(),
                const Spacer(),
                _buildTimer(),
                const SizedBox(height: 32),
                _buildMindfulnessPrompt(),
                const Spacer(),
                _buildControls(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEnvironmentSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Path',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.environments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final env = controller.environments[index];
                return Obx(() {
                  final isSelected =
                      controller.selectedEnvironment.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectEnvironment(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(env.color).withOpacity(0.3)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Color(env.color)
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(env.icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            env.name.split(' ').first,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTimer() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Animated rings
              ...List.generate(3, (index) {
                return Container(
                  width: 200 + (index * 30.0),
                  height: 200 + (index * 30.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(env.color).withOpacity(0.1 + (index * 0.05)),
                      width: 1,
                    ),
                  ),
                );
              }),
              // Timer circle
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(env.color).withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(env.color).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(env.icon, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      controller.formattedTime,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMindfulnessPrompt() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(env.color).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.lightbulb_outline, color: Color(env.color), size: 24),
            const SizedBox(height: 8),
            Text(
              controller.currentPrompt,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              env.tip,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
      );
    }).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildControls() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.reset,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: controller.toggleWalking,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(env.color),
                boxShadow: [
                  BoxShadow(
                    color: Color(env.color).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                controller.isWalking.value
                    ? Icons.pause_rounded
                    : Icons.directions_walk_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.volume_up_rounded,
              color: Colors.white70,
              size: 28,
            ),
          ),
        ],
      );
    });
  }
}
