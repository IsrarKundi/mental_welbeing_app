import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';
import 'progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: Obx(
            () => Skeletonizer(
              enabled: controller.isLoading.value,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    _buildCompactHeader(),
                    SizedBox(height: 14.h),
                    _buildCompactSummaryStrip(),
                    SizedBox(height: 14.h),
                    _buildIntegratedDashboard(),
                    SizedBox(height: 14.h),
                    _buildAchievementsSection(),
                    SizedBox(height: 14.h),
                    _buildTimelineSection(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Your wellness journey',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.cyanAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.cyanAccent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Text('🔥', style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 4.w),
              Obx(
                () => Text(
                  '${controller.currentStreak.value} Day Streak',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyanAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCompactSummaryStrip() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMiniMetric(
            'SESSIONS',
            '${controller.totalSessions.value}',
            '🧘',
          ),
          _buildMiniMetric('MINUTES', '${controller.totalMinutes.value}', '⏱️'),
          _buildMiniMetric(
            'GOAL',
            '${(controller.progressPercent * 100).toInt()}%',
            '🎯',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMiniMetric(String label, String value, String icon) {
    return Container(
      width: 105.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 10.sp)),
              SizedBox(width: 4.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegratedDashboard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Weekly Chart
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WEEKLY CONSISTENCY',
                      style: GoogleFonts.poppins(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white30,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildCompactBarChart(),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Right side: Goal Ring
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DAILY GOAL',
                      style: GoogleFonts.poppins(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cyanAccent.withOpacity(0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildCompactGoalRing(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          SizedBox(height: 12.h),
          Obx(
            () => Text(
              controller.goalMessage,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildCompactBarChart() {
    return SizedBox(
      height: 80.h,
      child: Obx(() {
        final data = controller.weeklyActivityData;
        final maxVal = data.fold<int>(0, (m, v) => v > m ? v : m);
        final displayMax = maxVal == 0 ? 5 : maxVal + 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(data.length, (index) {
            final barHeight = (data[index] / displayMax) * 60.h;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 14.w,
                  height: barHeight.clamp(4.h, 60.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.cyanAccent,
                        AppColors.cyanAccent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.weekDays[index],
                  style: GoogleFonts.poppins(
                    fontSize: 8.sp,
                    color: index == 6 ? Colors.white : Colors.white24,
                    fontWeight: index == 6
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }

  Widget _buildCompactGoalRing() {
    return SizedBox(
      width: 70.w,
      height: 70.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => CustomPaint(
              size: Size(70.w, 70.w),
              painter: ProgressRadialPainter(
                progress: controller.progressPercent,
                color: AppColors.cyanAccent,
                strokeWidth: 4.w,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  '${controller.dailyProgress.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '/${controller.dailyGoal.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 8.sp,
                    color: Colors.white38,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Achievements',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => SizedBox(
            height: 95.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.achievements.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final a = controller.achievements[index];
                return _buildCompactAchievement(a);
              },
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildCompactAchievement(Achievement a) {
    final unlockedColor = Color(a.color);
    return Container(
      width: 90.w,
      decoration: BoxDecoration(
        color: a.isUnlocked
            ? unlockedColor.withOpacity(0.12)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: a.isUnlocked
              ? unlockedColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            a.icon,
            style: TextStyle(
              fontSize: 26.sp,
              color: a.isUnlocked ? null : Colors.white12,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            a.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: a.isUnlocked ? Colors.white70 : Colors.white12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Recent Journey',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recentActivities.length,
            itemBuilder: (context, index) {
              return _buildTimelineItem(
                controller.recentActivities[index],
                isLast: index == controller.recentActivities.length - 1,
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildTimelineItem(RecentActivity activity, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical Line & Dot
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                Container(
                  width: 12.r,
                  height: 12.r,
                  decoration: BoxDecoration(
                    color: activity.type == 'Mood'
                        ? const Color(0xFFFBBF24)
                        : AppColors.cyanAccent,
                    shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color:
                    //         (activity.type == 'Mood'
                    //                 ? const Color(0xFFFBBF24)
                    //                 : AppColors.cyanAccent)
                    //             .withOpacity(0.4),
                    //     blurRadius: 8,
                    //     spreadRadius: 1,
                    //   ),
                    // ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Content Card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Text(activity.icon, style: TextStyle(fontSize: 20.sp)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${activity.type} • ${_formatDateTime(activity.date)}',
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (activity.type == 'Activity')
                        Text(
                          activity.duration,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tealAccent,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final activityDate = DateTime(date.year, date.month, date.day);

    if (activityDate == today) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (activityDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

class ProgressRadialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ProgressRadialPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Background track
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0.001) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = 2 * pi * progress;

      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressRadialPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
