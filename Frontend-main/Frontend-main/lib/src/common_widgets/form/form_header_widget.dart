import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageColor,
    this.imageHeight = 0.2,
    this.heightBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign,
  });

  final String image, title, subTitle;
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage(image), color: imageColor ,height: size.height * imageHeight),
        SizedBox(height: heightBetween),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        //const SizedBox(height: 10.0),
        Text(subTitle, textAlign: textAlign, style: Theme.of(context).textTheme.bodyMedium),
        //const SizedBox(height: CSFormHeight),
      ],
    );
  }
}
