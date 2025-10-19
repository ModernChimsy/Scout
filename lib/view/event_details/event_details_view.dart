// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_date_format.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/event_details/activities_view.dart';
import 'package:restaurent_discount_app/view/event_details/interested_view.dart';
import 'package:restaurent_discount_app/view/event_details/widget/activities_row_widget.dart';
import 'package:restaurent_discount_app/view/event_details/widget/custom_image_card_widget.dart';
import 'package:restaurent_discount_app/view/event_details/widget/event_details_card.dart';
import 'package:restaurent_discount_app/view/event_details/widget/row_text_widget.dart';
import 'package:restaurent_discount_app/view/event_details/controller/event_details_controller.dart';
import 'package:restaurent_discount_app/view/home_view/controller/event_interested_controller.dart';
import 'package:restaurent_discount_app/view/public_profile/public_profile_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatefulWidget {
  final dynamic eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final EventDetailsController eventDetailsController = Get.put(EventDetailsController());

  final InterestedPostController _interestedPostController = Get.put(InterestedPostController());

  late Uri _url;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      CustomToast.showToast("Could not open the link", isError: true);
    }
  }

  final StorageService _storageService = Get.put(StorageService());

  @override
  void initState() {
    super.initState();
    eventDetailsController.getEventDetails(eventId: widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      var eventDetails = eventDetailsController.nurseData.value.data;

      final systemOverlayStyle = SystemUiOverlayStyle(
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      );

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,

        appBar: AppBar(
          systemOverlayStyle: systemOverlayStyle,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () => Get.back(),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,

          title: CustomText(text: "Event Details", color: isDarkMode ? Colors.white : Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
          centerTitle: true,

          actions: [
            GestureDetector(
              onTap: () {
                if (eventDetails != null) {
                  String title = eventDetails.title ?? "Event Title";
                  String description = eventDetails.content ?? "Event description not available.";
                  String imageUrl = eventDetails.image ?? "https://your-default-image-url.com/image.jpg";

                  final String content =
                      '''
Event: $title
Description: $description
$imageUrl
                  ''';

                  Share.share(content, subject: title);
                }
              },
              child: Image(image: AssetImage("assets/images/ShareNetwork.png"), color: isDarkMode ? Colors.white : Colors.black, width: 25),
            ),
            SizedBox(width: 16.w),
          ],
          toolbarHeight: 50,
        ),

        body: eventDetailsController.isLoading.value
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Event Image
                      Container(
                        width: double.infinity,
                        height: 300.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              eventDetails?.image?.isNotEmpty == true ? eventDetails!.image! : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Row(
                        children:
                            eventDetails?.tags.map((tag) {
                              List<Color> tagColors = [Color(0xFFd2dcff), Color(0xFFf4c2c2), Color(0xFFc8e6c9), Color(0xFFffecb3), Color(0xFFbbdefb)];

                              int colorIndex = eventDetails.tags.indexOf(tag);
                              Color tagColor = tagColors[colorIndex % tagColors.length];

                              return Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: CustomText(text: tag),
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ),

                      SizedBox(height: 10),

                      CustomText(
                        text: eventDetails?.title ?? 'Event Title',
                        fontSize: 18.sp,
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 4.h),

                      Row(
                        children: [
                          CustomText(color: isDarkMode ? Colors.white : Colors.black, text: 'Organised by', fontSize: 14.sp),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () async {
                              String? storedId = await _storageService.read<String>('id');

                              if (storedId == eventDetails?.userId.toString()) {
                                CustomToast.showToast("You cannot see your profile as a organizer", isError: true);
                              } else {
                                Get.to(() => PublicProfile(userId: eventDetails?.userId.toString() ?? ""));
                              }
                            },
                            child: CustomText(
                              color: isDarkMode ? Colors.white : Colors.black,
                              decorationColor: Colors.grey,
                              decoration: TextDecoration.underline,
                              text: eventDetails?.user?.fullname ?? 'Organizer',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      EventDetailsCard(
                        color: isDarkMode ? Colors.white : Colors.black,
                        date: eventDetails?.date != null
                            ? CustomDateFormatter.formatDate(eventDetails!.date!.toIso8601String())
                            : "Date not available",
                        addresss: eventDetails?.address ?? "n/a",
                      ),

                      SizedBox(height: 16.h),

                      RowTextWidget(name: 'Description', onTap: () {}, color: isDarkMode ? Colors.white : Colors.black),
                      SizedBox(height: 8.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        text: eventDetails?.content ?? "No event description available.",
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                      SizedBox(height: 16.h),

                      RowTextWidget(
                        name: 'Activities',
                        onTap: () {
                          if (eventDetails?.eventActivities != null) {
                            List<Map<String, String>> activities = eventDetails!.eventActivities.map((activity) {
                              return {'artist': activity.name ?? '', 'time': '${activity.startTime ?? ''} - ${activity.endTime ?? ''}'};
                            }).toList();

                            Get.to(() => ActivitiesPage(activities: activities));
                          }
                        },
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),

                      SizedBox(height: 8.h),
                      eventDetails?.eventActivities != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: eventDetails?.eventActivities.length ?? 0,
                              itemBuilder: (BuildContext context, index) {
                                var activity = eventDetails?.eventActivities[index];
                                return ActivitiesRowWidget(
                                  artistName: activity?.name ?? "Artist Name",
                                  time: "${activity?.startTime ?? '12:00'} - ${activity?.endTime ?? '12:30'}",
                                  color: isDarkMode ? Colors.white : Colors.black,
                                );
                              },
                            )
                          : SizedBox(),

                      SizedBox(height: 16.h),

                      CustomText(
                        color: isDarkMode ? Colors.white : Colors.black,
                        text: 'Additional Information',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        text: eventDetails?.isOwnAlcoholAllowed == true ? 'Alcohol is allowed' : 'Alcohol is not allowed',
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        text: eventDetails?.isAgeRestricted == true
                            ? 'Age restricted: ${eventDetails?.ageRestriction ?? "No age limit"}'
                            : 'No age restriction',
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        text: eventDetails?.isPublic == true ? 'This is a public event' : 'This is a private event',
                        fontSize: 14.sp,
                        color: isDarkMode ? Colors.white : Colors.black54,
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(height: 16.h),

                      RowTextWidget(
                        color: isDarkMode ? Colors.white : Colors.black,
                        name: 'Interested',
                        onTap: () {
                          if (eventDetails?.interestEvents != null && eventDetails!.interestEvents.isNotEmpty) {
                            List<Map<String, String>> activities = eventDetails.interestEvents.map((activity) {
                              return {
                                'fullName': (activity.user?.fullname ?? 'No Name') as String,
                                'profilePicture':
                                    (activity.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png') as String,
                              };
                            }).toList();

                            Get.to(() => InterestedPage(interested: activities));
                          }
                        },
                      ),

                      SizedBox(height: 10),

                      eventDetails?.interestEvents != null && eventDetails?.interestEvents.isNotEmpty == true
                          ? SizedBox(
                              height: 80.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: eventDetails?.interestEvents.length ?? 0,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  var interestedUser = eventDetails?.interestEvents[index].user;
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: CustomImageTextCard(
                                      imageUrl:
                                          interestedUser?.profilePicture ??
                                          "https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=",
                                      text: interestedUser?.fullname ?? "No Name",
                                      wordLimit: 3,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: CustomText(text: "No interest available", fontSize: 14.sp, color: isDarkMode ? Colors.white54 : Colors.black54),
                            ),

                      SizedBox(height: 30),

                      Obx(() {
                        return _interestedPostController.isLoading.value == true
                            ? CustomLoader()
                            : SizedBox(
                                width: double.infinity,
                                height: 40.h,
                                child: CustomButtonWidget(
                                  bgColor: AppColors.btnColor,
                                  btnText: "I’m interested",
                                  onTap: () {
                                    _interestedPostController.addToInterest(eventId: eventDetailsController.nurseData.value.data!.id.toString());
                                  },
                                  iconWant: false,
                                ),
                              );
                      }),

                      SizedBox(
                        width: double.infinity,
                        height: 40.h,
                        child: CustomButtonWidget(
                          bgColor: Colors.transparent,
                          btnTextColor: isDarkMode ? Colors.white : Colors.black,
                          weight: FontWeight.normal,
                          btnText: "Get tickets",
                          onTap: () async {
                            final link = eventDetailsController.nurseData.value.data?.ticketLink;

                            if (link != null && link.isNotEmpty) {
                              try {
                                _url = Uri.parse(link);
                                await _launchUrl();
                              } catch (e) {
                                CustomToast.showToast("Invalid ticket link", isError: true);
                              }
                            } else {
                              CustomToast.showToast("Ticket link not available", isError: true);
                            }
                          },
                          iconWant: false,
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
