import 'dart:io';

import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/sign_in_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/pages/homepages.dart';
import 'package:afghannet/screens/change_password_screen.dart';
import 'package:afghannet/screens/change_pin.dart';
import 'package:afghannet/screens/commission_group_screen.dart';
import 'package:afghannet/screens/helpscreen.dart';
import 'package:afghannet/screens/profile_screen.dart';
import 'package:afghannet/screens/selling_price_screen.dart';
import 'package:afghannet/screens/sign_in_screen.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/utils/strings.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/fcm_device_token_controller.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final SignInController signInController = Get.find<SignInController>();

  final GetStorage box = GetStorage();

  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .86,
      backgroundColor: const Color(0xFFFBF9FD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Obx(() {
        if (dashboardController.deactiveStatus.value == "Deactivated") {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                dashboardController.deactivateMessage.value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4D4654),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            _buildProfileHeader(context),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                children: [
                  _buildMenuSurface(
                    children: [
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.whatsapp,
                        title: languagesController.tr("CONTACTUS"),
                        iconColor: const Color(0xFF1D9E75),
                        iconBackground: const Color(0xFFEAF9F1),
                        onTap: () async {
                          _showContactDialog(context);
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/drawerguide.png",
                        title: languagesController.tr("GUIDE"),
                        iconColor: const Color(0xFFEE8D54),
                        iconBackground: const Color(0xFFFFF1E8),
                        onTap: () {
                          _openPage(context, Helpscreen());
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/drawerlanguage.png",
                        title: languagesController.tr("LANGUAGES"),
                        iconColor: AppColors.primaryColor,
                        iconBackground: AppColors.primaryColor.withOpacity(.10),
                        trailing: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.08),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              languagesController.selectedlan.value,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          _showLanguageSheet(context);
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/drawerprofile.png",
                        title: languagesController.tr("PROFILE"),
                        iconColor: const Color(0xFF278A64),
                        iconBackground: const Color(0xFFEAF7F1),
                        onTap: () {
                          _openPage(context, ProfileScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildMenuSurface(
                    children: [
                      _buildDrawerItem(
                        assetPath: "assets/icons/key.png",
                        title: languagesController.tr("CHANGE_PIN"),
                        iconColor: const Color(0xFF6B73F1),
                        iconBackground: const Color(0xFFEEF0FF),
                        onTap: () {
                          _openPage(context, ChangePinScreen());
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/padlock.png",
                        title: languagesController.tr("CHANGE_PASSWORD"),
                        iconColor: const Color(0xFF8B59B0),
                        iconBackground: const Color(0xFFF5ECFA),
                        onTap: () {
                          _openPage(context, ChangePasswordScreen());
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/faq.png",
                        title: languagesController.tr("SET_SALE_PRICE"),
                        iconColor: const Color(0xFFE25454),
                        iconBackground: const Color(0xFFFFEEEE),
                        onTap: () {
                          _openPage(context, SellingPriceScreen());
                        },
                      ),
                      _divider(),
                      _buildDrawerItem(
                        assetPath: "assets/icons/discount.png",
                        title: languagesController.tr("COMMISSION_GROUP"),
                        iconColor: AppColors.primaryColor,
                        iconBackground: AppColors.primaryColor.withOpacity(.10),
                        onTap: () {
                          _openPage(context, CommissionGroupScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildMenuSurface(
                    children: [
                      _buildDrawerItem(
                        icon: Icons.logout_rounded,
                        title: languagesController.tr("LOGOUT"),
                        iconColor: const Color(0xFFE24B4A),
                        iconBackground: const Color(0xFFFFECEC),
                        titleColor: const Color(0xFFE24B4A),
                        arrowColor: const Color(0xFFE24B4A),
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      "${languagesController.tr("VERSION")}: "
                      "${_version.isEmpty ? '...' : _version}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9B94A1),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(28)),
      ),
      child: Obx(() {
        final userInfo =
            dashboardController.alldashboardData.value.data?.userInfo;

        final profileImageUrl = userInfo?.profileImageUrl;

        final resellerName = userInfo?.resellerName?.toString() ?? '';

        final resellerGroup =
            dashboardController.alldashboardData.value.data?.resellerGroup
                ?.toString() ??
            '';

        return Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.18),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: Colors.white.withOpacity(.20)),
                image: profileImageUrl != null && profileImageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: profileImageUrl == null || profileImageUrl.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 29,
                    )
                  : null,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KText(
                    text: resellerName,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                  if (resellerGroup.isNotEmpty &&
                      resellerGroup.toLowerCase() != "null") ...[
                    const SizedBox(height: 4),
                    Text(
                      resellerGroup,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.72),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMenuSurface({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.018),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDrawerItem({
    IconData? icon,
    String? assetPath,
    required String title,
    required Color iconColor,
    required Color iconBackground,
    Color? titleColor,
    Color? arrowColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: EdgeInsets.all(assetPath != null ? 9 : 0),
                child: icon != null
                    ? Icon(icon, size: 19, color: iconColor)
                    : Image.asset(
                        assetPath!,
                        color: iconColor,
                        fit: BoxFit.contain,
                      ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? const Color(0xFF514A57),
                  ),
                ),
              ),

              if (trailing != null) ...[trailing, const SizedBox(width: 7)],

              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: arrowColor ?? const Color(0xFFB5AEBB),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 65, right: 12),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFF1EDF3)),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 100), () {
      mypagecontroller.changePage(page, isMainPage: false);
    });
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .68,
          ),
          padding: const EdgeInsets.fromLTRB(18, 11, 18, 22),
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
                  color: const Color(0xFFDCD6E0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 17),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      languagesController.tr("CHANGE_LANGUAGE"),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF302A35),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F3F8),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 19,
                        color: Color(0xFF706977),
                      ),
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

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
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
                            default:
                              locale = const Locale("en", "US");
                          }

                          await EasyLocalization.of(context)!.setLocale(locale);

                          if (mounted) {
                            setState(() {});
                          }

                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(.08)
                                : const Color(0xFFFAF9FB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(.28)
                                  : const Color(0xFFEEE9F1),
                            ),
                          ),
                          child: Row(
                            children: [
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
                                        : const Color(0xFF514B57),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                            ],
                          ),
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

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Color(0xFF1D9E75),
                    size: 29,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(dialogContext);
                          await _openWhatsApp();
                        },
                        child: Container(
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D9E75),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            languagesController.tr("YES"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3F7),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: const TextStyle(
                              color: Color(0xFF6E6774),
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
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFE24B4A),
                    size: 28,
                  ),
                ),

                const SizedBox(height: 15),

                KText(
                  text: languagesController.tr("DO_YOU_WANT_TO_LOG_OUT"),
                  color: const Color(0xFF302A35),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          signInController.usernameController.clear();

                          signInController.passwordController.clear();

                          box.remove("userToken");

                          final FcmDeviceTokenController fcmController =
                              Get.find<FcmDeviceTokenController>();

                          final bool tokenDisabled = await fcmController
                              .disableTokenBeforeLogout();

                          Navigator.pop(dialogContext);

                          mypagecontroller.changePage(
                            Homepages(),
                            isMainPage: false,
                          );

                          Get.to(() => const SignInScreen());
                        },
                        child: Container(
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE24B4A),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: KText(
                            text: languagesController.tr("YES_IAMGOING_OUT"),
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3F7),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: KText(
                            text: languagesController.tr("CANCEL"),
                            color: const Color(0xFF706977),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openWhatsApp() async {
    final contact = AppString.phoneNUmber1;

    final androidUrl =
        "whatsapp://send?phone=$contact&text=Hi, I need some help";

    final iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

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
}
