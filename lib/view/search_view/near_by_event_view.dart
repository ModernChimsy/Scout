// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/view/search_view/controller/location_filter_controller.dart';

class NearByLocationView extends StatefulWidget {
  final dynamic selectedLat;
  final dynamic selectedLong;
  const NearByLocationView({super.key, this.selectedLat, this.selectedLong});

  @override
  State<NearByLocationView> createState() => _NearByLocationViewState();
}

class _NearByLocationViewState extends State<NearByLocationView> {
  final LocationFilterController _locationFilterController =
      Get.put(LocationFilterController());

  @override
  void initState() {
    super.initState();

    _locationFilterController.getLocation(
      lat: widget.selectedLat!,
      long: widget.selectedLong!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Nearby Event"),
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
                      : _locationFilterController.nurseData.value.data ==
                                  null ||
                              _locationFilterController
                                  .nurseData.value.data!.isEmpty
                          ? Center(
                              child: NotFoundWidget(
                                  message: "Sorry! No Event Found"))
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _locationFilterController
                                  .nurseData.value.data!.length,
                              itemBuilder: (_, index) {
                                final event = _locationFilterController
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
