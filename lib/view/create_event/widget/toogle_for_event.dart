// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/Remember_widget.dart';

class ToggleForEvent extends StatefulWidget {
  final String title;
  final bool isChecked;
  final Color? color;
  final Color? textColor;
  final ValueChanged<bool> onChanged;

  const ToggleForEvent({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
    this.color,
    this.textColor,
  });

  @override
  _ToggleForEventState createState() => _ToggleForEventState();
}

class _ToggleForEventState extends State<ToggleForEvent> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  void _toggleSwitch(bool? value) {
    if (value == null) return;
    setState(() {
      _isChecked = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: widget.title,
            color: widget.textColor!,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          RememberWidget(
            isChecked: _isChecked,
            onChanged: _toggleSwitch,
            text: "Remember me",
          ),
        ],
      ),
    );
  }
}
