// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/home_view/controller/all_event_controller.dart';
import 'package:restaurent_discount_app/view/home_view/widget/friends_widget.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/event_delete_controller.dart';
import 'package:restaurent_discount_app/uitilies/data/hive_data/hive_model_class_dart.dart';
import 'package:restaurent_discount_app/view/home_view/controller/event_interested_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:restaurent_discount_app/uitilies/date_formatter.dart';

class EventCard extends StatefulWidget {
  final String eventName;
  final String eventDate;
  final String image;
  final String eventDescription;
  final int friendsInterested;
  final List<String> categories;
  final List<dynamic> interestedPeopleImage;
  final VoidCallback onTap;
  final VoidCallback? onTapForInterest;
  final VoidCallback? onDeleteTap;
  final bool? isLoading;
  final String? eventId;

  const EventCard({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.categories,
    required this.eventDescription,
    required this.friendsInterested,
    required this.image,
    required this.onTap,
    required this.interestedPeopleImage,
    this.onTapForInterest,
    this.onDeleteTap,
    this.isLoading,
    this.eventId,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  static final log = Logger();

  bool _isLoading = true;
  bool _isBookmarked = false;

  final EventDeleteController _eventDeleteController = Get.put(EventDeleteController());
  final InterestedPostController _interestedPostController = Get.put(InterestedPostController());
  final AllEventController _allEventController = Get.put(AllEventController());

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }

  void _checkIfBookmarked() async {
    var box = await Hive.openBox<EventCardModel>('bookmarks');
    var event = box.values.firstWhere(
      (element) => element.eventId == widget.eventId,
      orElse: () => EventCardModel(
        eventId: '',
        image: '',
        eventName: '',
        eventDate: '',
        categories: [],
        eventDescription: '',
        friendsInterested: 0,
        interestedPeopleImage: [],
      ),
    );
    setState(() {
      _isBookmarked = event.eventId.isNotEmpty;
    });
  }

  void _toggleBookmark() async {
    var box = await Hive.openBox<EventCardModel>('bookmarks');

    if (_isBookmarked) {
      var event = box.values.firstWhere(
        (element) => element.eventId == widget.eventId,
        orElse: () => EventCardModel(
          eventId: '',
          image: '',
          eventName: '',
          eventDate: '',
          categories: [],
          eventDescription: '',
          friendsInterested: 0,
          interestedPeopleImage: [],
        ),
      );
      if (event.eventId.isNotEmpty) await event.delete();
    } else {
      var event = EventCardModel(
        eventId: widget.eventId ?? '',
        image: widget.image,
        eventName: widget.eventName,
        eventDate: widget.eventDate,
        categories: widget.categories,
        eventDescription: widget.eventDescription,
        friendsInterested: widget.friendsInterested,
        interestedPeopleImage: widget.interestedPeopleImage,
      );

      bool alreadyExists = box.values.any((element) => element.eventId == widget.eventId);

      if (!alreadyExists) await box.add(event);
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    log.d("🧩 Event Date: ${widget.eventDate}"); // TODO: log the timestamp here and go futher to customise the timestamp here

    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: 0.1,
          color: isDarkMode ? Colors.black : Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Constant.eventCardSpacer), // Spacing from top of card
              /// Image Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Constant.eventCardSpacer),
                child: _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(4), bottom: Radius.circular(4)),
                          ),
                        ),
                      )
                    : Container(
                        height: 330,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.fill),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4), bottom: Radius.circular(4)),
                        ),
                      ),
              ),

              SizedBox(height: Constant.eventCardSpacer), // Spacing after image
              /// Text Content Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Constant.eventCardSpacer),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Categories
                    _isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(height: 20, width: 160, color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.categories.map((category) {
                              return Container(
                                decoration: BoxDecoration(color: categoryColor(category), borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: CustomText(text: category, fontSize: 13, fontWeight: FontWeight.w500),
                              );
                            }).toList(),
                          ),

                    SizedBox(height: Constant.eventCardSpacer), // Spacing after categories
                    /// Date
                    /// This now uses the DateFormatter utility class // TODO: Update timestamp
                    _isLoading
                        ? shimmerBlock(width: 100, height: 16)
                        : CustomText(
                            text: DateFormatter.formatEventDate(widget.eventDate),
                            fontSize: 14,
                            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                          ),

                    SizedBox(height: Constant.eventCardSpacer), // Spacing after date
                    /// Event Name
                    _isLoading
                        ? shimmerBlock(width: 200, height: 20)
                        : CustomText(
                            text: widget.eventName,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),

                    SizedBox(height: Constant.eventCardSpacer), // Spacing after event name
                    // Friends Interested Row
                    _isLoading
                        ? shimmerBlock(width: 100, height: 20)
                        : FriendsInterestedRow(
                            friendsInterested: widget.friendsInterested,
                            friendsImages: widget.interestedPeopleImage,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),

                    SizedBox(height: Constant.eventCardSpacer), // Spacing before buttons
                    // Buttons/Bookmark
                    _isLoading
                        ? shimmerBlock(width: 120, height: 38)
                        : Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: CustomButtonWidget(
                                    weight: FontWeight.w500,
                                    bgColor: isDarkMode ? Color(0xFF742802) : Color(0xFFFFF5F0),
                                    btnTextSize: 13.0,
                                    btnText: _interestedPostController.isLoading.value ? "Adding..." : "I'm Interested",
                                    onTap: () async {
                                      await _interestedPostController.addToInterest(eventId: widget.eventId ?? '');

                                      _allEventController.getInitialEvents();
                                    },
                                    btnTextColor: isDarkMode ? Colors.white : Colors.black,
                                    iconWant: false,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: _toggleBookmark,
                                child: Icon(
                                  _isBookmarked ? Icons.bookmark : Icons.bookmark_outline_outlined,
                                  size: 30,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              if (widget.onDeleteTap != null) ...[
                                SizedBox(width: 16),
                                Obx(() {
                                  return _eventDeleteController.isLoading.value == true
                                      ? CustomLoader()
                                      : GestureDetector(
                                          onTap: () {
                                            _eventDeleteController.deleteEvent(eventId: widget.eventId);
                                          },
                                          child: Icon(Icons.delete_outline, size: 30, color: Colors.redAccent),
                                        );
                                }),
                              ],
                            ],
                          ),

                    SizedBox(height: Constant.eventCardSpacer), // Spacing at the bottom of the card
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'nightlife':
        return Color(0xFFd2dcff);
      case 'music':
        return Color(0xFFfedfd0);
      case 'food':
        return Color(0xFFe0ffe0);
      default:
        return Color(0xFFfcefe8);
    }
  }

  Widget shimmerBlock({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(width: width, height: height, color: Colors.grey),
    );
  }
}
