// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../uitilies/app_colors.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.btnColor.withOpacity(0.5),
      highlightColor: AppColors.btnColor.withOpacity(0.5),
      period: Duration(milliseconds: 1500), // Fluid shimmer
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.btnColor, width: 2),
            ),
            child: CircleAvatar(backgroundImage: AssetImage('assets/images/placeholder_profile.jpeg')),
          ),
          const SizedBox(height: 10),
          Container(
            width: 200,
            height: 16,
            color: AppColors.btnColor.withOpacity(0.5),
          ),
          const SizedBox(height: 5),
          Container(
            width: 150,
            height: 12,
            color:  AppColors.btnColor.withOpacity(0.5),
          ),
          const SizedBox(height: 10),
          Container(
            width: 180,
            height: 12,
            color:  AppColors.btnColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
