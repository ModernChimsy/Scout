import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class FriendsInterestedRow extends StatelessWidget {
  final int friendsInterested;
  final List<dynamic> friendsImages; // Change to List<String> for image URLs
  final Color color;

  const FriendsInterestedRow({
    super.key,
    required this.friendsInterested,
    required this.friendsImages,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // If no friends are interested, don't create the container and return an empty widget
    if (friendsInterested == 0) {
      return Row(
        children: [
          CustomText(
            text: 'No friends are interested',
            fontSize: 14,
            color: color,
          ),
        ],
      );
    }

    // Calculate the width of the container based on the number of friends
    double containerWidth =
        friendsInterested * 28.0 + (friendsInterested - 1) * 8.0;

    return Row(
      children: [
        Container(
          width: containerWidth,
          height: 30,
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(
              friendsInterested,
                  (index) {
                return Positioned(
                  left: index * 28.0 + index * 8.0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(friendsImages[index]),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 5),
        CustomText(
          text: '$friendsInterested friends are interested',
          fontSize: 14,
          color: color,
        ),
      ],
    );
  }
}
