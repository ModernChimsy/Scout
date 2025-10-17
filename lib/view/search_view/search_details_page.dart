// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class SearchDetailsPage extends StatefulWidget {
  final String? tag;
  final String? searchQuery;

  const SearchDetailsPage({super.key, this.tag, this.searchQuery});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  static final log = Logger();

  final FilterController _filterController = Get.find<FilterController>();
  final LocationFilterController _locationFilterController = Get.find<LocationFilterController>();

  DateTimeRange? selectedDateRange;

  Set<String> selectedCategories = {};

  String? initialTagDisplay;

  @override
  void initState() {
    super.initState();

    if (widget.tag != null && widget.tag!.isNotEmpty) {
      initialTagDisplay = widget.tag;
      selectedCategories.add(_prepareCategoryForApi(widget.tag!));
    }

    _applyFilter(newTags: selectedCategories.join(','), newStartDate: "", newEndDate: "");
  }

  String _prepareCategoryForApi(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ').trim().toLowerCase();
  }

  String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  String getPageTitle() {
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      /// Priority 1: Search Query Results
      return 'Results for "${widget.searchQuery!.capitalizeFirst}"';
    } else if (initialTagDisplay != null && selectedCategories.length <= 1) {
      /// Priority 2: Initial Single Category (e.g., "Music")
      return _capitalizeWords(initialTagDisplay!);
    } else if (selectedCategories.length > 1) {
      /// Priority 3: Multiple Categories Selected (e.g., "Category Events")
      return 'Category Events';
    }
    return 'Event Filter';
  }

  void _applyFilter({String? newTags, String? newStartDate, String? newEndDate}) {
    String effectiveTags = newTags ?? selectedCategories.join(',');
    String? apiTags = effectiveTags.isEmpty ? "" : effectiveTags;
    String? apiQuery;

    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      apiQuery = effectiveTags.isEmpty ? widget.searchQuery : null;
    } else if (effectiveTags.isNotEmpty) {
      apiQuery = effectiveTags.replaceAll(',', ' ');
    }

    _filterController.filterEvents(
      tag: apiTags,
      query: apiQuery,
      startDate: newStartDate ?? (selectedDateRange != null ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start) : ""),
      endDate: newEndDate ?? (selectedDateRange != null ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end) : ""),
    );
  }

  String getCategoryButtonTitle() {
    if (selectedCategories.isEmpty) {
      return 'Category';
    } else if (selectedCategories.length == 1) {
      String displayCategory = _capitalizeWords(selectedCategories.first);
      return displayCategory.isNotEmpty ? displayCategory : 'Category';
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
      String appBarTitle = getPageTitle();
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      String categoryButtonTitle = getCategoryButtonTitle();

      final systemOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      );

      PreferredSizeWidget appBarWidget = AppBar(
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),

        title: CustomText(text: appBarTitle, color: isDarkMode ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      );

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: appBarWidget,
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          isScrollControlled: true,
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: CategoriesFilterPage(
                                initialSelectedCategories: selectedCategories.map((c) => _capitalizeWords(c)).toSet(),
                                onCategoriesSelected: (newCategories) {
                                  setState(() {
                                    selectedCategories = newCategories.map((c) => _prepareCategoryForApi(c)).toSet();
                                    initialTagDisplay = selectedCategories.length == 1 ? newCategories.first : null;
                                  });
                                  _applyFilter(newTags: selectedCategories.join(','));
                                },
                              ),
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
                                .map((interestEvent) => interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                .toList();

                            return EventCard(
                              eventId: event.id,
                              image: event.image?.isNotEmpty == true ? event.image.toString() : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
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
