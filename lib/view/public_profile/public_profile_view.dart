// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/profile_shimmer_widget.dart';
import 'package:restaurent_discount_app/view/public_profile/controller/connect_post_controller.dart';
import 'package:restaurent_discount_app/view/public_profile/controller/get_public_controller.dart';
import 'package:restaurent_discount_app/view/public_profile/widget/more_option_bottom_sheet.dart';
import 'package:restaurent_discount_app/view/public_profile/widget/stats_box_widget.dart';
import 'package:restaurent_discount_app/view/public_profile/widget/urls_sheet_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../common widget/no_data_found_widget.dart';
import '../../uitilies/custom_loader.dart';
import '../create_event/controller/theme_controller.dart';
import '../event_details/event_details_view.dart';
import '../home_view/widget/home_card_widget.dart';

class PublicProfile extends StatefulWidget {
  final dynamic userId;

  const PublicProfile({super.key, required this.userId});

  @override
  _PublicProfileState createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  final PublicProfileController _publicProfileController =
      Get.put(PublicProfileController());

  final ConnectWithUserController _connectWithUserController =
      Get.put(ConnectWithUserController());

  @override
  void initState() {
    super.initState();
    _publicProfileController.getPublicProfile(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          actions: [
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => MoreOptionsBottomSheet(),
                  );
                },
                child: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
            SizedBox(width: 20),
          ],
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Display profile info
              Obx(() {
                return _publicProfileController.isLoading.value
                    ? ProfileShimmerWidget()
                    : _publicProfileController
                                .nurseData.value.data?.isPrivate ==
                            true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 50,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              SizedBox(height: 20),
                              CustomText(
                                text: 'Profile is private',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: AppColors.btnColor, width: 2),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: (_publicProfileController
                                              .nurseData
                                              .value
                                              .data
                                              ?.profilePicture
                                              ?.isEmpty ??
                                          true)
                                      ? NetworkImage(
                                          'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                      : NetworkImage(_publicProfileController
                                          .nurseData.value.data!.profilePicture
                                          .toString()) as ImageProvider,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        '${_publicProfileController.nurseData.value.data?.firstName ?? ""} ${_publicProfileController.nurseData.value.data?.lastName ?? ""}',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    italic: FontStyle.italic,
                                    text:
                                        '@${_publicProfileController.nurseData.value.data?.lastName ?? ""}',
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomText(
                                    italic: FontStyle.italic,
                                    text: _publicProfileController
                                            .nurseData.value.data?.bio ??
                                        "Bio not available",
                                    fontSize: 15,
                                    color:
                                        isDarkMode ? Colors.white : Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  Obx(() {
                                    return _publicProfileController
                                                .isLoading.value ==
                                            true
                                        ? CustomLoader()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              StatBox(
                                                title: 'Follower',
                                                value: _publicProfileController
                                                        .nurseData
                                                        .value
                                                        .data
                                                        ?.followerCount
                                                        ?.toString() ??
                                                    "0", // Check null and set 0 if null
                                              ),
                                              StatBox(
                                                title: 'Following',
                                                value: (_publicProfileController
                                                                .nurseData
                                                                .value
                                                                .data
                                                                ?.followCount
                                                                ?.toString() ??
                                                            "0") ==
                                                        "null"
                                                    ? "0" // If it's "null" string, show "0"
                                                    : _publicProfileController
                                                            .nurseData
                                                            .value
                                                            .data
                                                            ?.followCount
                                                            ?.toString() ??
                                                        "0", // Check null and set 0 if null
                                              ),
                                              StatBox(
                                                title: 'Event',
                                                value: (_publicProfileController
                                                                .nurseData
                                                                .value
                                                                .data
                                                                ?.events
                                                                ?.length ??
                                                            0) ==
                                                        0
                                                    ? "0"
                                                    : (_publicProfileController
                                                                .nurseData
                                                                .value
                                                                .data
                                                                ?.events
                                                                ?.length ??
                                                            0)
                                                        .toString(),
                                              ),
                                            ],
                                          );
                                  })
                                ],
                              ),
                            ],
                          );
              }),
              SizedBox(height: 20),
              // Connect Button

              Row(
                children: [
                  Obx(() {
                    return _connectWithUserController.isLoading.value == true
                        ? CustomLoader()
                        : Expanded(
                            child: CustomButtonWidget(
                              weight: FontWeight.w500,
                              btnTextColor:
                                  isDarkMode ? Colors.white : Colors.black,
                              bgColor: isDarkMode
                                  ? AppColors.btnColor
                                  : AppColors.btnColor,
                              btnText: _publicProfileController.nurseData.value
                                          .data?.isFollowedByMe ==
                                      true
                                  ? "Unfollow"
                                  : "Follow",
                              onTap: () {
                                if (_publicProfileController
                                        .nurseData.value.data?.isFollowedByMe ==
                                    true) {
                                  // If followed, initiate unfollow
                                  _connectWithUserController.connect(
                                    userId: _publicProfileController
                                            .nurseData.value.data?.id
                                            .toString() ??
                                        "n/a",
                                  );
                                  _publicProfileController.getPublicProfile(
                                      userId: _publicProfileController
                                              .nurseData.value.data?.id
                                              .toString() ??
                                          "n/a");
                                } else {
                                  // If not followed, initiate connect
                                  _connectWithUserController.connect(
                                    userId: _publicProfileController
                                            .nurseData.value.data?.id
                                            .toString() ??
                                        "n/a",
                                  );
                                  _publicProfileController.getPublicProfile(
                                      userId: _publicProfileController
                                              .nurseData.value.data?.id
                                              .toString() ??
                                          "n/a");
                                }
                              },
                              iconWant: false,
                            ),
                          );
                  }),
                  SizedBox(width: 20),
                  // Only show the link icon if the user is not followed by you
                  _publicProfileController
                              .nurseData.value.data?.isFollowedByMe ==
                          true
                      ?  GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (_) => UrlsBottomSheet(),
                            );
                          },
                          child: Icon(
                            Icons.insert_link_outlined,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 30,
                          ),
                        ):SizedBox()
                ],
              ),

              const SizedBox(height: 10),

              Obx(() {
                return _publicProfileController.isLoading.value == true
                    ? Shimmer.fromColors(
                        baseColor: AppColors.btnColor.withOpacity(0.5),
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: 100,
                          height: 20,
                        ),
                      )
                    : CustomText(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        text:
                            "${_publicProfileController.nurseData.value.data?.firstName ?? ""} Events:",
                        color: isDarkMode ? Colors.white : Colors.black);
              }),

              Obx(() {
                if (_publicProfileController.isLoading.value) {
                  return CustomLoader();
                }

                final eventList =
                    _publicProfileController.nurseData.value.data?.events ?? [];

                if (eventList.isEmpty) {
                  return Center(
                    child: NotFoundWidget(message: 'Oops! No Event Found'),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: eventList.length,
                    itemBuilder: (_, index) {
                      final event = eventList[index];

                      final interestedPeopleImages = event.interestEvents
                          .map((interestEvent) =>
                              interestEvent.user?.profilePicture ??
                              'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                          .toList();

                      return EventCard(
                        eventId: event.id,
                        image: event.image.toString(),
                        eventName: event.title ?? '',
                        eventDate:
                            event.date?.toLocal().toString().split(' ')[0] ??
                                '',
                        categories: event.tags,
                        eventDescription: event.content ?? '',
                        friendsInterested: event.interestEvents.length,
                        onTap: () {},
                        interestedPeopleImage: interestedPeopleImages,
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
