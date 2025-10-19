// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/get_user_controller.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import '../../common widget/custom text/custom_text_widget.dart';
import 'create_event_view.dart';

class HideEventPage extends StatefulWidget {
  const HideEventPage({super.key});

  @override
  _HideEventPageState createState() => _HideEventPageState();
}

class _HideEventPageState extends State<HideEventPage> {
  final GetUserController controller = Get.put(GetUserController());
  final StorageService _storageService = StorageService();
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> selectedUserIds = [];
  List<dynamic> _filteredUsers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedUserIds();
    _fetchUsers();

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _saveAndExit();
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _loadSelectedUserIds() {
    List<dynamic>? savedIds = _storageService.read<List>('hiddenUserIds');
    if (savedIds != null) {
      selectedUserIds = savedIds.map((e) => e.toString()).toList();
    }
  }

  void _fetchUsers() async {
    setState(() => isLoading = true);
    await controller.getUser();
    _filteredUsers = controller.nurseData.value.data ?? [];
    setState(() => isLoading = false);
  }

  void _toggleUserSelection(String id, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedUserIds.add(id);
      } else {
        selectedUserIds.remove(id);
      }
    });
    // TODO: save on every toggle if list is small, but Update button is safer, better for user experience in the future
  }

  void _filterUserList(String query) {
    final allUsers = controller.nurseData.value.data ?? [];

    if (query.isEmpty) {
      _filteredUsers = allUsers;
    } else {
      _filteredUsers = allUsers.where((user) {
        final name = (user.fullname ?? "").toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }

    setState(() {});
  }

  void _saveAndExit() {
    if (selectedUserIds.isEmpty) {
      CustomToast.showToast("No users selected. Event will be visible to all.", isError: false);
    }

    _storageService.write('hiddenUserIds', selectedUserIds);
    CustomToast.showToast("Hidden users updated successfully!", isError: false);

    Get.to(() => CreateEventView());
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: "Hide from others"),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: AppPadding.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Search",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6.h),
            CustomTextField(
              controller: searchController,
              focusNode: _focusNode,
              fillColor: Colors.transparent,
              borderColor: Colors.grey,
              hintText: "Search here...",
              showObscure: false,
              trailingIcon: Icons.search,
              onChanged: _filterUserList,
              onSubmitted: (_) => _saveAndExit(),
            ),
            SizedBox(height: 20),

            isLoading
                ? Expanded(child: Center(child: CustomLoader()))
                : Expanded(
                    child: _filteredUsers.isEmpty && searchController.text.isEmpty
                        ? Center(
                            child: Text("No users available.", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black54)),
                          )
                        : _filteredUsers.isEmpty
                        ? Center(
                            child: Text("No matching users found.", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black54)),
                          )
                        : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              final isSelected = selectedUserIds.contains(user.id);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user.profilePicture != null
                                      ? NetworkImage(user.profilePicture!)
                                      : NetworkImage("https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png"),
                                ),
                                title: CustomText(
                                  text: user.fullname ?? "Unknown",
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                ),
                                subtitle: CustomText(
                                  text: user.email ?? "No email",
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
                                  fontSize: 14,
                                  italic: FontStyle.italic,
                                  textAlign: TextAlign.start,
                                ),
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    _toggleUserSelection(user.id!, value!);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  side: BorderSide(color: AppColors.btnColor, width: 2),
                                  activeColor: AppColors.btnColor,
                                ),
                              );
                            },
                          ),
                  ),

            CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveAndExit, iconWant: false),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
