import 'package:flutter/material.dart';
import 'package:social_test/helpers/projectResources.dart';

class GradientText extends StatelessWidget {
  final String text;
  final String jsonResponse;
  final TextStyle style;

  GradientText({required this.text, required this.jsonResponse, required this.style});

  @override
  Widget build(BuildContext context) {
    final String gradientString = jsonResponse;

    // Extract colors from the gradient string
    final RegExp colorRegex = RegExp(r'rgb\((\d+), (\d+), (\d+)\)');
    final matches = colorRegex.allMatches(gradientString);

    List<Color> colors = matches.map((match) {
      return Color.fromRGBO(
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
        1.0,
      );
    }).toList();

    return Container(
      width: ProjectResource.screenWidth,
      height: ProjectResource.screenHeight * .23,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: ProjectResource.fontSizeFactor * 2, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}