import 'package:flutter/material.dart';
import 'package:frontend/ui/chatbot/widgets/global_action_card.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/chat_controller.dart';
import '../../constants/app_theme.dart';
import 'widgets/agent_status_chip.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/input_box.dart';
import 'widgets/typing_loader.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 42,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text("AutoSync", style: AppTheme.title),
                const SizedBox(width: 8),
                Obx(
                  () => AgentStatusChip(
                    isActive: controller.agentActive.value,
                    agentName: controller.currentAgent.value.replaceAll("_agent_function", ""),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.lightbulb,
                    size: 16,
                    color: Colors.black54,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Chat List
            Expanded(
              child: Obx(() {
                final msgs = controller.messages;
                final unreadIndex = controller.unreadIndex.value;
                final total =
                    msgs.length + (controller.isLoading.value ? 1 : 0);

                if (controller.showLottie.value && msgs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/Car.json',
                          width: 200,
                          height: 200,
                          repeat: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Let’s drive this conversation somewhere interesting!",
                          style: AppTheme.subtitle,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: total,
                  itemBuilder: (context, index) {
                    if (index == msgs.length && controller.isLoading.value) {
                      // If the last message was also from the bot, don’t repeat avatar
                      final showAvatar = msgs.isEmpty || msgs.last.isUser;
                      return Padding(
                        padding: EdgeInsets.only(
                          left: showAvatar ? 0 : 40, // indent if grouped
                          top: 4,
                          bottom: 4,
                        ),
                        child: TypingLoader(showAvatar: showAvatar),
                      );
                    }

                    final msg = msgs[index];
                    final prev = index > 0
                        ? msgs[index - 1]
                        : null; // previous message
                    final next = index < msgs.length - 1
                        ? msgs[index + 1]
                        : null; // next message

                    final isFirstInGroup =
                        prev == null || prev.isUser != msg.isUser;
                    final isLastInGroup =
                        next == null || next.isUser != msg.isUser;

                    // Show unread separator
                    final showUnreadSeparator = index == unreadIndex;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showUnreadSeparator)
                        
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "New Messages",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ChatBubble(
                          key: ValueKey(index),
                          message: msg,
                          onUserAction: controller.addUserReply,
                          isFirstInGroup: isFirstInGroup,
                          isLastInGroup: isLastInGroup,
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            // Input
            const InputBox(),
          ],
        ),
      ),
    );
  }
}
