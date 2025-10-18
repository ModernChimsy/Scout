import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class FriendsInterestedRow extends StatelessWidget {
  final int friendsInterested;
  final List<dynamic> friendsImages;
  final Color color;

  static const int _maxDisplayedAvatars = 2;
  static const double _avatarRadius = 14.0;
  static const double _avatarDiameter = _avatarRadius * 2;
  static const double _overlapOffset = 10.0;
  static const double _borderThickness = 2.0;
  static const double _borderedAvatarRadius = _avatarRadius - _borderThickness / 2;
  static const double _borderedAvatarSize = _avatarDiameter + (_borderThickness * 2);

  const FriendsInterestedRow({super.key, required this.friendsInterested, required this.friendsImages, required this.color});

  @override
  Widget build(BuildContext context) {
    if (friendsInterested == 0 || friendsImages.isEmpty) {
      return Row(
        children: [CustomText(text: 'No friends are interested', fontSize: 14, color: color)],
      );
    }

    final int actualAvatarsToRender = friendsImages.take(_maxDisplayedAvatars).length;

    List<Widget> stackChildren = [];

    double stackedAreaWidth = _avatarDiameter + (actualAvatarsToRender > 1 ? (_avatarDiameter - _overlapOffset) : 0);

    if (actualAvatarsToRender > 0) {
      stackedAreaWidth += _borderThickness;
    }
    stackedAreaWidth = stackedAreaWidth > 0 ? stackedAreaWidth : _avatarDiameter;

    for (int i = 0; i < actualAvatarsToRender; i++) {
      double leftPosition = (actualAvatarsToRender - 1 - i) * (_avatarDiameter - _overlapOffset) + _borderThickness;

      String imageUrl = friendsImages[i].toString();

      bool isForegroundAvatar = i == 0;

      Widget avatar = Container(
        decoration: isForegroundAvatar
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: _borderThickness),
              )
            : null,
        child: CircleAvatar(
          radius: isForegroundAvatar ? _borderedAvatarRadius : _avatarRadius,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.grey.shade300,
        ),
      );

      stackChildren.add(Positioned(left: leftPosition, child: avatar));
    }

    stackChildren = stackChildren.reversed.toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: stackedAreaWidth,
          height: _borderedAvatarSize,
          child: Stack(clipBehavior: Clip.none, children: stackChildren),
        ),
        const SizedBox(width: 10),
        CustomText(text: '$friendsInterested friends are interested', fontSize: 14, color: color),
      ],
    );
  }
}
