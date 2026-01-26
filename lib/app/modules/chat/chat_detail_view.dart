import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/glass_text_field.dart';
import 'chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  const ChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 16,
                backgroundImage: mentor != null
                    ? NetworkImage(mentor.avatarUrl)
                    : null,
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
                      fontSize: 16,
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
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: message.isUser
                            ? _buildUserBubble(message.text)
                            : _buildMentorBubble(message.text),
                      ),
                    );
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

  Widget _buildMentorBubble(String text) {
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
      child: Text(
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
            AppColors.cyanAccent.withOpacity(0.4),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildInputArea() {
    final TextEditingController textController = TextEditingController();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        Get.context != null
            ? MediaQuery.of(Get.context!).padding.bottom + 20
            : 40,
      ),
      child: GlassTextField(
        controller: textController,
        hintText: 'Type a message...',
        onSend: () {
          controller.sendMessage(textController.text);
          textController.clear();
        },
      ),
    );
  }
}
