// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/get_my_event_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/get_my_interested_event.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/profile_get_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/account_settings_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/my_details_view.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/profile_shimmer_widget.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ProfileGetController _profileGetController = Get.put(ProfileGetController());
  final MyInterstedController _myInterestedController = Get.put(MyInterstedController());
  final GetMyEventController _getMyEventController = Get.put(GetMyEventController());

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    switch (_tabController.index) {
      case 0:
        _myInterestedController.getInterestedEvent();
        break;
      case 1:
        _getMyEventController.getMyEvent();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    _profileGetController.getProfile();
    _myInterestedController.getInterestedEvent();
    _getMyEventController.getMyEvent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

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
          title: CustomText(text: 'Profile', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => AccountSettingsScreen());
              },
              child: Image(image: AssetImage("assets/images/Gear.png"), color: isDarkMode ? Colors.white : Colors.black, width: 30),
            ),
            SizedBox(width: 20),
          ],
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return _profileGetController.isLoading.value
                      ? ProfileShimmerWidget()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              child: CircleAvatar(
                                backgroundImage:
                                    _profileGetController.profile.value.data!.profilePicture.toString().isEmpty ||
                                        _profileGetController.profile.value.data!.profilePicture == null
                                    ? NetworkImage('https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                    : NetworkImage(_profileGetController.profile.value.data!.profilePicture.toString()) as ImageProvider,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              text:
                                  '${_profileGetController.profile.value.data?.firstName ?? "John"} '
                                  '${_profileGetController.profile.value.data?.lastName ?? "Doe"}',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              italic: FontStyle.italic,
                              text: '@${_profileGetController.profile.value.data?.lastName ?? "johnnyboi"}',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                CustomText(
                                  italic: FontStyle.italic,
                                  text: (_profileGetController.profile.value.data?.bio?.isNotEmpty ?? false)
                                      ? _profileGetController.profile.value.data!.bio!
                                      : "Bio not available",
                                  fontSize: 15,
                                  color: isDarkMode ? Colors.white : Colors.grey,
                                ),
                                Divider(),
                                const SizedBox(height: 10),
                                Obx(() {
                                  if (_profileGetController.isLoading.value) {
                                    return CustomLoader();
                                  } else {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        StatBox(title: 'Follower', value: _profileGetController.profile.value.data?.followerCount?.toString() ?? "0"),
                                        StatBox(title: 'Following', value: _profileGetController.profile.value.data?.followCount?.toString() ?? "0"),
                                        StatBox(title: 'Event', value: _profileGetController.profile.value.data?.events.length.toString() ?? "0"),
                                      ],
                                    );
                                  }
                                }),
                              ],
                            ),
                          ],
                        );
                }),

                const SizedBox(height: 20),

                SizedBox(
                  height: 40,
                  child: CustomButtonWidget(
                    weight: FontWeight.w500,
                    btnTextColor: isDarkMode ? Colors.white : Colors.black,
                    bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                    btnText: "Event Create",
                    onTap: () {
                      Get.to(() => CreateEventView());
                    },
                    iconWant: false,
                  ),
                ),

                const SizedBox(height: 20),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Interested'),
                    Tab(text: 'My Events'),
                    Tab(text: 'Private'),
                  ],
                  labelColor: isDarkMode ? Colors.white : Colors.grey,
                  labelStyle: GoogleFonts.poppins(),
                  unselectedLabelColor: isDarkMode ? Colors.white : Colors.grey,
                  indicatorColor: Colors.black,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: max(
                    (_myInterestedController.nurseData.value.data?.length ?? 0) * 600,
                    (_getMyEventController.nurseData.value.data?.length ?? 0) * 600,
                  ),
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Obx(() {
                        if (_myInterestedController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final eventList = _myInterestedController.nurseData.value.data ?? [];

                        if (eventList.isEmpty) {
                          return NotFoundWidget(message: "No Create Event found");
                        }

                        return ListView.builder(
                          itemCount: eventList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final interestData = eventList[index];
                            final event = interestData.event;

                            final interestedPeopleImages =
                                event?.interestEvents
                                    .map((interestEvent) => interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                    .toList() ??
                                [];

                            return EventCard(
                              onDeleteTap: () {},
                              eventId: interestData.id,
                              image: (event?.image != null && event!.image!.isNotEmpty) ? event.image! : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                              eventName: event?.title ?? '',
                              eventDate: event?.date?.toLocal().toString().split(' ')[0] ?? '',
                              categories: event?.tags ?? [],
                              eventDescription: event?.content ?? '',
                              friendsInterested: event?.interestEvents.length ?? 0,
                              onTap: () => Get.to(() => EventDetailPage(eventId: interestData.id!)),
                              interestedPeopleImage: interestedPeopleImages,
                            );
                          },
                        );
                      }),
                      Obx(() {
                        if (_getMyEventController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final eventList = _getMyEventController.nurseData.value.data ?? [];

                        if (eventList.isEmpty) {
                          return NotFoundWidget(message: "No Create Event found");
                        }

                        return ListView.builder(
                          itemCount: eventList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final event = eventList[index];
                            final eventDetails = event;

                            final interestedPeopleImages = eventDetails.interestEvents
                                .map((interestEvent) => interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                .toList();

                            return EventCard(
                              onDeleteTap: () {},
                              eventId: event.id,
                              image: (event.image != null && event.image!.isNotEmpty) ? event.image.toString() : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                              eventName: eventDetails.title ?? '',
                              eventDate: eventDetails.date?.toLocal().toString().split(' ')[0] ?? '',
                              categories: eventDetails.tags,
                              eventDescription: eventDetails.content ?? '',
                              friendsInterested: eventDetails.interestEvents.length,
                              onTap: () => Get.to(() => EventDetailPage(eventId: event.id!)),
                              interestedPeopleImage: interestedPeopleImages,
                            );
                          },
                        );
                      }),
                      Obx(() {
                        if (_getMyEventController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final allEvents = _getMyEventController.nurseData.value.data ?? [];
                        final privateEvents = allEvents.where((e) => e.isPublic == false).toList();

                        if (privateEvents.isEmpty) {
                          return NotFoundWidget(message: "No Private Event found");
                        }

                        return ListView.builder(
                          itemCount: privateEvents.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final event = privateEvents[index];

                            final interestedPeopleImages = event.interestEvents
                                .map((interestEvent) => interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png',)
                                .toList();

                            return EventCard(
                              eventId: event.id,
                              image: (event.image != null && event.image!.isNotEmpty) ? event.image.toString() : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                              eventName: event.title ?? '',
                              eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                              categories: event.tags,
                              eventDescription: event.content ?? '',
                              friendsInterested: event.interestEvents.length,
                              onTap: () => Get.to(() => EventDetailPage(eventId: event.id!)),
                              interestedPeopleImage: interestedPeopleImages,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
