import 'package:afghannet/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/controllers/change_password_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/button_one.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordController = Get.put(
    ChangePasswordController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFBF9FD),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.018),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(languagesController.tr("CURRENT_PASSWORD")),

                        const SizedBox(height: 7),

                        ChangePasswordBox(
                          controller:
                              changePasswordController.currentpassController,
                          icon: Icons.lock_outline_rounded,
                        ),

                        const SizedBox(height: 16),

                        _buildLabel(languagesController.tr("NEW_PASSWORD")),

                        const SizedBox(height: 7),

                        ChangePasswordBox(
                          controller:
                              changePasswordController.newpassController,
                          icon: Icons.lock_reset_rounded,
                        ),

                        const SizedBox(height: 16),

                        _buildLabel(
                          languagesController.tr("CONFIRM_NEW_PASSWORD"),
                        ),

                        const SizedBox(height: 7),

                        ChangePasswordBox(
                          controller:
                              changePasswordController.confirmpassController,
                          icon: Icons.verified_user_outlined,
                        ),

                        const SizedBox(height: 22),

                        Obx(
                          () => DefaultButton1(
                            height: 50,
                            width: screenWidth,
                            buttonName:
                                changePasswordController.isLoading.value ==
                                    false
                                ? languagesController.tr("CHANGE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            onpressed: () {
                              if (changePasswordController
                                      .currentpassController
                                      .text
                                      .isEmpty ||
                                  changePasswordController
                                      .newpassController
                                      .text
                                      .isEmpty ||
                                  changePasswordController
                                      .confirmpassController
                                      .text
                                      .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr(
                                    "FILL_DATA_CORRECTLY",
                                  ),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                changePasswordController.change();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor.withOpacity(.05)),
        ),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                mypagecontroller.goBack();
              },
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 17,
                  color: Color(0xFF4C4652),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: KText(
              text: languagesController.tr("CHANGE_PASSWORD"),
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: const Color(0xFF2E2833),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // mypagecontroller.openDrawer();
              },
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                ),
                child: Center(child: MenuiconWIdget()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return KText(
      text: text,
      color: const Color(0xFF5C5562),
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
  }
}

class ChangePasswordBox extends StatefulWidget {
  const ChangePasswordBox({
    super.key,
    this.hintText,
    this.controller,
    required this.icon,
  });

  final String? hintText;
  final TextEditingController? controller;
  final IconData icon;

  @override
  State<ChangePasswordBox> createState() => _ChangePasswordBoxState();
}

class _ChangePasswordBoxState extends State<ChangePasswordBox> {
  final GetStorage box = GetStorage();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, size: 16, color: AppColors.primaryColor),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFA39CA8),
                  fontSize: 12.5,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF403A46),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEDE8F0)),
              ),
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 16,
                color: const Color(0xFF8C8591),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
