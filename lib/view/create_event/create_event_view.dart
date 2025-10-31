// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/age_restrictions_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/create_event_form_controller.dart';
import 'package:restaurent_discount_app/view/create_event/controller/event_create_controller.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/event_activities.dart';
import 'package:restaurent_discount_app/view/create_event/event_visibility_view.dart';
import 'package:restaurent_discount_app/view/create_event/extra_view.dart';
import 'package:restaurent_discount_app/view/create_event/tags_view.dart';
import 'package:restaurent_discount_app/view/create_event/tickets_view.dart';
import 'package:restaurent_discount_app/view/create_event/widget/event_card_widget.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService());
    }

    final EventCreateController eventCreateController = Get.put(EventCreateController());
    final CreateEventFormController formController = Get.put(CreateEventFormController());
    final ThemeController themeController = Get.find<ThemeController>();

    final bool isDarkMode = themeController.selectedTheme == ThemeController.darkTheme;

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
        title: CustomText(text: 'Event Information', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: AppPadding.bodyPadding,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: formController.pickImageFromGallery,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(15),
                      dashPattern: [8.0, 9.0],
                      color: AppColors.btnColor,
                    ),
                    child: Obx(() {
                      return formController.eventImage.value == null
                          ? Center(
                              child: Container(
                                width: 220,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isDarkMode ? Color(0xFF742802) : Color(0xFFFFF5F0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined),
                                    SizedBox(width: 8),
                                    CustomText(color: isDarkMode ? Colors.white : Colors.black, text: "Add Event Artwork"),
                                  ],
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(formController.eventImage.value!, fit: BoxFit.cover, width: double.infinity),
                            );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 20),

              CustomTextField(
                controller: formController.eventNameC,
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                hintText: "Event Name",
                showObscure: false,
                borderColor: Colors.grey,
              ),

              SizedBox(height: 20),

              /// Location Picker
              GestureDetector(
                onTap: () => formController.pickLocation(context),
                child: Obx(() {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                            formController.locationText.value,
                            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              /// Start Date Picker
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => formController.pickDate(context, formController.eventDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: formController.eventDateController,
                    hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                    iconColor: Colors.white,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                    hintText: "Date",
                    showObscure: false,
                    borderColor: Colors.grey,
                  ),
                ),
              ),

              /// End Date Picker
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => formController.pickDate(context, formController.endDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: formController.endDateController,
                    hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                    iconColor: Colors.white,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                    hintText: "End Date",
                    showObscure: false,
                    borderColor: Colors.grey,
                  ),
                ),
              ),

              /// Time Pickers
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 165,
                    child: GestureDetector(
                      onTap: () => formController.pickTime(context, formController.startTimeController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: formController.startTimeController,
                          hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                          iconColor: Colors.white,
                          fillColor: isDarkMode ? Colors.black : Colors.white,
                          hintText: "Start Time",
                          showObscure: false,
                          borderColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 165,
                    child: GestureDetector(
                      onTap: () => formController.pickTime(context, formController.endTimeController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: formController.endTimeController,
                          hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                          iconColor: Colors.white,
                          fillColor: isDarkMode ? Colors.black : Colors.white,
                          hintText: "End Time",
                          showObscure: false,
                          borderColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Description
              SizedBox(height: 20),
              CustomTextField(
                controller: formController.descriptionC,
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                maxLines: 4,
                hintText: "Description",
                showObscure: false,
                borderColor: Colors.grey,
              ),

              /// Event Cards - Sub Forms
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => TicketsView());
                },
                title: 'Tickets',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => TagsView());
                },
                title: 'Tags',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => EventActivitiesPage());
                },
                title: 'Event Activities',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => AgesRestrictionView());
                },
                title: 'Age restrictions',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => ExtraView());
                },
                title: 'Extra',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  formController.saveFormState();
                  Get.to(() => EventVisibilityView());
                },
                title: 'Event visibility',
              ),

              /// Buttons
              SizedBox(height: 50.h),

              Obx(() {
                return eventCreateController.isLoading.value == true
                    ? CustomLoader()
                    : CustomButtonWidget(
                        bgColor: AppColors.btnColor,
                        btnText: "Create Event",
                        onTap: () {
                          // Data from sub-forms (already in storage)
                          final storageService = Get.find<StorageService>();
                          final bool isOwnAlcoholAllowed = storageService.read<bool>('ownAlcohol') ?? false;
                          final bool isCoatCheckRequired = storageService.read<bool>('coatCheck') ?? false;
                          final bool eventPrivate = storageService.read<bool>('eventPrivate') ?? false;
                          final bool isAgeRestricted = storageService.read<bool>('isAgeRestricted') ?? false;
                          final String savedAge = storageService.read<String>('minAgeRestriction') ?? "18";
                          final String ticketLink = storageService.read<String>('ticketSite') ?? "https://scoutevents.co.za/";
                          final String? tagsStr = storageService.read<String>('selectedTags');
                          final List<String> tags = tagsStr != null && tagsStr.isNotEmpty ? tagsStr.split(',').map((e) => e.trim()).toList() : [];
                          final List<String> ignoredUsers = storageService.read<List<String>>('hiddenUserIds') ?? [];
                          final List<String> inviteUser = storageService.read<List<String>>('inviteUserId') ?? [];
                          final dynamic rawActivities = storageService.read('eventActivities');
                          final List<Map<String, String>> activities = (rawActivities != null)
                              ? List<Map<String, String>>.from(rawActivities.map((e) => Map<String, String>.from(e as Map)))
                              : [];

                          // Data from main form (from our CreateEventFormController)
                          final File? eventImage = formController.eventImage.value;
                          final String title = formController.eventNameC.text.trim();
                          final String content = formController.descriptionC.text.trim();
                          final String date = formController.eventDateController.text.trim();
                          final String endDate = formController.endDateController.text.trim();
                          final String startTime = formController.startTimeController.text.trim();
                          final String endTime = formController.endTimeController.text.trim();
                          final String address = formController.locationText.value == "Tap to select location"
                              ? ""
                              : formController.locationText.value;
                          final dynamic latitude = formController.selectedLatitude.value ?? 0.0;
                          final dynamic longitude = formController.selectedLongitude.value ?? 0.0;

                          // Validations
                          if (eventImage == null) {
                            CustomToast.showToast("Please select an event image", isError: true);
                            return;
                          }
                          if (title.isEmpty) {
                            CustomToast.showToast("Event title is required", isError: true);
                            return;
                          }
                          if (address.isEmpty) {
                            CustomToast.showToast("Event location is required", isError: true);
                            return;
                          }
                          if (content.isEmpty) {
                            CustomToast.showToast("Event description is required", isError: true);
                            return;
                          }
                          if (date.isEmpty) {
                            CustomToast.showToast("Event date is required", isError: true);
                            return;
                          }
                          if (endDate.isEmpty) {
                            CustomToast.showToast("Event end date is required", isError: true);
                            return;
                          }
                          if (startTime.isEmpty) {
                            CustomToast.showToast("Start time is required", isError: true);
                            return;
                          }
                          if (endTime.isEmpty) {
                            CustomToast.showToast("End time is required", isError: true);
                            return;
                          }

                          eventCreateController
                              .createEvent(
                                eventFile: eventImage,
                                title: title,
                                content: content,
                                date: date,
                                endDate: endDate,
                                startTime: startTime,
                                endTime: endTime,
                                address: address,
                                isPublic: !eventPrivate,
                                // Note: Your key is 'eventPrivate'
                                tags: tags,
                                isAgeRestricted: isAgeRestricted,
                                ageRestriction: int.tryParse(savedAge.toString()),
                                isCoatCheckRequired: isCoatCheckRequired,
                                isOwnAlcoholAllowed: isOwnAlcoholAllowed,
                                activities: activities,
                                ignoredUsers: ignoredUsers,
                                latitude: latitude,
                                longitude: longitude,
                                inviteUser: inviteUser,
                                ticketLink: ticketLink,
                              )
                              .then((_) {
                                // On success, clear the form state
                                if (!eventCreateController.isLoading.value) {
                                  /*
                                  * // TODO: This needs Attention in the future
                                  * Assuming createEvent doesn't throw on success
                                  * and success is handled inside the controller.
                                  * We need a better way to check for success, but for now:
                                  * Let's modify the createEvent controller to clear it.
                                  * */
                                }
                              });
                        },
                        iconWant: false,
                      );
              }),

              CustomButtonWidget(
                weight: FontWeight.w500,
                btnTextColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: Colors.transparent,
                btnText: "Cancel",
                onTap: () {
                  formController.clearFormState();
                  Get.back();
                },
                iconWant: false,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
