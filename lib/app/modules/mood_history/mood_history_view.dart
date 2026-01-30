import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import 'mood_history_controller.dart';

class MoodHistoryView extends GetView<MoodHistoryController> {
  const MoodHistoryView({Key? key}) : super(key: key);

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
          'Mood History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildStats(),
                const SizedBox(height: 24),
                _buildCalendar(),
                const SizedBox(height: 24),
                _buildSelectedDayDetail(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today,
                value: controller.totalLoggedDays.toString(),
                label: 'Days Logged',
                color: AppColors.cyanAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_emotions,
                value: controller.mostFrequentMood,
                label: 'Most Common',
                color: AppColors.tealAccent,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Month navigation
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.white70),
                ),
                Text(
                  controller.monthYearString,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: controller.nextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        day,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          Obx(
            () => Wrap(
              spacing: 0,
              runSpacing: 4,
              children: controller.daysInMonth.map((date) {
                return _buildDayCell(date);
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildDayCell(DateTime date) {
    final isCurrentMonth = date.month == controller.currentMonth.value.month;
    final isToday = _isToday(date);
    final mood = controller.getMoodForDate(date);
    final isSelected = _isSameDay(date, controller.selectedDate.value);

    return GestureDetector(
      onTap: isCurrentMonth ? () => controller.selectDate(date) : null,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cyanAccent.withOpacity(0.3)
              : isToday
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.cyanAccent, width: 2)
              : isToday
              ? Border.all(color: Colors.white30)
              : null,
        ),
        child: Center(
          child: mood != null
              ? Text(
                  mood.emoji,
                  style: TextStyle(
                    fontSize: isCurrentMonth ? 20 : 14,
                    color: isCurrentMonth ? null : Colors.white30,
                  ),
                )
              : Text(
                  '${date.day}',
                  style: GoogleFonts.poppins(
                    color: isCurrentMonth ? Colors.white70 : Colors.white30,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetail() {
    return Obx(() {
      final mood = controller.getMoodForDate(controller.selectedDate.value);
      final date = controller.selectedDate.value;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: mood != null
              ? Color(mood.color).withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: mood != null
                ? Color(mood.color).withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: mood != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(mood.emoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mood.label,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _formatDate(date),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (mood.note != null && mood.note!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notes, color: Color(mood.color), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              mood.note!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              )
            : Column(
                children: [
                  Icon(
                    Icons.sentiment_neutral,
                    color: Colors.white30,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No mood logged',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    _formatDate(date),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
      );
    }).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }
}
