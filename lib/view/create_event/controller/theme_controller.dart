import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final String _themeKey = "selectedTheme";

  static const String lightTheme = "light";
  static const String darkTheme = "dark";
  static const String systemTheme = "system";

  RxString _selectedTheme = lightTheme.obs;

  String get selectedTheme => _selectedTheme.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    String storedTheme = _storage.read(_themeKey) ?? lightTheme;
    _selectedTheme.value = storedTheme;
  }

  void setTheme(String theme) {
    _selectedTheme.value = theme;
    _storage.write(_themeKey, theme);
  }
}
