// file: widgets/custom_full_screen_sheet.dart

import 'dart:io';

import 'package:afghannet/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/screens/helpscreen.dart';
import 'package:afghannet/screens/termscondition.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../pages/homepages.dart';
import '../screens/change_password_screen.dart';
import '../screens/change_pin.dart';
import '../screens/commission_group_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/selling_price_screen.dart';
import '../screens/sign_in_screen.dart';
import 'drawer.dart';

class CustomFullScreenSheet extends StatefulWidget {
  CustomFullScreenSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomFullScreenSheet(),
    );
  }

  @override
  State<CustomFullScreenSheet> createState() => _CustomFullScreenSheetState();
}

class _CustomFullScreenSheetState extends State<CustomFullScreenSheet> {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.find();
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => _version = packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height - 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      child: Obx(
        () => dashboardController.deactiveStatus.value == "Deactivated"
            ? Center(
                child: Text(
                  dashboardController.deactivateMessage.value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Handle ────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // ── Contact Us ────────────────────────────────────────
                    _buildWideItem(
                      color: const Color(0xFFF0FDF4),
                      borderColor: const Color(0xFFBBF7D0),
                      iconBg: const Color(0xFFD1FAE5),
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: const Color(0xFF1D9E75),
                      title: languagesController.tr("CONTACTUS"),
                      subtitle: "WhatsApp support",
                      titleColor: const Color(0xFF1D9E75),
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: ContactDialogBox(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Guide | Language | Profile ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _buildGridItem(
                            color: const Color(0xFFFFF4EF),
                            borderColor: const Color(0xFFFFD5C2),
                            iconBg: const Color(0xFFFFE4D6),
                            assetPath: "assets/icons/drawerguide.png",
                            iconColor: const Color(0xFF8E5B42),
                            label: languagesController.tr("GUIDE"),
                            labelColor: const Color(0xFF8E5B42),
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  Helpscreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGridItem(
                            color: const Color(0xFFF4EBFC),
                            borderColor: const Color(0xFFDDD6FE),
                            iconBg: const Color(0xFFEDE9FE),
                            assetPath: "assets/icons/drawerlanguage.png",
                            iconColor: const Color(0xFF7d5fff),
                            label: languagesController.tr("LANGUAGES"),
                            labelColor: const Color(0xFF7d5fff),
                            onTap: () =>
                                _showLanguageDialog(context, screenWidth),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGridItem(
                            color: const Color(0xFFF0FDF4),
                            borderColor: const Color(0xFFBBF7D0),
                            iconBg: const Color(0xFFD1FAE5),
                            assetPath: "assets/icons/drawerprofile.png",
                            iconColor: const Color(0xFF067D3D),
                            label: languagesController.tr("PROFILE"),
                            labelColor: const Color(0xFF067D3D),
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  ProfileScreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Change PIN | Change Password ──────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _buildHorizontalItem(
                            color: const Color(0xFFEEF2FF),
                            borderColor: const Color(0xFFC7D2FE),
                            iconBg: const Color(0xFFE0E7FF),
                            assetPath: "assets/icons/key.png",
                            iconColor: const Color(0xFF6F76FF),
                            label: languagesController.tr("CHANGE_PIN"),
                            labelColor: const Color(0xFF6F76FF),
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  ChangePinScreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildHorizontalItem(
                            color: const Color(0xFFF5F3FF),
                            borderColor: const Color(0xFFDDD6FE),
                            iconBg: const Color(0xFFEDE9FE),
                            assetPath: "assets/icons/padlock.png",
                            iconColor: const Color(0xFF8e44ad),
                            label: languagesController.tr("CHANGE_PASSWORD"),
                            labelColor: const Color(0xFF8e44ad),
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  ChangePasswordScreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Set Sale Price | Commission Group ─────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _buildHorizontalItem(
                            color: const Color(0xFFFEF2F2),
                            borderColor: const Color(0xFFFECACA),
                            iconBg: const Color(0xFFFEE2E2),
                            assetPath: "assets/icons/faq.png",
                            iconColor: const Color(0xFFc0392b),
                            label: languagesController.tr("SET_SALE_PRICE"),
                            labelColor: const Color(0xFFc0392b),
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  SellingPriceScreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildHorizontalItem(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            borderColor: AppColors.primaryColor.withOpacity(
                              0.2,
                            ),
                            iconBg: AppColors.primaryColor.withOpacity(0.15),
                            assetPath: "assets/icons/discount.png",
                            iconColor: AppColors.primaryColor,
                            label: languagesController.tr("COMMISSION_GROUP"),
                            labelColor: AppColors.primaryColor,
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => mypagecontroller.changePage(
                                  CommissionGroupScreen(),
                                  isMainPage: false,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Logout ────────────────────────────────────────────
                    _buildWideItem(
                      color: const Color(0xFFFEF2F2),
                      borderColor: const Color(0xFFFECACA),
                      iconBg: const Color(0xFFFEE2E2),
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFE24B4A),
                      title: languagesController.tr("LOGOUT"),
                      titleColor: const Color(0xFFE24B4A),
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: LogoutDialogBox(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Version ───────────────────────────────────────────
                    Text(
                      "${languagesController.tr("VERSION")}: ${_version.isEmpty ? '...' : _version}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ── Wide full-width item ────────────────────────────────────────────────────
  Widget _buildWideItem({
    required Color color,
    required Color borderColor,
    required Color iconBg,
    IconData? icon,
    String? assetPath,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Color titleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: icon != null
                    ? Icon(icon, color: iconColor, size: 22)
                    : Image.asset(assetPath!, height: 22, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: titleColor.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: titleColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  // ── 3-col grid item ─────────────────────────────────────────────────────────
  Widget _buildGridItem({
    required Color color,
    required Color borderColor,
    required Color iconBg,
    required String assetPath,
    required Color iconColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(assetPath, color: iconColor),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 2-col horizontal item ───────────────────────────────────────────────────
  Widget _buildHorizontalItem({
    required Color color,
    required Color borderColor,
    required Color iconBg,
    required String assetPath,
    required Color iconColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(assetPath, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Language dialog ─────────────────────────────────────────────────────────
  void _showLanguageDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          languagesController.tr("CHANGE_LANGUAGE"),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          height: 350,
          width: screenWidth,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languagesController.alllanguagedata.length,
            itemBuilder: (context, index) {
              final data = languagesController.alllanguagedata[index];
              return GestureDetector(
                onTap: () {
                  final languageName = data["name"].toString();
                  final matched = languagesController.alllanguagedata
                      .firstWhere(
                        (lang) => lang["name"] == languageName,
                        orElse: () => {"isoCode": "en", "direction": "ltr"},
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
                    default:
                      locale = const Locale("en", "US");
                  }
                  setState(
                    () => EasyLocalization.of(context)!.setLocale(locale),
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data["fullname"].toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ContactDialogBox
// ══════════════════════════════════════════════════════════════════════════════
class ContactDialogBox extends StatelessWidget {
  const ContactDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              FontAwesomeIcons.whatsapp,
              color: Color(0xFF1D9E75),
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "You will be redirected to the WhatsApp page to contact us. Continue?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => whatsapp(),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9E75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LogoutDialogBox
// ══════════════════════════════════════════════════════════════════════════════
class LogoutDialogBox extends StatelessWidget {
  LogoutDialogBox({super.key});

  final signInController = Get.find<SignInController>();
  final Mypagecontroller mypagecontroller = Get.find();
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFE24B4A),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          KText(
            text: languagesController.tr("DO_YOU_WANT_TO_LOG_OUT"),
            color: const Color(0xFF1A1A2E),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    signInController.usernameController.clear();
                    signInController.passwordController.clear();
                    box.remove("userToken");
                    mypagecontroller.changePage(Homepages(), isMainPage: false);
                    Get.to(() => SignInScreen());
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: KText(
                        text: languagesController.tr("YES_IAMGOING_OUT"),
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: KText(
                        text: languagesController.tr("CANCEL"),
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// whatsapp helper (unchanged)
// ══════════════════════════════════════════════════════════════════════════════
whatsapp() async {
  var contact = AppString.phoneNUmber1;
  var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
  var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";
  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    print("not found");
  }
}
