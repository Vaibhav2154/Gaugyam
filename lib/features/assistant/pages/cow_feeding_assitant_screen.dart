import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/assistant/services/gemini_services.dart';

class CowFeedingAssistantScreen extends StatefulWidget {
  const CowFeedingAssistantScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CowFeedingAssistantScreenState createState() =>
      _CowFeedingAssistantScreenState();
}

class _CowFeedingAssistantScreenState extends State<CowFeedingAssistantScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController healthController = TextEditingController();
  final TextEditingController chatController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  String productionStage = "Dry"; // Default selection
  String feedingPlan = "";
  bool isLoading = false;
  List<String> chatMessages = [];

  Future<void> fetchCowFeedingPlan() async {
    setState(() {
      isLoading = true;
      feedingPlan = ""; // Clear previous results
    });

    try {
      final plan = await _geminiService.generateCowFeedingPlan(
        productionStage: productionStage,
        weight: weightController.text.trim(),
        age: ageController.text.trim(),
        breed: breedController.text.trim(),
        purpose: purposeController.text.trim(),
        healthConditions: healthController.text.trim(),
      );

      setState(() {
        feedingPlan = plan;
      });
    } catch (e) {
      setState(() {
        feedingPlan = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: AppPallete.backgroundColor,
          prefixIcon: Icon(icon ?? Icons.grass, color: AppPallete.gradient1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppPallete.backgroundColor,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppPallete.gradient1, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppPallete.backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.gradient1, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: productionStage,
          dropdownColor: AppPallete.backgroundColor,
          icon: Icon(Icons.arrow_drop_down, color: AppPallete.gradient1),
          style: TextStyle(color: Colors.white, fontSize: 16),
          isExpanded: true,
          items:
              [
                "Dry",
                "Early Lactation",
                "Mid Lactation",
                "Late Lactation",
                "Calf",
                "Heifer",
                "Bull",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {
            setState(() {
              productionStage = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFeedingPlanTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Cow Details",
              style: TextStyle(
                color: AppPallete.gradient1,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildDropdown(),
            SizedBox(height: 16),

            _buildTextField(
              "Weight (kg)",
              weightController,
              icon: Icons.monitor_weight,
            ),
            _buildTextField(
              "Age (months/years)",
              ageController,
              icon: Icons.calendar_today,
            ),
            _buildTextField("Breed", breedController, icon: Icons.pets),
            _buildTextField(
              "Purpose (Dairy/Beef/Dual)",
              purposeController,
              icon: Icons.category,
            ),
            _buildTextField(
              "Health Conditions (if any)",
              healthController,
              icon: Icons.health_and_safety,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: AppPallete.gradient1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : fetchCowFeedingPlan,
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: AppPallete.whiteColor)
                          : Text(
                            "Get Feeding Plan",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppPallete.whiteColor,
                            ),
                          ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      weightController.clear();
                      ageController.clear();
                      breedController.clear();
                      purposeController.clear();
                      healthController.clear();
                      feedingPlan = "";
                    });
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(fontSize: 16, color: AppPallete.whiteColor),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            if (feedingPlan.isNotEmpty)
              Card(
                elevation: 5,
                color: AppPallete.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    data: feedingPlan,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 16, color: AppPallete.whiteColor),
                      h1: TextStyle(
                        fontSize: 22,
                        color: AppPallete.gradient1,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: TextStyle(
                        fontSize: 20,
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      strong: TextStyle(
                        color: AppPallete.gradient3,
                        fontWeight: FontWeight.bold,
                      ),
                      listBullet: TextStyle(color: AppPallete.gradient1),
                    ),
                  ),
                ),
              ),

            if (feedingPlan.isEmpty)
              Card(
                elevation: 5,
                color: AppPallete.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Your cow feeding recommendations will appear here.",
                    style: TextStyle(fontSize: 16, color: AppPallete.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cow Feeding Assistant",
          style: TextStyle(color: AppPallete.gradient1),
        ),
        centerTitle: true,
      ),
      body: _buildFeedingPlanTab(),

      // _buildChatTab(),
    );
  }
}
