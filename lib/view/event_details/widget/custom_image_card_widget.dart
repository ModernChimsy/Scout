import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class CustomImageTextCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  final int wordLimit;
  final Color color;

  const CustomImageTextCard({
    Key? key,
    required this.imageUrl,
    required this.text,
    this.wordLimit = 4, required this.color,
  }) : super(key: key);

  String customEllipsisText(String text, {required int wordLimit}) {
    List<String> words = text.split(' ');
    if (words.length > wordLimit) {
      words = words.sublist(0, wordLimit);
      return '${words.join(' ')}...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 55,
            height: 55,
          ),
        ),
        SizedBox(height: 8.0),
        CustomText(
          text: customEllipsisText(text, wordLimit: wordLimit),
          fontSize: 14.0,
          color: color,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}
