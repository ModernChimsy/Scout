import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurent_discount_app/uitilies/data/hive_data/hive_model_class_dart.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/splash%20view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart'; // ❗️ ADD: Firebase Core import
import 'firebase_options.dart'; // ❗️ ADD: Firebase Options import

void main() async {
  // Ensure Flutter bindings are initialized (you already have this)
  WidgetsFlutterBinding.ensureInitialized();

  // ❗️ ADDED: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Your existing initializations
  await GetStorage.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(EventCardModelAdapter());
  await Hive.openBox<EventCardModel>('bookmarks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Scout App',
            themeMode: _getThemeMode(themeController.selectedTheme),
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            ),
            home: SplashView(),
          );
        });
      },
    );
  }

  ThemeMode _getThemeMode(String selectedTheme) {
    if (selectedTheme == ThemeController.darkTheme) {
      return ThemeMode.dark;
    } else if (selectedTheme == ThemeController.lightTheme) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }
}
