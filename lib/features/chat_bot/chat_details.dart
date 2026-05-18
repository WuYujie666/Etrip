import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _messages.add({'role': 'bot', 'text': '...'});
    });

    _controller.clear();

    // Mock response delay
    await Future.delayed(const Duration(milliseconds: 800));

    final mockResponses = [
      'You can visit the Pyramids of Giza, the Egyptian Museum, and Khan El Khalili in Cairo.',
      'The best time to visit Egypt is from October to April when the weather is mild.',
      'Absolutely! Luxor and Aswan are must-visit destinations with amazing temples.',
      'I recommend trying Koshari, Ful Medames, and fresh seafood in Alexandria.',
      'You can book a Nile cruise between Luxor and Aswan for a wonderful experience.',
      'Sharm El-Sheikh and Hurghada are perfect for diving and snorkeling!',
    ];

    final reply = mockResponses[userMessage.length % mockResponses.length];

    setState(() {
      _messages.removeLast();
      _messages.add({'role': 'bot', 'text': reply});
    });
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
