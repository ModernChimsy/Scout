import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';

class EventActivitiesPage extends StatefulWidget {
  const EventActivitiesPage({super.key});

  @override
  _EventActivitiesPageState createState() => _EventActivitiesPageState();
}

class _EventActivitiesPageState extends State<EventActivitiesPage> {
  final StorageService _storageService = StorageService();
  List<Map<String, String>> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    List<dynamic>? savedActivities = _storageService.read<List>('eventActivities');
    if (savedActivities != null) {
      activities = savedActivities.map<Map<String, String>>((e) => Map<String, String>.from(e)).toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveActivitiesAndExit() {
    if (activities.isEmpty) {
      Get.back();
      return;
    }

    for (var activity in activities) {
      if (activity['name']!.isEmpty || activity['startTime']!.isEmpty || activity['endTime']!.isEmpty) {
        CustomToast.showToast("Please fill all fields for all activities.", isError: true);
        return;
      }
    }

    _storageService.write('eventActivities', activities);
    CustomToast.showToast("Activities Updated", isError: false);

    Get.back();
  }

  void _addActivity() {
    setState(() {
      activities.add({"name": "", "startTime": "", "endTime": ""});
    });
  }

  void _removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  Future<void> _selectTime(BuildContext context, int index, String key) async {
    FocusScope.of(context).unfocus();

    final isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    TimeOfDay? pickedTime = await showTimePicker(
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

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      setState(() {
        activities[index][key] = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: "Event Activities"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _addActivity,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF4B515580) : const Color(0xFFFFF5F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 8),
                    CustomText(color: isDarkMode ? Colors.white : Colors.black, text: "Add activity", fontSize: 16, fontWeight: FontWeight.w500),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? const Color(0xff4b515580) : Colors.grey.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                          iconColor: Colors.white,
                          fillColor: isDarkMode ? Colors.black : Colors.white,
                          borderColor: Colors.grey,
                          hintText: 'Activity Name',
                          showObscure: false,
                          initialValue: activities[index]['name'],
                          onChanged: (val) {
                            activities[index]['name'] = val;
                          },
                          onSubmitted: (_) {
                            if (index < activities.length - 1) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(context, index, "startTime"),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.black : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text: activities[index]["startTime"]!.isEmpty ? "Start time" : activities[index]["startTime"]!,
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectTime(context, index, "endTime"),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.black : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text: activities[index]["endTime"]!.isEmpty ? "End time" : activities[index]["endTime"]!,
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _removeActivity(index),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const CustomText(text: "Delete", color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveActivitiesAndExit, iconWant: false),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}
