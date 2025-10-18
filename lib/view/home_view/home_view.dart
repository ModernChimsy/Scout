// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/common widget/no_data_found_widget.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final log = Logger();

  final ScrollController _scrollController = ScrollController();
  final ProfileGetController _profileGetController = Get.put(ProfileGetController());
  final AllEventController _allEventController = Get.put(AllEventController());
  final TodayEventController _todayEventController = Get.put(TodayEventController());
  final FriendsEventController _friendsEventController = Get.put(FriendsEventController());
  final List<String> tabs = ['For You', 'Friends', 'Today'];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _profileGetController.getProfile();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_currentIndex == 0) {
        _allEventController.fetchEvents();
      } else if (_currentIndex == 1) {
        _friendsEventController.fetchFriendsEvents();
      } else if (_currentIndex == 2) {
        _todayEventController.fetchTodayEvents();
      }
    }
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
                        text: _profileGetController.profile.value.data?.firstName ?? "User",
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
                  final Color activeColor = isDarkMode ? AppColors.tabActiveColorDark : AppColors.tabActiveColorLight;
                  final Color inactiveColor = isDarkMode ? AppColors.tabInActiveColorDark : AppColors.tabInActiveColorLight;
                  final Color backgroundColor = _currentIndex == index ? activeColor : inactiveColor;

                  final Color textColor;
                  if (_currentIndex == index) {
                    textColor = isDarkMode ? Colors.black : Colors.white;
                  } else {
                    textColor = isDarkMode ? Colors.white : Colors.black;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;

                        if (_currentIndex == 0) {
                          _allEventController.getInitialEvents();
                        } else if (_currentIndex == 2) {
                          _todayEventController.getInitialTodayEvents();
                        } else if (_currentIndex == 1) {
                          _friendsEventController.getInitialFriendsEvents();
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(20)),
                      child: CustomText(
                        text: tabs[index],
                        fontSize: 15,
                        fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Obx(() {
                /// Tab - For You
                if (_currentIndex == 0) {
                  final eventList = _allEventController.eventList;

                  if (_allEventController.isLoading.value && eventList.isEmpty) {
                    return CustomLoader();
                  }

                  if (eventList.isEmpty && !_allEventController.isLoading.value) {
                    return Center(child: NotFoundWidget(message: 'Oops! No Event Found'));
                  }

                  return RefreshIndicator(
                    onRefresh: _allEventController.getInitialEvents,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: eventList.length + (_allEventController.hasMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index == eventList.length) {
                          return Center(child: Padding(padding: const EdgeInsets.all(12.0), child: CustomLoader()));
                        }

                        final event = eventList[index];

                        final interestedPeopleImages = (event.interestEvents)
                            .map((interestEvent) => (interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png'))
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                          child: EventCard(
                            eventId: event.id,
                            image: (event.image != null && event.image!.isNotEmpty) ? event.image.toString() : 'https://d29ragbbx3hr1.cloudfront.net/placeholder.png',
                            eventName: event.title ?? '',
                            eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                            categories: event.tags,
                            eventDescription: event.content ?? '',
                            friendsInterested: event.interestEvents.length,
                            onTap: () => Get.to(() => EventDetailPage(eventId: event.id!)),
                            interestedPeopleImage: interestedPeopleImages,
                          ),
                        );
                      },
                    ),
                  );
                }

                /// Tab - Friends
                if (_currentIndex == 1) {
                  final eventList = _friendsEventController.eventList;

                  if (_friendsEventController.isLoading.value && eventList.isEmpty) {
                    return CustomLoader();
                  }

                  if (eventList.isEmpty && !_friendsEventController.isLoading.value) {
                    return Center(child: NotFoundWidget(message: 'Oops! Friends not Found'));
                  }

                  return RefreshIndicator(
                    onRefresh: _friendsEventController.getInitialFriendsEvents,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: eventList.length + (_friendsEventController.hasMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index == eventList.length) {
                          return Center(child: Padding(padding: const EdgeInsets.all(12.0), child: CustomLoader()));
                        }

                        final event = eventList[index];

                        final interestedPeopleImages = (event.interestEvents)
                            .map((interestEvent) => (interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png'))
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                          child: EventCard(
                            eventId: event.id,
                            image: event.image.toString(),
                            eventName: event.title ?? '',
                            eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                            categories: event.tags,
                            eventDescription: event.content ?? '',
                            friendsInterested: event.interestEvents.length,
                            onTap: () => Get.to(() => EventDetailPage(eventId: event.id!)),
                            interestedPeopleImage: interestedPeopleImages,
                          ),
                        );
                      },
                    ),
                  );
                }

                /// Tab - Today
                if (_currentIndex == 2) {
                  final eventList = _todayEventController.eventList;

                  if (_todayEventController.isLoading.value && eventList.isEmpty) {
                    return CustomLoader();
                  }

                  if (eventList.isEmpty && !_todayEventController.isLoading.value) {
                    return Center(child: NotFoundWidget(message: 'Oops! Today Event not Found'));
                  }

                  return RefreshIndicator(
                    onRefresh: _todayEventController.getInitialTodayEvents,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: eventList.length + (_todayEventController.hasMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index == eventList.length) {
                          return Center(child: Padding(padding: const EdgeInsets.all(12.0), child: CustomLoader()));
                        }

                        final event = eventList[index];

                        final interestedPeopleImages = (event.interestEvents)
                            .map((interestEvent) => (interestEvent.user?.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png'))
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                          child: EventCard(
                            eventId: event.id,
                            image: event.image.toString(),
                            eventName: event.title ?? '',
                            eventDate: event.date?.toLocal().toString().split(' ')[0] ?? '',
                            categories: event.tags,
                            eventDescription: event.content ?? '',
                            friendsInterested: event.interestEvents.length,
                            onTap: () => Get.to(() => EventDetailPage(eventId: event.id!)),
                            interestedPeopleImage: interestedPeopleImages,
                          ),
                        );
                      },
                    ),
                  );
                }

                return Container();
              }),
            ),
          ],
        ),
      );
    });
  }
}
