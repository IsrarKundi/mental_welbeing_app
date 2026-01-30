import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart' as sk;

import '../../theme/app_colors.dart';
import '../../widgets/glass_text_field.dart';
import 'chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  ChatDetailView({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  // Scroll to bottom is now handled natively by reverse: true

  @override
  Widget build(BuildContext context) {
    // List is reversed (reverse:true), so it stays at the bottom natively

    return Scaffold(
      backgroundColor: AppColors.deepOceanBlue,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final mentor = controller.activeMentor.value;
          return Row(
            children: [
              Hero(
                tag: 'mentor_avatar_${mentor?.id}',
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: mentor != null
                      ? NetworkImage(mentor.avatarUrl)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mentor?.name ?? 'Mentor',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    mentor?.trait ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value &&
                    controller.messages.isEmpty) {
                  return _buildLoadingHistory();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  itemCount:
                      controller.messages.length +
                      (controller.isThinking.value ? 1 : 0),
                  reverse: true,
                  itemBuilder: (context, index) {
                    if (controller.isThinking.value && index == 0) {
                      return _buildThinkingIndicator();
                    }

                    final msgIndex = controller.isThinking.value
                        ? index - 1
                        : index;
                    final message = controller.messages[msgIndex];

                    return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: message.isUser
                                ? _buildUserBubble(message.text)
                                : _buildMentorBubble(message.text),
                          ),
                        )
                        .animate()
                        .fade(duration: const Duration(milliseconds: 400))
                        .slideY(begin: 0.1, end: 0);
                  },
                );
              }),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingHistory() {
    return sk.Skeletonizer(
      enabled: true,
      effect: sk.ShimmerEffect(
        baseColor: Colors.white.withOpacity(0.05),
        highlightColor: Colors.white.withOpacity(0.1),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        itemCount: 8,
        itemBuilder: (context, index) {
          final isUser = index % 3 == 0;
          final widths = [0.4, 0.7, 0.35, 0.6, 0.5, 0.75, 0.45, 0.3];
          final bubbleWidth = Get.width * widths[index % widths.length];
          final isLong = (index % 4 == 0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: bubbleWidth,
                height: isLong ? 72 : 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isUser ? 24 : 4),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(isUser ? 4 : 24),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child:
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Thinking',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white38,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: const Duration(milliseconds: 1500),
                  color: Colors.white12,
                ),
      ),
    );
  }

  Widget _buildMentorBubble(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cyanAccent.withOpacity(0.8),
            AppColors.cyanAccent.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(4),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.cyanAccent.withOpacity(0.1),
        //     blurRadius: 10,
        //     spreadRadius: 2,
        //   ),
        // ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildInputArea() {
    final TextEditingController textController = TextEditingController();
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 20,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassTextField(
              controller: textController,
              hintText: 'Type a message...',
              onSend: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.sendMessage(textController.text);
                  textController.clear();
                }
              },
            ),
          ).animate().shimmer(
            duration: const Duration(seconds: 3),
            color: Colors.white10,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
