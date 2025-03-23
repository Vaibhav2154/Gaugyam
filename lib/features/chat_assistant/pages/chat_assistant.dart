import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/chat_assistant/services/gemini_services.dart';

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatAssistantScreenState createState() =>
      _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  final TextEditingController chatController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  bool isLoading = false;
  List<String> chatMessages = [];



  Future<void> sendChatMessage() async {
    if (chatController.text.isEmpty) return;

    final userMessage = chatController.text;
    setState(() {
      chatMessages.add("You: $userMessage");
      isLoading = true;
    });
    chatController.clear();
    try {
      // Get only the last 5 messages to maintain context without overwhelming the API
      final contextMessages =
          chatMessages.length > 5
              ? chatMessages.sublist(chatMessages.length - 5)
              : chatMessages;

      final response = await _geminiService.getChatResponse(
        userMessage,
        contextMessages,
      );

      setState(() {
        chatMessages.add("Assistant: $response");
      });
    } catch (e) {
      setState(() {
        chatMessages.add("Assistant: Error: ${e.toString()}");
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child:
              chatMessages.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Ask questions about cow feeding and management",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      final isUser = message.startsWith("You:");

                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? AppPallete.gradient1
                                    : Colors.grey[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Text(
                            message.substring(message.indexOf(":") + 1).trim(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          // decoration: BoxDecoration(
          //   color: AppPallete.backgroundColor,
          //   border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
          // ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ask about cow feeding...",
                    hintStyle: TextStyle(color: AppPallete.whiteColor),
                    filled: true,
                    fillColor: AppPallete.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              // SizedBox(width: 4),
              Material(
                color: AppPallete.whiteColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: isLoading ? null : sendChatMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child:
                        isLoading
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppPallete.gradient1,
                                strokeWidth: 2,
                              ),
                            )
                            : Icon(Icons.send, color: AppPallete.gradient1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Assistant",
          style: TextStyle(color: AppPallete.gradient1),
        ),
        centerTitle: true,
      ),

      body: _buildChatTab(),
    );
  }
}
