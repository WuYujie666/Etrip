import 'dart:convert';
import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/food/build_food_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodItemsScreen extends StatefulWidget {
  final String category; 

  const FoodItemsScreen({super.key, required this.category});

  @override
  State<FoodItemsScreen> createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  List<dynamic> foodItems = [];
  bool isLoading = true;
    bool hasError = false;


  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    final String apiUrl =
        "http://192.168.1.12:8000/api/foods/?classification=${Uri.encodeComponent(widget.category)}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          foodItems = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ReusableScreen(
        showBackButton: true,
        backgroundColor: kSecondaryColor,
        gradientStops: const [0.1, 0.7],
        imageColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(7.5),
              Text(
                widget.category,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(3, 3),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
              const VerticalSpace(1),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                      ? const Center(child: Text('⚠️ Failed to load data', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                              fontSize: 16)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
                          return BuildFoodCard(foodItem: foodItems[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      
    );
  }
}
