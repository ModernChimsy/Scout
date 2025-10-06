// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
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
import 'package:restaurent_discount_app/view/search_view/widget/categories_filter_page.dart';

class SearchDetailsPage extends StatefulWidget {
  final String? tag;
  final String? searchQuery;

  const SearchDetailsPage({super.key, this.tag, this.searchQuery});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  final FilterController _filterController = Get.find<FilterController>();
  final LocationFilterController _locationFilterController = Get.find<LocationFilterController>();

  DateTimeRange? selectedDateRange;

  Set<String> selectedCategories = {};

  @override
  void initState() {
    super.initState();

    if (widget.tag != null && widget.tag!.isNotEmpty) {
      selectedCategories.add(widget.tag!.toLowerCase());
    }

    _applyFilter(newTags: selectedCategories.join(','), newStartDate: "", newEndDate: "");
  }

  String getPageTitle() {
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      return 'Results for "${widget.searchQuery!.capitalizeFirst}"';
    } else if (selectedCategories.isNotEmpty) {
      return 'Category Events';
    }
    return 'Event Filter';
  }

  void _applyFilter({String? newTags, String? newStartDate, String? newEndDate}) {
    String effectiveTags = newTags ?? selectedCategories.join(',');
    String? effectiveQuery = effectiveTags.isEmpty ? widget.searchQuery : null;

    if (effectiveTags.isEmpty && widget.searchQuery != null) {
      effectiveQuery = widget.searchQuery;
    }

    _filterController.filterEvents(
      tag: effectiveTags,
      query: effectiveQuery,
      startDate: newStartDate ?? (selectedDateRange != null ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start) : ""),
      endDate: newEndDate ?? (selectedDateRange != null ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end) : ""),
    );
  }

  String getCategoryButtonTitle() {
    if (selectedCategories.isEmpty) {
      return 'Category';
    } else if (selectedCategories.length == 1) {
      return selectedCategories.first.capitalizeFirst ?? 'Category';
    } else {
      return 'Category (${selectedCategories.length})';
    }
  }

  String getLocationButtonTitle(String locationName) {
    if (locationName == "Location") return locationName;

    String cityOrArea = locationName.split(',').first.trim();
    String formattedName = cityOrArea.capitalizeFirst ?? cityOrArea;
    return formattedName.length > 15 ? '${formattedName.substring(0, 15)}...' : formattedName;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      String categoryButtonTitle = getCategoryButtonTitle();

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: getPageTitle()),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            children: [
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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

                                  final startDate = DateFormat('yyyy-MM-dd').format(range.start);
                                  final endDate = DateFormat('yyyy-MM-dd').format(range.end);

                                  _applyFilter(newStartDate: startDate, newEndDate: endDate);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        );
                      },
                      title: selectedDateRange != null ? 'Date: ${DateFormat('MMM d').format(selectedDateRange!.start)}' : 'Date',
                      iconData: Icons.calendar_month,
                      bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                      textColor: isDarkMode ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 20),
                    TopWidgetBookmarks(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                          builder: (context) {
                            return CategoriesFilterPage(
                              initialSelectedCategories: selectedCategories,
                              onCategoriesSelected: (newCategories) {
                                setState(() {
                                  selectedCategories = newCategories;
                                });

                                _applyFilter(newTags: newCategories.join(','));
                              },
                            );
                          },
                        );
                      },
                      title: categoryButtonTitle,
                      iconData: Icons.menu,
                      bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                      textColor: isDarkMode ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 20),
                    Obx(() {
                      return TopWidgetBookmarks(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: isDarkMode ? Colors.black : Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Container(height: 700, child: LocationFilterScreen()),
                          );
                        },
                        title: getLocationButtonTitle(_locationFilterController.selectedLocationName.value),
                        iconData: Icons.location_on_outlined,
                        bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                return Expanded(
                  child: _filterController.isLoading.value
                      ? Center(child: CustomLoader())
                      : _filterController.filterResults.value.data == null || _filterController.filterResults.value.data!.isEmpty
                      ? Center(child: NotFoundWidget(message: "Sorry! No Event Found"))
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _filterController.filterResults.value.data!.length,
                          itemBuilder: (_, index) {
                            final event = _filterController.filterResults.value.data![index];

                            final interestedPeopleImages = event.interestEvents
                                .map(
                                  (interestEvent) =>
                                      interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png',
                                )
                                .toList();

                            return EventCard(
                              eventId: event.id,
                              image: event.image?.isNotEmpty == true
                                  ? event.image.toString()
                                  : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                              eventName: event.title ?? '',
                              eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                              categories: event.tags,
                              eventDescription: event.content ?? '',
                              friendsInterested: event.interestEvents.length,
                              onTap: () => Get.to(() => EventDetailPage(eventId: event.id)),
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
