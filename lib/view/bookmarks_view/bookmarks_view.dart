// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/view/bookmarks_view/widget/top_widget_bookmarks.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/data/hive_data/hive_model_class_dart.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  _BookmarksViewState createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  DateTime? _startDate;
  DateTime? _endDate;

  late Box<EventCardModel> bookmarkedEventsBox;

  @override
  void initState() {
    super.initState();
    bookmarkedEventsBox = Hive.box<EventCardModel>('bookmarks');
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      final systemOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      );

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          systemOverlayStyle: systemOverlayStyle,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: CustomText(text: 'Saved', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TopWidgetBookmarks(
                    onTap: () => _selectDateRange(context),
                    title: 'All Time',
                    iconData: Icons.calendar_month,
                    bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 10),
              if (_startDate != null && _endDate != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CustomText(
                    text: 'Selected Range: ${_startDate!.toLocal()} - ${_endDate!.toLocal()}'.split(' ')[0],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              SizedBox(height: 10),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: bookmarkedEventsBox.listenable(),
                  builder: (context, Box<EventCardModel> box, _) {
                    final bookmarkedEvents = box.values.toList();

                    if (bookmarkedEvents.isEmpty) {
                      return Center(child: NotFoundWidget(message: 'No saved events'));
                    }

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: bookmarkedEvents.length,
                      itemBuilder: (BuildContext context, index) {
                        final event = bookmarkedEvents[index];

                        return EventCard(
                          eventId: event.eventId,
                          image: event.image,
                          eventName: event.eventName,
                          eventDate: event.eventDate,
                          categories: event.categories,
                          eventDescription: event.eventDescription,
                          friendsInterested: event.friendsInterested,
                          onTap: () => Get.to(() => EventDetailPage(eventId: event.eventId)),
                          interestedPeopleImage: event.interestedPeopleImage,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
