import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import '../../widgets/glass_text_field.dart';
import '../../widgets/typewriter_text.dart';
import 'chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  ChatDetailView({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to bottom when messages list changes
    ever(controller.messages, (_) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });

    // Also scroll when thinking state changes
    ever(controller.isThinking, (_) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  itemCount:
                      controller.messages.length +
                      (controller.isThinking.value ? 1 : 0),
                  reverse: false,
                  itemBuilder: (context, index) {
                    if (index == controller.messages.length &&
                        controller.isThinking.value) {
                      return _buildThinkingIndicator();
                    }
                    final message = controller.messages[index];
                    final isLatestAiMessage =
                        !message.isUser &&
                        index == controller.messages.length - 1;

                    return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: message.isUser
                                ? _buildUserBubble(message.text)
                                : _buildMentorBubble(
                                    message.text,
                                    isLatestAiMessage,
                                  ),
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
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        final isLeft = index % 2 == 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child:
                Container(
                      width: Get.width * 0.4 + (index * 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                      duration: const Duration(milliseconds: 1500),
                      color: Colors.white12,
                    ),
          ),
        );
      },
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

  Widget _buildMentorBubble(String text, bool animate) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(16),
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
      child: animate
          ? TypewriterText(
              text: text,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            )
          : Text(
              text,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(16),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
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
      padding: EdgeInsets.fromLTRB(
        0,
        10,
        0,
        Get.context != null
            ? MediaQuery.of(Get.context!).padding.bottom + 0
            : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _buildQuickReplies(textController),
          // const SizedBox(height: 12),
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
        ],
      ),
    );
  }

  Widget _buildQuickReplies(TextEditingController textController) {
    return Obx(() {
      if (controller.quickReplies.isEmpty) return const SizedBox.shrink();
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.quickReplies.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final reply = controller.quickReplies[index];
            return GestureDetector(
              onTap: () {
                controller.sendMessage(reply);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Text(
                  reply,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
