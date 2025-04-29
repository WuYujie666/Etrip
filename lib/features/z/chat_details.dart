import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final String apiUrl = 'http://192.168.1.12:8000/api/ask/';

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _messages.add({'role': 'bot', 'text': '...'});
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botReply = data['answer'] ?? 'Sorry, I didn\'t understand that.';
        botReply = botReply.replaceAll('\n\n', '\n');
        botReply = botReply.replaceAll('\n', '\n\n');

        setState(() {
          _messages.removeLast();
          _messages.add({'role': 'bot', 'text': botReply});
        });
      } else {
        print('Server Error: ${response.statusCode}');
        print('Server Response: ${response.body}');
        setState(() {
          _messages.removeLast();
          _messages
              .add({'role': 'bot', 'text': 'Error: Could not fetch reply.'});
        });
      }
    } catch (e) {
      print('Exception Error: $e');
      setState(() {
        _messages.removeLast();
        _messages.add({'role': 'bot', 'text': 'Error: Check your connection.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kMainColor,
      imageColor: Colors.black,
      gradientStops: const [0.1, 0.7],
      child: SafeArea(
        child: Column(
          children: [
            const VerticalSpace(3),

            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Chat Bot",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  const Spacer(),
                  Image.asset(AssetsData.chatbot, height: 60),
                ],
              ),
            ),
            const VerticalSpace(2),
            // Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: GoogleFonts.montserrat(
                          color: isUser ? Colors.black : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Typing Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: "Ask me something...",
                          hintStyle: GoogleFonts.playfairDisplaySc(
                            // <-- Hint text
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.limeAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
