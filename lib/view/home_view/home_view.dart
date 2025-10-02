// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/event_details/event_details_view.dart';
import 'package:restaurent_discount_app/view/home_view/controller/friends_event_view.dart';
import 'package:restaurent_discount_app/view/home_view/controller/today_event_controller.dart';
import 'package:restaurent_discount_app/view/home_view/widget/home_card_widget.dart';
import 'package:restaurent_discount_app/view/notification_view/notification_view.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/profile_get_controller.dart';
import 'package:restaurent_discount_app/view/home_view/controller/all_event_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../common widget/no_data_found_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final log = Logger();

  int _currentIndex = 0;

  final ProfileGetController _profileGetController = Get.put(ProfileGetController());
  final AllEventController _allEventController = Get.put(AllEventController());
  final TodayEventController _todayEventController = Get.put(TodayEventController());
  final FriendsEventController _friendsEventController = Get.put(FriendsEventController());
  final List<String> tabs = ['For You', 'Friends', 'Today'];

  @override
  void initState() {
    super.initState();
    _profileGetController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Obx(() {
            return _profileGetController.isLoading.value
                ? Row(
                    children: [
                      CustomText(text: 'Hello', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                      SizedBox(width: 10),
                      Shimmer.fromColors(
                        baseColor: AppColors.btnColor.withOpacity(0.5),
                        highlightColor: Colors.grey.shade400,
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          width: 100,
                          height: 25,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CustomText(text: 'Hello', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                      SizedBox(width: 10),
                      CustomText(
                        text: '${_profileGetController.profile.value.data?.firstName ?? "User"}',
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  );
          }),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () => Get.to(() => NotificationScreen()),
              child: Image.asset("assets/images/Bell.png", width: 30, color: isDarkMode ? Colors.white : Colors.black),
            ),
            SizedBox(width: 20),
          ],
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(tabs.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;

                        if (_currentIndex == 0) {
                          _allEventController.getEvent();
                        } else if (_currentIndex == 2) {
                          _todayEventController.getToday();
                        } else if (_currentIndex == 1) {
                          _friendsEventController.getFriendsEvent();
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? AppColors.btnColor : Color(0xFFFFF5F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomText(
                        text: tabs[index],
                        fontSize: 15,
                        fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
                        color: _currentIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (_currentIndex == 1) {
                  if (_friendsEventController.isLoading.value) {
                    return CustomLoader();
                  }

                  final eventList = _friendsEventController.nurseData.value.data ?? [];

                  if (eventList.isEmpty) {
                    return Center(child: NotFoundWidget(message: 'Oops! Friends not Found'));
                  }

                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: eventList.length,
                    itemBuilder: (_, index) {
                      final event = eventList[index];

                      final interestedPeopleImages = event.interestEvents
                          .map(
                            (interestEvent) =>
                                interestEvent.user?.profilePicture ??
                                'https://t4.ftcdn.net/jpg/07/03/86/11/360_F_703861114_7YxIPnoH8NfmbyEffOziaXy0EO1NpRHD.jpg',
                          )
                          .toList();

                      log.d("🧩 eventId: ${event.id}");
                      log.d("🧩 image: ${event.image}");

                      return EventCard(
                        eventId: event.id,
                        image: event.image.toString(),
                        eventName: event.title ?? '',
                        eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                        categories: event.tags,
                        eventDescription: event.content ?? '',
                        friendsInterested: event.interestEvents.length,
                        onTap: () => Get.to(() => EventDetailPage(eventId: event.id)),
                        interestedPeopleImage: interestedPeopleImages,
                      );
                    },
                  );
                }

                if (_currentIndex == 2) {
                  if (_todayEventController.isLoading.value) {
                    return CustomLoader();
                  }

                  final eventList = _todayEventController.nurseData.value.data ?? [];

                  if (eventList.isEmpty) {
                    return Center(child: NotFoundWidget(message: 'Oops! Today Event not Found'));
                  }

                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: eventList.length,
                    itemBuilder: (_, index) {
                      final event = eventList[index];

                      final interestedPeopleImages = event.interestEvents
                          .map(
                            (interestEvent) =>
                                interestEvent.user?.profilePicture ??
                                'https://t4.ftcdn.net/jpg/07/03/86/11/360_F_703861114_7YxIPnoH8NfmbyEffOziaXy0EO1NpRHD.jpg',
                          )
                          .toList();

                      log.d("🧩 eventId: ${event.id}");
                      log.d("🧩 image: ${event.image}");

                      return EventCard(
                        eventId: event.id,
                        image: event.image.toString(),
                        eventName: event.title ?? '',
                        eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                        categories: event.tags,
                        eventDescription: event.content ?? '',
                        friendsInterested: event.interestEvents.length,
                        onTap: () => Get.to(() => EventDetailPage(eventId: event.id)),
                        interestedPeopleImage: interestedPeopleImages,
                      );
                    },
                  );
                }

                if (_allEventController.isLoading.value) {
                  return CustomLoader();
                }

                final eventList = _allEventController.nurseData.value.data ?? [];

                if (eventList.isEmpty) {
                  return Center(child: NotFoundWidget(message: 'Oops! No Event Found'));
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: eventList.length,
                  itemBuilder: (_, index) {
                    final event = eventList[index];

                    final interestedPeopleImages = event.interestEvents
                        .map(
                          (interestEvent) =>
                              interestEvent.user?.profilePicture ??
                              'https://t4.ftcdn.net/jpg/07/03/86/11/360_F_703861114_7YxIPnoH8NfmbyEffOziaXy0EO1NpRHD.jpg',
                        )
                        .toList();

                    log.d("🧩 eventId: ${event.id}");
                    log.d("🧩 image: ${event.image}");

                    return EventCard(
                      eventId: event.id,
                      image: (event.image != null && event.image!.isNotEmpty)
                          ? event.image.toString()
                          : 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                      eventName: event.title ?? '',
                      eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                      categories: event.tags,
                      eventDescription: event.content ?? '',
                      friendsInterested: event.interestEvents.length,
                      onTap: () => Get.to(() => EventDetailPage(eventId: event.id)),
                      interestedPeopleImage: interestedPeopleImages,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
