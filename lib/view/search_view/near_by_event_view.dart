// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/view/search_view/controller/location_filter_controller.dart';

class NearByLocationView extends StatefulWidget {
  final dynamic selectedLat;
  final dynamic selectedLong;
  final String? locationName;

  const NearByLocationView({super.key, this.selectedLat, this.selectedLong, this.locationName});

  @override
  State<NearByLocationView> createState() => _NearByLocationViewState();
}

class _NearByLocationViewState extends State<NearByLocationView> {
  final LocationFilterController _locationFilterController = Get.find<LocationFilterController>();

  @override
  void initState() {
    super.initState();
    // TODO: Do Not Go To Prod Without Testing This Thoroughly Golden
    // Assuming getLocation is called right before Get.to() in LocationFilterScreen.
    // If you need to re-fetch on init here, uncomment the call below:
    /*
    _locationFilterController.getLocation(
      lat: widget.selectedLat!,
      long: widget.selectedLong!,
      locationName: widget.locationName ?? "Nearby Event",
    );
    */
  }

  String getPageTitle() {
    final name = widget.locationName;
    if (name != null && name.isNotEmpty && name != "Location" && name != "Select a location") {
      return name.split(',').first.trim().capitalizeFirst ?? 'Nearby Events';
    }
    return 'Nearby Events';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: getPageTitle()),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(height: 20),
              Obx(() {
                return Expanded(
                  child: _locationFilterController.isLoading.value
                      ? Center(child: CustomLoader())
                      : _locationFilterController.nurseData.value.data == null || _locationFilterController.nurseData.value.data!.isEmpty
                      ? Center(child: NotFoundWidget(message: "Sorry! No Event Found"))
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _locationFilterController.nurseData.value.data!.length,
                          itemBuilder: (_, index) {
                            final event = _locationFilterController.nurseData.value.data![index];

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
