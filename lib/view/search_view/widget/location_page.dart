// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/search_view/search_details_page.dart';

import '../controller/filter_controller.dart';
import '../controller/location_filter_controller.dart';

class LocationFilterScreen extends StatefulWidget {
  @override
  _LocationFilterScreenState createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  String locationText = "Select a location";
  double? selectedLatitude;
  double? selectedLongitude;

  final LocationFilterController _locationFilterController =
      Get.put(LocationFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode == true ? Colors.black : Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        SizedBox(width: 80),
                        CustomText(
                          color: isDarkMode ? Colors.white : Colors.black,
                          text: 'Filter by location',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        LocationData? locationData = await LocationSearch.show(
                          context: context,
                          mode: Mode.overlay,
                          userAgent: UserAgent(
                            appName: 'Scout',
                            email: 'support@scout.com',
                          ),
                        );

                        if (locationData != null) {
                          setState(() {
                            locationText =
                                locationData.address ?? "Unknown location";
                            selectedLatitude = locationData.latitude;
                            selectedLongitude = locationData.longitude;
                          });
                          print(
                              "Selected Location → Lat: $selectedLatitude, Lng: $selectedLongitude");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.btnColor),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                locationText,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButtonWidget(
                  bgColor: AppColors.btnColor,
                  btnText: "Apply Filter",
                  onTap: () {
                    if (selectedLatitude != null && selectedLongitude != null) {
                      _locationFilterController.getLocation(
                          long: selectedLongitude, lat: selectedLatitude);
                    } else {
                      CustomToast.showToast("Please select a location first",
                          isError: true);

                      return;
                    }

                    Get.back();

                    print("Filter applied with location: $locationText");
                    print(
                        "Latitude: $selectedLatitude, Longitude: $selectedLongitude");
                  },
                  iconWant: false,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
