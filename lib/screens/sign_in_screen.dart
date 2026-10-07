import 'dart:io';

import 'package:afghannet/widgets/socialbuttonbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/utils/strings.dart';
import 'package:afghannet/widgets/authtextfield.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/languages_controller.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final box = GetStorage();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final signInController = Get.find<SignInController>();

  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<bool> showExitPopup() async {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                children: [
                  /// ===========================
                  /// TOP HERO SECTION
                  /// ===========================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 22,
                      right: 22,
                      bottom: 54,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(42),
                        bottomRight: Radius.circular(42),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Image.asset(
                                "assets/icons/logo.png",
                                fit: BoxFit.contain,
                              ),
                            ),

                            GestureDetector(
                              onTap: () => _showLanguageDialog(context),
                              child: Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.14),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.22),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.language_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 7),
                                    Obx(
                                      () => KText(
                                        text: languagesController
                                            .selectedlan
                                            .value,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: KText(
                            text: languagesController.tr("LOGIN"),
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: KText(
                            text: languagesController.tr(
                              "PLEASE_ENTER_YOUR_INFORMATION",
                            ),
                            color: Colors.white.withOpacity(.75),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ===========================
                  /// FORM SHEET
                  /// ===========================
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.07),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Username
                            _buildFieldLabel(
                              languagesController.tr("USERNAME"),
                            ),

                            const SizedBox(height: 8),

                            _buildInputWrapper(
                              child: Authtextfield(
                                hinttext: languagesController.tr("USERNAME"),
                                controller: signInController.usernameController,
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// Password
                            _buildFieldLabel(
                              languagesController.tr("PASSWORD"),
                            ),

                            const SizedBox(height: 8),

                            _buildInputWrapper(
                              child: Authtextfield(
                                hinttext: languagesController.tr("PASSWORD"),
                                controller: signInController.passwordController,
                              ),
                            ),

                            const SizedBox(height: 13),

                            /// Forgot password
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              runSpacing: 4,
                              children: [
                                KText(
                                  text: languagesController.tr(
                                    "FORGOT_YOUR_PASSWORD",
                                  ),
                                  color: AppColors.fontColor,
                                  fontSize: 12,
                                ),
                                GestureDetector(
                                  onTap: () => whatsapp(),
                                  child: KText(
                                    text: languagesController.tr(
                                      "PASSWORD_RECOVERY",
                                    ),
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            /// Login button
                            Obx(
                              () => DefaultButton1(
                                buttonName:
                                    signInController.isLoading.value == false
                                    ? languagesController.tr("LOGIN")
                                    : languagesController.tr("PLEASE_WAIT"),
                                height: 54,
                                onpressed: () async {
                                  if (signInController.usernameController.text
                                          .trim()
                                          .isEmpty ||
                                      signInController.passwordController.text
                                          .trim()
                                          .isEmpty) {
                                    Get.snackbar(
                                      "Oops!",
                                      "Fill the text fields",
                                    );
                                    return;
                                  }

                                  await signInController.signIn();
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// Register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: KText(
                                    text: languagesController.tr(
                                      "NOT_HAVE_AN_ACCOUNT",
                                    ),
                                    color: AppColors.fontColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => SignUpScreen());
                                  },
                                  child: KText(
                                    text: languagesController.tr(
                                      "REGISTER_NOW",
                                    ),
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                            /// Divider
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xffEEEAF2),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: KText(
                                    text: languagesController.tr("FIND_US_ON"),
                                    color: AppColors.fontColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xffEEEAF2),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            /// Social
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSocialItem(
                                    child: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 21,
                                      color: AppColors.primaryColor,
                                    ),
                                    onTap: () => whatsapp(),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: _buildSocialItem(
                                    child: Image.asset(
                                      "assets/icons/social-media.png",
                                      height: 23,
                                    ),
                                    onTap: () => showSocialPopup(context),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: _buildSocialItem(
                                    child: const Icon(
                                      FontAwesomeIcons.phone,
                                      size: 18,
                                      color: AppColors.primaryColor,
                                    ),
                                    onTap: () =>
                                        _makePhoneCall(AppString.phoneNUmber1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: .6,
        color: Color(0xff756F7B),
      ),
    );
  }

  Widget _buildInputWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFBF9FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffEDE7F1)),
      ),
      child: child,
    );
  }

  Widget _buildSocialItem({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryColor.withOpacity(.10)),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .65,
          ),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffDDD8E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      languagesController.tr("LANGUAGES"),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff26212B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(bottomSheetContext),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F3F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: languagesController.alllanguagedata.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = languagesController.alllanguagedata[index];

                    final languageName = data["name"].toString();

                    final isSelected =
                        languagesController.selectedlan.value == languageName;

                    return GestureDetector(
                      onTap: () {
                        final matched = languagesController.alllanguagedata
                            .firstWhere(
                              (lang) => lang["name"] == languageName,
                              orElse: () => {
                                "isoCode": "en",
                                "direction": "ltr",
                              },
                            );

                        final languageISO = matched["isoCode"]!;

                        final languageDirection = matched["direction"]!;

                        languagesController.changeLanguage(languageName);

                        box.write("language", languageName);

                        box.write("direction", languageDirection);

                        Locale locale;

                        switch (languageISO) {
                          case "fa":
                            locale = const Locale("fa", "IR");
                            break;

                          case "ar":
                            locale = const Locale("ar", "AE");
                            break;

                          case "ps":
                            locale = const Locale("ps", "AF");
                            break;

                          case "tr":
                            locale = const Locale("tr", "TR");
                            break;

                          case "bn":
                            locale = const Locale("bn", "BD");
                            break;

                          case "en":
                          default:
                            locale = const Locale("en", "US");
                        }

                        setState(() {
                          EasyLocalization.of(context)!.setLocale(locale);
                        });

                        Navigator.pop(bottomSheetContext);

                        debugPrint(
                          "🌐 Language: $languageName ($languageISO), dir: $languageDirection",
                        );
                      },
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(.09)
                              : const Color(0xffFAF9FB),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(.28)
                                : const Color(0xffEEE9F1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : const Color(0xffD6D0DA),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                data["fullname"].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : const Color(0xff514B57),
                                ),
                              ),
                            ),

                            if (isSelected)
                              const Icon(
                                Icons.check_rounded,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
