import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/controllers/sub_reseller_password_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../global_controller/font_controller.dart';

class SetPassword extends StatefulWidget {
  SetPassword({super.key, this.subID});

  String? subID;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final SubresellerPassController passwordConttroller = Get.put(
    SubresellerPassController(),
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
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
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
                        Center(
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.08),
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              size: 28,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: Text(
                            languagesController.tr("SET_PASSWORD"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF342E39),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Center(
                          child: Container(
                            width: 42,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildLabel(languagesController.tr("NEW_PASSWORD")),

                        const SizedBox(height: 6),

                        PasswordBox(
                          controller: passwordConttroller.newpassController,
                          hintText: languagesController.tr("NEW_PASSWORD"),
                        ),

                        const SizedBox(height: 14),

                        _buildLabel(languagesController.tr("CONFIRM_PASSWORD")),

                        const SizedBox(height: 6),

                        PasswordBox(
                          controller: passwordConttroller.confirmpassController,
                          hintText: languagesController.tr("CONFIRM_PASSWORD"),
                        ),

                        const SizedBox(height: 20),

                        Obx(
                          () => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: passwordConttroller.isLoading.value
                                  ? null
                                  : () {
                                      if (passwordConttroller
                                              .newpassController
                                              .text
                                              .isEmpty ||
                                          passwordConttroller
                                              .confirmpassController
                                              .text
                                              .isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Fill the data",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        passwordConttroller.change(
                                          widget.subID.toString(),
                                        );
                                      }
                                    },
                              borderRadius: BorderRadius.circular(15),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: passwordConttroller.isLoading.value
                                      ? const Color(0xFFD8D3DB)
                                      : AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: passwordConttroller.isLoading.value
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(.16),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!passwordConttroller
                                        .isLoading
                                        .value) ...[
                                      const Icon(
                                        Icons.verified_user_outlined,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 7),
                                    ],
                                    Text(
                                      passwordConttroller.isLoading.value ==
                                              false
                                          ? languagesController.tr(
                                              "CONFIRMATION",
                                            )
                                          : languagesController.tr(
                                              "PLEASE_WAIT",
                                            ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
              text: languagesController.tr("SET_PASSWORD"),
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF615A67),
      ),
    );
  }
}

class PasswordBox extends StatefulWidget {
  PasswordBox({super.key, this.hintText, this.controller});

  String? hintText;
  TextEditingController? controller;

  @override
  State<PasswordBox> createState() => _PasswordBoxState();
}

class _PasswordBoxState extends State<PasswordBox> {
  bool _obscure = true;

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11),
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
              color: AppColors.primaryColor.withOpacity(.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscure,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF403A46),
                fontFamily: fontFamily,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(
                  fontSize: 12.5,
                  color: const Color(0xFFA39CA8),
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    key: ValueKey(_obscure),
                    size: 18,
                    color: const Color(0xFF9E97A3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
