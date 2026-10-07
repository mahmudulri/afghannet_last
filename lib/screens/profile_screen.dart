import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final GetStorage box = GetStorage();

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
    final userInfo = dashboardController.alldashboardData.value.data!.userInfo!;

    final allData = dashboardController.alldashboardData.value.data!;

    final currency = box.read("currency_code") ?? '';

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildProfileHero(userInfo: userInfo),

                  const SizedBox(height: 12),

                  _buildSectionCard(
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline_rounded,
                        label: languagesController.tr("FULL_NAME"),
                        value: userInfo.resellerName.toString(),
                        iconBackground: AppColors.primaryColor.withOpacity(.08),
                        iconColor: AppColors.primaryColor,
                        showDivider: true,
                      ),
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        label: languagesController.tr("EMAIL"),
                        value: userInfo.email.toString(),
                        iconBackground: const Color(0xFFF1F6FC),
                        iconColor: const Color(0xFF4B7FAF),
                        showDivider: true,
                      ),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        label: languagesController.tr("PHONENUMBER"),
                        value: userInfo.phone.toString(),
                        iconBackground: const Color(0xFFF1F8F4),
                        iconColor: const Color(0xFF2B8B6F),
                        showDivider: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildFinancialTile(
                          icon: Icons.account_balance_wallet_outlined,
                          label: languagesController.tr("BALANCE"),
                          value: "${userInfo.balance} $currency",
                          iconColor: AppColors.primaryColor,
                          background: const Color(0xFFF7F1FC),
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: _buildFinancialTile(
                          icon: Icons.credit_card_outlined,
                          label: languagesController.tr("LOAN_BALANCE"),
                          value: "${userInfo.loanBalance} $currency",
                          iconColor: const Color(0xFFE24B4A),
                          background: const Color(0xFFFFF2F2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Expanded(
                        child: _buildFinancialTile(
                          icon: Icons.trending_up_rounded,
                          label: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                          value: "${allData.totalSoldAmount} $currency",
                          iconColor: const Color(0xFF1D9E75),
                          background: const Color(0xFFEEF9F4),
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: _buildFinancialTile(
                          icon: Icons.payments_outlined,
                          label: languagesController.tr("TOTAL_REVENUE"),
                          value: "${allData.totalRevenue} $currency",
                          iconColor: const Color(0xFF4B7FAF),
                          background: const Color(0xFFF1F6FC),
                        ),
                      ),
                    ],
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
            child: Text(
              languagesController.tr("PROFILE"),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xFF2E2833),
              ),
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

  Widget _buildProfileHero({required dynamic userInfo}) {
    final bool hasProfileImage =
        userInfo.profileImageUrl != null &&
        userInfo.profileImageUrl.toString().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(.11),
            const Color(0xFFF7F1FC),
            Colors.white,
          ],
        ),
        border: Border.all(color: AppColors.primaryColor.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.018),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 78,
            height: 78,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(.20),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: hasProfileImage
                  ? Image.network(
                      userInfo.profileImageUrl.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.resellerName.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF302A35),
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.82),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEDE8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        size: 13,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          userInfo.phone.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF746D7A),
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
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primaryColor.withOpacity(.08),
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.primaryColor,
        size: 38,
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.014),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBackground,
    required Color iconColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: iconColor),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A8390),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Flexible(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D3743),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1EDF3),
            indent: 12,
            endIndent: 12,
          ),
      ],
    );
  }

  Widget _buildFinancialTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color background,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: iconColor.withOpacity(.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),

          const SizedBox(height: 9),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B8490),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
