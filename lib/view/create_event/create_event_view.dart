// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/age_restrictions_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/event_create_controller.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/event_activities.dart';
import 'package:restaurent_discount_app/view/create_event/event_visibility_view.dart';
import 'package:restaurent_discount_app/view/create_event/extra_view.dart';
import 'package:restaurent_discount_app/view/create_event/tags_view.dart';
import 'package:restaurent_discount_app/view/create_event/tickets_view.dart';
import 'package:restaurent_discount_app/view/create_event/widget/event_card_widget.dart';

import '../../uitilies/api/local_storage.dart';
import '../../uitilies/custom_toast.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  static final log = Logger();

  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final TextEditingController _eventNameC = TextEditingController();
  final TextEditingController _descriptionC = TextEditingController();

  File? _eventImage;

  final EventCreateController _eventCreateController = Get.put(EventCreateController());

  String locationText = "Tap to select location";
  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService());
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(primary: AppColors.btnColor, surface: Colors.grey)
                : ColorScheme.light(primary: AppColors.btnColor),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      controller.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(primary: AppColors.btnColor, surface: Colors.grey)
                : ColorScheme.light(primary: AppColors.btnColor),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      controller.text = time.format(context);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _eventImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: CustomAppBar(title: "Event Information"),
      body: Padding(
        padding: AppPadding.bodyPadding,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: DottedBorder(
                    radius: Radius.circular(15),
                    dashPattern: [8, 9],
                    color: AppColors.btnColor,
                    child: _eventImage == null
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
                            child: Image.file(_eventImage!, fit: BoxFit.cover, width: double.infinity),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              CustomTextField(
                controller: _eventNameC,
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
                onTap: () async {
                  LocationData? locationData = await LocationSearch.show(
                    context: context,
                    mode: Mode.overlay,
                    userAgent: UserAgent(appName: 'Scout', email: 'support@scout.com'),
                  );

                  if (locationData != null) {
                    setState(() {
                      setState(() {
                        locationText = locationData.address;
                        selectedLatitude = locationData.latitude;
                        selectedLongitude = locationData.longitude;
                      });
                    });
                    log.d("🧩 Selected Location Lat: $selectedLatitude, Lng: $selectedLongitude");
                  }
                },
                child: Container(
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
                          locationText,
                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Start Date Picker
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickDate(_eventDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _eventDateController,
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
                onTap: () => _pickDate(_endDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _endDateController,
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
                      onTap: () => _pickTime(_startTimeController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _startTimeController,
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
                      onTap: () => _pickTime(_endTimeController),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _endTimeController,
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
                controller: _descriptionC,
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
                  Get.to(() => TicketsView());
                },
                title: 'Tickets',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => TagsView());
                },
                title: 'Tags',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => EventActivitiesPage());
                },
                title: 'Event Activities',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => AgesRestrictionView());
                },
                title: 'Age restrictions',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => ExtraView());
                },
                title: 'Extra',
              ),
              SizedBox(height: 20),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => EventVisibilityView());
                },
                title: 'Event visibility',
              ),

              /// Buttons
              SizedBox(height: 50.h),

              Obx(() {
                return _eventCreateController.isLoading.value == true
                    ? CustomLoader()
                    : CustomButtonWidget(
                        bgColor: AppColors.btnColor,
                        btnText: "Create Event",
                        onTap: () {
                          final _storageService = Get.find<StorageService>();

                          final bool isOwnAlcoholAllowed = _storageService.read<bool>('ownAlcohol') ?? false;
                          final bool isCoatCheckRequired = _storageService.read<bool>('coatCheck') ?? false;
                          final bool eventPrivate = _storageService.read<bool>('eventPrivate') ?? false;
                          final bool isAgeRestricted = _storageService.read<bool>('isAgeRestricted') ?? false;

                          final String savedAge = _storageService.read<String>('minAgeRestriction') ?? "18";
                          final String ticketLink = _storageService.read<String>('ticketSite') ?? "https://scoutevents.co.za/";
                          final String? tagsStr = _storageService.read<String>('selectedTags');

                          final List<String> tags = tagsStr != null && tagsStr.isNotEmpty ? tagsStr.split(',').map((e) => e.trim()).toList() : [];
                          final List<String> ignoredUsers = _storageService.read<List<String>>('hiddenUserIds') ?? [];
                          final List<String> inviteUser = _storageService.read<List<String>>('inviteUserId') ?? [];

                          final String title = _eventNameC.text.trim();
                          final String content = _descriptionC.text.trim();
                          final String date = _eventDateController.text.trim();
                          final String endDate = _endDateController.text.trim();
                          final String startTime = _startTimeController.text.trim();
                          final String endTime = _endTimeController.text.trim();

                          final dynamic rawActivities = _storageService.read('eventActivities');
                          final List<Map<String, String>> activities = (rawActivities != null)
                              ? List<Map<String, String>>.from(rawActivities.map((e) => Map<String, String>.from(e as Map)))
                              : [];

                          if (_eventImage == null) {
                            CustomToast.showToast("Please select an event image", isError: true);
                            return;
                          }
                          if (title.isEmpty) {
                            CustomToast.showToast("Event title is required", isError: true);
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

                          _eventCreateController.createEvent(
                            eventFile: _eventImage,
                            title: title,
                            content: content,
                            date: date,
                            endDate: endDate,
                            startTime: startTime,
                            endTime: endTime,
                            address: locationText,
                            isPublic: eventPrivate,
                            tags: tags,
                            isAgeRestricted: isAgeRestricted,
                            ageRestriction: int.tryParse(savedAge.toString()),
                            isCoatCheckRequired: isCoatCheckRequired,
                            isOwnAlcoholAllowed: isOwnAlcoholAllowed,
                            activities: activities,
                            ignoredUsers: ignoredUsers,
                            latitude: selectedLatitude ?? 0.0,
                            longitude: selectedLongitude ?? 0.0,
                            inviteUser: inviteUser,
                            ticketLink: ticketLink,
                          );
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
