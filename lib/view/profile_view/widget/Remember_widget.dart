import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class RememberWidget extends StatelessWidget {
  final bool isChecked;
  final String text;
  final ValueChanged<bool?> onChanged;

  const RememberWidget({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: Switch(
            value: isChecked,
            activeColor: AppColors.btnColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
            onChanged: onChanged,
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // Shrink the tap target size
          ),
        )
      ],
    );
  }
}
