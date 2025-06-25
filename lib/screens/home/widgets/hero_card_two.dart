import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';

class HeroCardTwo extends StatelessWidget {
  const HeroCardTwo({super.key});

   @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight - 120,
      width: screenWidth < 400 ? screenWidth : screenWidth - 16,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(40)),
      child: Stack(
        children: [
          
        ],
      ),
    );
  }
}