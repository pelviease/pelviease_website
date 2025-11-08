import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';

class HeroCardTwo extends StatelessWidget {
  const HeroCardTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight - 120,
      width: screenWidth < 400 ? screenWidth : screenWidth - 16,
      // decoration: BoxDecoration(
      //     color: buttonColor, borderRadius: BorderRadius.circular(40)),
      child: CachedNetworkImage(
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/pelviease-website.firebasestorage.app/o/const%2Fp-home.png?alt=media&token=192c6453-4d32-4407-a5b5-90f98f8e32e5",
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
