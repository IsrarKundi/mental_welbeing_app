import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/liquid_glass_container.dart';
import '../../widgets/glass_text_field.dart';
import 'chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'MindWell',
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
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Start a conversation...',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
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
                            : _buildAIBubble(message.text),
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

  Widget _buildAIBubble(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tealAccent.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
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
      padding: const EdgeInsets.all(20),
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
