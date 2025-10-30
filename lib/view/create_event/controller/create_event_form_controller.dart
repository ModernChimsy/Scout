// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class CreateEventFormController extends GetxController {
  static final log = Logger();
  final StorageService _storageService = Get.find<StorageService>();

  // Storage Keys
  static const String _imageKey = 'event_form_image';
  static const String _nameKey = 'event_form_name';
  static const String _descKey = 'event_form_desc';
  static const String _locTextKey = 'event_form_loc_text';
  static const String _locLatKey = 'event_form_loc_lat';
  static const String _locLngKey = 'event_form_loc_lng';
  static const String _dateKey = 'event_form_date';
  static const String _endDateKey = 'event_form_end_date';
  static const String _startTimeKey = 'event_form_start_time';
  static const String _endTimeKey = 'event_form_end_time';

  // Controllers
  late TextEditingController eventNameC;
  late TextEditingController descriptionC;
  late TextEditingController eventDateController;
  late TextEditingController endDateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  // Reactive State
  final Rx<File?> eventImage = Rx<File?>(null);
  final RxString locationText = "Tap to select location".obs;
  final Rx<double?> selectedLatitude = Rx<double?>(null);
  final Rx<double?> selectedLongitude = Rx<double?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadFormState();
  }

  void _loadFormState() {
    // Load text controllers
    eventNameC = TextEditingController(text: _storageService.read<String>(_nameKey) ?? '');
    descriptionC = TextEditingController(text: _storageService.read<String>(_descKey) ?? '');
    eventDateController = TextEditingController(text: _storageService.read<String>(_dateKey) ?? '');
    endDateController = TextEditingController(text: _storageService.read<String>(_endDateKey) ?? '');
    startTimeController = TextEditingController(text: _storageService.read<String>(_startTimeKey) ?? '');
    endTimeController = TextEditingController(text: _storageService.read<String>(_endTimeKey) ?? '');

    // Load image
    final imagePath = _storageService.read<String>(_imageKey);
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        eventImage.value = file;
      }
    }

    // Load location
    locationText.value = _storageService.read<String>(_locTextKey) ?? "Tap to select location";
    selectedLatitude.value = _storageService.read<double>(_locLatKey);
    selectedLongitude.value = _storageService.read<double>(_locLngKey);
  }

  void saveFormState() {
    _storageService.write(_nameKey, eventNameC.text);
    _storageService.write(_descKey, descriptionC.text);
    _storageService.write(_dateKey, eventDateController.text);
    _storageService.write(_endDateKey, endDateController.text);
    _storageService.write(_startTimeKey, startTimeController.text);
    _storageService.write(_endTimeKey, endTimeController.text);
    _storageService.write(_imageKey, eventImage.value?.path ?? '');
    _storageService.write(_locTextKey, locationText.value);
    _storageService.write(_locLatKey, selectedLatitude.value);
    _storageService.write(_locLngKey, selectedLongitude.value);
    log.d("✅ Form state saved to local storage.");
  }

  void clearFormState() {
    eventNameC.clear();
    descriptionC.clear();
    eventDateController.clear();
    endDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    eventImage.value = null;
    locationText.value = "Tap to select location";
    selectedLatitude.value = null;
    selectedLongitude.value = null;

    _storageService.remove(_nameKey);
    _storageService.remove(_descKey);
    _storageService.remove(_dateKey);
    _storageService.remove(_endDateKey);
    _storageService.remove(_startTimeKey);
    _storageService.remove(_endTimeKey);
    _storageService.remove(_imageKey);
    _storageService.remove(_locTextKey);
    _storageService.remove(_locLatKey);
    _storageService.remove(_locLngKey);

    log.d("🗑️ Cleared event form state from local storage.");
  }

  // --- Picker Logic ---
  Future<void> pickDate(BuildContext context, TextEditingController controller) async {
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

  Future<void> pickTime(BuildContext context, TextEditingController controller) async {
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

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      eventImage.value = File(image.path);
    }
  }

  Future<void> pickLocation(BuildContext context) async {
    LocationData? locationData = await LocationSearch.show(
      context: context,
      mode: Mode.overlay,
      userAgent: UserAgent(appName: 'Scout', email: 'support@scout.com'),
    );

    if (locationData != null) {
      locationText.value = locationData.address;
      selectedLatitude.value = locationData.latitude;
      selectedLongitude.value = locationData.longitude;
      log.d("🧩 Selected Location Lat: ${selectedLatitude.value}, Lng: ${selectedLongitude.value}");
    }
  }
}