import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/bottomsheet.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/routes/routes.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<bool> showExitPopup() async {
    if (mypagecontroller.pageStack.length > 1) {
      mypagecontroller.goBack();
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  languagesController.tr("EXIT_APP"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff221F2D),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            languagesController.tr("DO_YOU_WANT_TO_EXIT_APP"),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff7D7787),
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          actions: [
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff6B6574),
                  backgroundColor: const Color(0xffF5F3F7),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  languagesController.tr("NO"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  languagesController.tr("YES"),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

  final String longtext =
      "Send money, buy mobile credit and internet packages, pay bills, "
      "and manage all your transactions — fast, secure, and always at "
      "your fingertips!";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffFBF9FD),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: screenHeight - 180),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          /// Hero section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(22, 30, 22, 28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xffEFE9F3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xffA55EEA,
                                  ).withOpacity(.07),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                /// Logo presentation
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primaryColor.withOpacity(
                                              .13,
                                            ),
                                            AppColors.primaryColor.withOpacity(
                                              .04,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 80,
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(26),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withOpacity(.13),
                                            blurRadius: 22,
                                            offset: const Offset(0, 9),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        "assets/icons/logo.png",
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 28),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    languagesController.tr(
                                      "EVERYTHING_IN_ONE_PLACE",
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  languagesController.tr("SLOGAN_1"),

                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 1.22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -.5,
                                    color: Color(0xff211D28),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Text(
                                    languagesController.tr("SLOGAN_2"),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.65,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff8C8694),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                /// Features
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFeatureItem(
                                        icon: Icons.bolt_rounded,
                                        title: languagesController.tr("FAST"),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildFeatureItem(
                                        icon: Icons.verified_user_rounded,
                                        title: languagesController.tr("SECURE"),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildFeatureItem(
                                        icon: Icons.access_time_filled_rounded,
                                        title: languagesController.tr("24_/_7"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// Small service preview
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.055),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                _MiniService(
                                  icon: Icons.phone_android_rounded,
                                  title: languagesController.tr("RECHARGE"),
                                ),
                                _MiniDivider(),
                                _MiniService(
                                  icon: Icons.language_rounded,
                                  title: languagesController.tr("INTERNET"),
                                ),

                                _MiniDivider(),
                                _MiniService(
                                  icon: Icons.payments_rounded,
                                  title: languagesController.tr("TRANSFER"),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Bottom action section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.045),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /// Register
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                whatsapp();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Ink(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(
                                        .24,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add_alt_1_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("REGISTER"),
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Login
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.offAllNamed(signinscreen);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Ink(
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withOpacity(
                                      .16,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.login_rounded,
                                        size: 19,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("LOGIN"),
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xffFAF8FC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffF0EBF3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: AppColors.primaryColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xff655F6D),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniService extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MiniService({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: AppColors.primaryColor),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Color(0xff766F7E),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniDivider extends StatelessWidget {
  const _MiniDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 26,
      color: AppColors.primaryColor.withOpacity(.10),
    );
  }
}

/// Existing helper
class languageBox extends StatelessWidget {
  const languageBox({super.key, this.lanName, this.onpressed});

  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Existing helper
class SinInbutton extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  const SinInbutton({
    super.key,
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: KText(
            text: buttonName.toString(),
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
