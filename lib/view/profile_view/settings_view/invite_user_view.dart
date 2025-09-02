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

import '../../../common widget/custom text/custom_text_widget.dart';

class InviteUserView extends StatefulWidget {
  const InviteUserView({super.key});

  @override
  _InviteUserViewState createState() => _InviteUserViewState();
}

class _InviteUserViewState extends State<InviteUserView> {
  final GetUserController controller = Get.put(GetUserController());
  final StorageService _storageService = StorageService();
  final TextEditingController searchController = TextEditingController();

  List<String> selectedUserIds = [];
  List<dynamic> _filteredUsers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedUserIds();
    _fetchUsers();
  }

  void _loadSelectedUserIds() {
    List<dynamic>? savedIds = _storageService.read<List>('inviteUserId');
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      appBar: CustomAppBar(title: "Invite Others"),
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
              fillColor: Colors.transparent,
              borderColor: Colors.grey,
              hintText: "Search here...",
              showObscure: false,
              prefixIcon: Icons.search,
              controller: searchController,
              onChanged: _filterUserList,
            ),

            SizedBox(height: 20),

            CustomText(
              text: "Invite your friend if the Event is Private",
              fontSize: 14.sp,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            SizedBox(height: 20.h),

            isLoading
                ? Expanded(child: Center(child: CustomLoader()))
                : Expanded(
              child: _filteredUsers.isEmpty
                  ? Center(
                child: Text(
                  "No users found.",
                  style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black54),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  final isSelected =
                  selectedUserIds.contains(user.id);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.profilePicture != null
                          ? NetworkImage(user.profilePicture!)
                          : NetworkImage(
                          "https://t4.ftcdn.net/jpg/07/03/86/11/360_F_703861114_7YxIPnoH8NfmbyEffOziaXy0EO1NpRHD.jpg"),
                    ),
                    title: CustomText(
                      text: user.fullname ?? "Unknown",
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                    subtitle: CustomText(
                      text: user.email ?? "No email",
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 14,
                      italic: FontStyle.italic,
                      textAlign: TextAlign.start,
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        _toggleUserSelection(user.id!, value!);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                          color: AppColors.btnColor, width: 2),
                      activeColor: AppColors.btnColor,
                    ),
                  );
                },
              ),
            ),

            CustomButtonWidget(
              bgColor: AppColors.btnColor,
              btnText: "Update",
              onTap: () {
                if (selectedUserIds.isEmpty) {
                  CustomToast.showToast(
                      "Please select at least one user to invite",
                      isError: true);
                  return;
                }

                _storageService.write('inviteUserId', selectedUserIds);
                print("✅ Saved inviteUserIds locally: $selectedUserIds");

                CustomToast.showToast("Invited users updated successfully!",
                    isError: false);
              },
              iconWant: false,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
