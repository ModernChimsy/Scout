// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurent_discount_app/common widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/bookmarks_view/widget/top_widget_bookmarks.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/view/search_view/controller/filter_controller.dart';
import 'package:restaurent_discount_app/view/search_view/controller/location_filter_controller.dart';
import 'package:restaurent_discount_app/view/search_view/widget/date_range_widget.dart';
import 'package:restaurent_discount_app/view/search_view/widget/location_page.dart';

class SearchDetailsPage extends StatefulWidget {
  final String tag;
  const SearchDetailsPage({super.key, required this.tag});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  final FilterController _filterController = Get.put(FilterController());
  final LocationFilterController _locationFilterController =
      Get.put(LocationFilterController());

  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();

    _filterController.getFilter(
      tag: widget.tag,
      startDate: "",
      endDate: "",
    );




    _locationFilterController.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Filter"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  TopWidgetBookmarks(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 560,
                            child: DateRangePickerPage(
                              onDateRangeSelected: (range) {
                                setState(() {
                                  selectedDateRange = range;
                                });

                                final tag = widget.tag;
                                final startDate = selectedDateRange != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(selectedDateRange!.start)
                                    : null;

                                final endDate = selectedDateRange != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(selectedDateRange!.end)
                                    : null;

                                print("📍 Apply Filter Tapped!");
                                print("📝 Tag: $tag");
                                print("📆 Start Date: $startDate");
                                print("📆 End Date: $endDate");

                                _filterController.getFilter(
                                  tag: tag,
                                  startDate: startDate,
                                  endDate: endDate,
                                );

                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
                    },
                    title: 'All Time',
                    iconData: Icons.calendar_month,
                    bgColor:
                        isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 20),
                  TopWidgetBookmarks(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        builder: (context) {
                          final categories = [
                            'Festival',
                            'Food',
                            'Wine',
                            'Sports',
                            'Literature',
                            'Concerts',
                            'Nightlife',
                            'Tech',
                            'Music',
                            'Art',
                            'Fundraising',
                            'Outdoor'
                          ];

                          return Container(
                            padding: EdgeInsets.all(20),
                            height: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Category',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: categories.length,
                                    separatorBuilder: (_, __) => Divider(),
                                    itemBuilder: (context, index) {
                                      final category = categories[index];
                                      return ListTile(
                                        title: Text(
                                          category,
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                        onTap: () {
                                          _filterController.getFilter(
                                            tag: category.toLowerCase(),
                                            startDate: "",
                                            endDate: "",
                                          );

                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    title: 'Category',
                    iconData: Icons.menu,
                    bgColor:
                        isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 20),
                  TopWidgetBookmarks(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor:
                            isDarkMode ? Colors.black : Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Container(
                          height: 700,
                          child: LocationFilterScreen(),
                        ),
                      );
                    },
                    title: 'Location',
                    iconData: Icons.location_on_outlined,
                    bgColor:
                        isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx(() {
                return Expanded(
                  child: _filterController.isLoading.value
                      ? Center(child: CustomLoader())
                      : _filterController.nurseData.value.data == null ||
                              _filterController.nurseData.value.data!.isEmpty
                          ? Center(
                              child: NotFoundWidget(
                                  message: "Sorry! No Event Found"))
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _filterController
                                  .nurseData.value.data!.length,
                              itemBuilder: (_, index) {
                                final event = _filterController
                                    .nurseData.value.data![index];

                                final interestedPeopleImages = event
                                    .interestEvents
                                    .map((interestEvent) =>
                                        interestEvent.user?.profilePicture ??
                                        'https://t4.ftcdn.net/jpg/07/03/86/11/360_F_703861114_7YxIPnoH8NfmbyEffOziaXy0EO1NpRHD.jpg')
                                    .toList();

                                return EventCard(
                                  eventId: event.id,
                                  image: event.image?.isNotEmpty == true
                                      ? event.image.toString()
                                      : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                  eventName: event.title ?? '',
                                  eventDate: event.date
                                          ?.toLocal()
                                          .toString()
                                          .split(' ')[0] ??
                                      '',
                                  categories: event.tags,
                                  eventDescription: event.content ?? '',
                                  friendsInterested:
                                      event.interestEvents.length,
                                  onTap: () => Get.to(
                                      () => EventDetailPage(eventId: event.id)),
                                  interestedPeopleImage: interestedPeopleImages,
                                );
                              },
                            ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
