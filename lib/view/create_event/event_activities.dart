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
  List<Map<String, String>> activities = [];
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    List<dynamic>? savedActivities =
        _storageService.read<List>('eventActivities');
    if (savedActivities != null) {
      setState(() {
        activities = savedActivities
            .map<Map<String, String>>((e) => Map<String, String>.from(e))
            .toList();
      });
    }
  }

  void _saveActivities() {
    _storageService.write('eventActivities', activities);
    print("📝 Activities Saved Locally: $activities");

    CustomToast.showToast("Activities Updated", isError: false);
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
    final isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
              primary: AppColors.btnColor,
              surface: Colors.grey,
            )
                : ColorScheme.light(
              primary: AppColors.btnColor,
            ),
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
    bool isDarkMode =
        Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: "Event Activities"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _addActivity,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                        color: isDarkMode ? Colors.white : Colors.black),
                    SizedBox(width: 8),
                    CustomText(
                      color: isDarkMode ? Colors.white : Colors.black,
                      text: "Add activity",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Color(0xFF4B515580)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
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
                          onChanged: (val) {
                            setState(() {
                              activities[index]['name'] = val;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _selectTime(context, index, "startTime"),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text:
                                        activities[index]["startTime"]!.isEmpty
                                            ? "Start time"
                                            : activities[index]["startTime"]!,
                                    color:
                                        isDarkMode ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _selectTime(context, index, "endTime"),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text: activities[index]["endTime"]!.isEmpty
                                        ? "End time"
                                        : activities[index]["endTime"]!,
                                    color:
                                        isDarkMode ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _removeActivity(index),
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            label:
                                CustomText(text: "Delete", color: Colors.red),
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
              child: CustomButtonWidget(
                bgColor: AppColors.btnColor,
                btnText: "Update",
                onTap: _saveActivities,
                iconWant: false,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}
