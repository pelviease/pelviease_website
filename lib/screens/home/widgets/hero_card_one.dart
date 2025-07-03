import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';

class HeroCardOne extends StatelessWidget {
  const HeroCardOne({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Container(
      margin: isMobile
          ? EdgeInsets.symmetric(horizontal: 4)
          : EdgeInsets.symmetric(horizontal: 8),
      height: isMobile ? screenHeight - 120 : screenHeight * 0.5,
      width: screenWidth < 400 ? screenWidth : screenWidth - 16,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(40)),
      child: Stack(
        children: [
          Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: isMobile ? screenWidth * 0.03 : screenWidth * 0.02,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth > 600
                            ? screenWidth * 0.45
                            : screenWidth,
                        child: RichText(
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: isMobile
                                          ? screenWidth * 0.07
                                          : screenWidth * 0.04,
                                      color: Colors.white,
                                    ),
                                children: [
                              TextSpan(text: "BUILDING FOR\nOUR"),
                              TextSpan(
                                  text: "MOTHERS",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        //fontSize: screenWidth * 0.045,
                                        fontSize: screenWidth > 600
                                            ? screenWidth * 0.04
                                            : screenWidth * 0.09,
                                        color: cyclamen,
                                      )),
                              TextSpan(text: ",\nWHO BUILT US"),
                            ])),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "#STOPSILENTSUFFERINGS",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: screenWidth > 600
                                  ? screenWidth * 0.028
                                  : screenWidth * 0.04,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/pelviease_white.png',
                    height: screenWidth > 600
                        ? screenWidth * 0.06
                        : screenWidth * 0.1,
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              right: isMobile ? 0 : screenWidth * 0.07,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(10)),
                child: Image.asset(
                  "assets/hero_picture.png",
                  height: isMobile ? screenHeight * 0.3 : screenHeight * 0.68,
                ),
              ))
        ],
      ),
    );
  }
}
