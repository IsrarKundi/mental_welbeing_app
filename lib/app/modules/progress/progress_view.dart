import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../theme/app_colors.dart';
import '../../widgets/liquid_glass_container.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Your wellness journey',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: Colors.white60,
              ),
            ),
          ],
        ),
        LiquidGlassContainer(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          borderRadius: 20.r,
          isAnimate: false,
          linearGradient: LinearGradient(
            colors: [
              AppColors.cyanAccent.withOpacity(0.15),
              AppColors.cyanAccent.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              AppColors.cyanAccent.withOpacity(0.3),
              AppColors.cyanAccent.withOpacity(0.1),
            ],
          ),
          child: Row(
            children: [
              Icon(LucideIcons.flame, size: 12.sp, color: AppColors.cyanAccent),
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
            LucideIcons.activity,
          ),
          _buildMiniMetric(
            'MINUTES',
            '${controller.totalMinutes.value}',
            LucideIcons.clock,
          ),
          _buildMiniMetric(
            'GOAL',
            '${(controller.progressPercent * 100).toInt()}%',
            LucideIcons.target,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMiniMetric(String label, String value, IconData icon) {
    return LiquidGlassContainer(
      width: 105.w,
      padding: EdgeInsets.all(12.r),
      borderRadius: 14.r,
      isAnimate: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 10.sp, color: Colors.white60),
              SizedBox(width: 4.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60, // Increased contrast
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
    return LiquidGlassContainer(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      borderRadius: 20.r,
      isAnimate: false,
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
                        color: Colors.white54, // Increased contrast
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
        final displayMax = math
            .max(maxVal, controller.dailyGoal.value.toDouble().toInt())
            .clamp(1, 999);

        return Stack(
          children: [
            // Horizontal grid lines (25%, 50%, 75%)
            Positioned.fill(
              bottom: 20.h, // Leave space for labels
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGridLine(),
                  _buildGridLine(),
                  _buildGridLine(),
                ],
              ),
            ),
            // Bar chart
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                double heightFactor = 0;
                if (data[index] > 0) {
                  heightFactor = math.sqrt(data[index]) / math.sqrt(displayMax);
                }
                final barHeight = heightFactor * 54.h;
                final isToday = index == data.length - 1;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bar with divider
                      Container(
                        height: data[index] == 0
                            ? 3.h
                            : barHeight.clamp(6.h, 54.h),
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          color: isToday
                              ? AppColors.cyanAccent
                              : AppColors.cyanAccent.withOpacity(0.5),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(3.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Day label
                      Text(
                        controller.weekDays[index],
                        style: GoogleFonts.poppins(
                          fontSize: 8.sp,
                          color: isToday ? Colors.white : Colors.white38,
                          fontWeight: isToday
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildGridLine() {
    return Container(height: 1, color: Colors.white.withOpacity(0.06));
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
            height: 115.h,
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
    final progressText = a.target == 600
        ? '${(a.current / 60).toStringAsFixed(0)}/${(a.target / 60).toStringAsFixed(0)}h'
        : '${a.current}/${a.target}';

    return LiquidGlassContainer(
      width: 100.w,
      height: 110.h, // Explicit height to prevent layout crash
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      borderRadius: 16.r,
      isAnimate: false,
      linearGradient: a.isUnlocked
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                unlockedColor.withOpacity(0.2),
                unlockedColor.withOpacity(0.1),
              ],
            )
          : null,
      borderGradient: a.isUnlocked
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                unlockedColor.withOpacity(0.5),
                unlockedColor.withOpacity(0.2),
              ],
            )
          : null,
      border: a.isUnlocked ? 1.5 : 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon (no glow for cleaner look)
          Container(
            padding: EdgeInsets.all(4.r),
            child: Text(
              a.icon,
              style: TextStyle(
                fontSize: 24.sp,
                color: a.isUnlocked ? null : Colors.white24,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          // Title
          Text(
            a.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: a.isUnlocked
                  ? Colors.white
                  : Colors.white60, // Increased contrast
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // Progress bar or checkmark
          if (a.isUnlocked)
            Icon(Icons.check_circle, color: unlockedColor, size: 14.sp)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Progress bar
                Container(
                  height: 4.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: a.progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: unlockedColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Progress text
                Text(
                  progressText,
                  style: GoogleFonts.poppins(
                    fontSize: 7.sp,
                    color: Colors.white38,
                  ),
                ),
              ],
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
                LiquidGlassContainer(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  margin: EdgeInsets.only(bottom: 20.h),
                  borderRadius: 16.r,
                  isAnimate: false,
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
                                color: Colors.white70, // Increased contrast
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

    if (activityDate.isAtSameMomentAs(today)) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (activityDate.isAtSameMomentAs(yesterday)) {
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
      final sweepAngle = 2 * math.pi * progress;

      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressRadialPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
