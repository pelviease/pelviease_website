import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding: EdgeInsets.all(isMobile ? 30 : 40),
      width: double.infinity,
      decoration: BoxDecoration(
          color: lightViolet, borderRadius: BorderRadius.circular(50)),
      child: Column(
        spacing: 18,
        children: [
          Text(
            "Partners and references",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: isMobile ? 30 : 40,
                  color: darkViolet,
                ),
          ),
          Text(
            "Together, we collaborate with leading organizations committed to protecting the environment and building a greener future.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isMobile ? 13 : 16,
                  color: darkViolet,
                ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          isMobile
              ? GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  shrinkWrap: true,
                  childAspectRatio: 1.5,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    partnerCard("assets/partner1.png", isMobile),
                    partnerCard("assets/partner2.png", isMobile),
                    partnerCard("assets/partner3.png", isMobile),
                    partnerCard("assets/partner4.png", isMobile),
                    partnerCard("assets/partner5.png", isMobile),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      spacing: 50,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        partnerCard("assets/partner1.png", isMobile),
                        partnerCard("assets/partner2.png", isMobile),
                        partnerCard("assets/partner3.png", isMobile),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      spacing: 50,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        partnerCard("assets/partner4.png", isMobile),
                        partnerCard("assets/partner5.png", isMobile),
                      ],
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget partnerCard(String image, bool isMobile) {
    return Container(
      // height: isMobile ? 5 : 120,
      // width: isMobile ? 5 : 260,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 8),
              blurRadius: 17,
              color: const Color(0x08666666),
            ),
            BoxShadow(
              offset: Offset(0, 31),
              blurRadius: 31,
              color: const Color(0x08666666),
            ),
            BoxShadow(
              offset: Offset(0, 31),
              blurRadius: 31,
              color: const Color(0x08666666),
            ),
          ]),
      child: Image.asset(
        image,
        fit: BoxFit.contain,
      ),
    );
  }
}
