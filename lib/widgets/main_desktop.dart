import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      height: screenSize.height / 1.2,
      constraints: const BoxConstraints(minHeight: 350.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hi,\nI\'m Anil Kumar Malipeddi\nA Flutter Developer',
                style: TextStyle(
                  fontSize: 30.0,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Colorss.whitePrimary,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 250.0,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colorss.yellowSecondary,
                  ),
                  child: Text(
                    "Get in touch",
                    style: TextStyle(
                      color: Colorss.whitePrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/images/flutter_dummy.png',
            height: screenHeight / 2,
            width: screenWidth / 2,
          ),
        ],
      ),
    );
  }
}
