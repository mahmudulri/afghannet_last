import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/change_status_controller.dart';
import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/delete_sub_resellercontroller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/controllers/subreseller_details_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/screens/add_new_user.dart';
import 'package:afghannet/screens/change_balance.dart';
import 'package:afghannet/screens/set_password.dart';
import 'package:afghannet/utils/colors.dart';

import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../global_controller/font_controller.dart';
import '../screens/set_subreseller_pin.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/custom_text.dart';
import '../widgets/menuiconwidget.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

final Mypagecontroller mypagecontroller = Get.find();
final subresellercontroller = Get.find<SubresellerController>();
LanguagesController languagesController = Get.put(LanguagesController());
final detailsController = Get.find<SubresellerDetailsController>();

final DeleteSubResellerController deleteSubResellerController = Get.put(
  DeleteSubResellerController(),
);

final ChangeStatusController changeStatusController = Get.put(
  ChangeStatusController(),
);

final commissionlistController = Get.find<CommissionGroupController>();

SetCommissionGroupController controller = Get.put(
  SetCommissionGroupController(),
);

class _NetworkState extends State<Network> {
  final Set<int> expandedIndices = {};

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

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

    subresellercontroller.fetchSubReseller();
    commissionlistController.fetchGrouplist();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => dashboardController.deactiveStatus.value != "Deactivated"
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              backgroundColor: const Color(0xFFFBF9FD),
              body: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(screenWidth),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: Column(
                          children: [
                            _buildTopActions(screenWidth),
                            const SizedBox(height: 12),
                            _buildUsersSection(screenWidth, screenHeight),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _buildDeactivatedScreen(screenWidth),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor.withOpacity(.05)),
        ),
      ),
      child: Row(
        children: [
          Obx(() {
            final profileImageUrl = dashboardController
                .alldashboardData
                .value
                .data
                ?.userInfo
                ?.profileImageUrl;

            return Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.09),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(.08),
                ),
                image:
                    (!dashboardController.isLoading.value &&
                        profileImageUrl != null &&
                        profileImageUrl.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(profileImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child:
                  dashboardController.isLoading.value ||
                      profileImageUrl == null ||
                      profileImageUrl.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    )
                  : null,
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => KText(
                text: languagesController.tr("NETWORK"),
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: const Color(0xFF28232E),
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

  Widget _buildTopActions(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                mypagecontroller.changePage(AddNewUser(), isMainPage: false),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 10),
                  KText(
                    text: languagesController.tr("ADD_USER"),
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _searchField(
                  screenWidth: screenWidth,
                  icon: Icons.phone_android_rounded,
                  hint: languagesController.tr("SEARCH_BY_PHOENUMBER"),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _searchField(
                  screenWidth: screenWidth,
                  icon: Icons.person_search_rounded,
                  hint: languagesController.tr("SEARCH_BY_NAME"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField({
    required double screenWidth,
    required IconData icon,
    required String hint,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 17),
          const SizedBox(width: 7),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: const Color(0xFF5C5562),
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(
                  color: const Color(0xFFA49DA9),
                  fontSize: screenWidth * 0.030,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersSection(double screenWidth, double screenHeight) {
    return Obx(() {
      if (subresellercontroller.isLoading.value) {
        return SizedBox(
          height: 320,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      final resellers =
          subresellercontroller.allsubresellerData.value.data!.resellers;

      return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 5),
        itemCount: resellers.length,
        itemBuilder: (context, index) {
          final data = resellers[index];
          final isExpanded = expandedIndices.contains(index);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isExpanded
                    ? AppColors.primaryColor.withOpacity(.22)
                    : const Color(0xFFEDE8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.02),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      expandedIndices.add(index);
                      detailsController.fetchSubResellerDetails(
                        data.id.toString(),
                      );
                    } else {
                      expandedIndices.remove(index);
                    }
                  });
                },
                tilePadding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
                childrenPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    data.profileImageUrl != null
                        ? Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                image: NetworkImage(
                                  data.profileImageUrl.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.primaryColor,
                              size: 22,
                            ),
                          ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: data.contactName.toString(),
                            color: const Color(0xFF3D3743),
                            fontWeight: FontWeight.w700,
                            fontSize: screenHeight * 0.017,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            data.phone.toString(),
                            style: TextStyle(
                              color: const Color(0xFF9B94A1),
                              fontSize: screenHeight * 0.014,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: data.status.toString() == "1"
                            ? const Color(0xFFEAF7F1)
                            : const Color(0xFFFFECEC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        data.status.toString() == "1"
                            ? Icons.check_circle_rounded
                            : Icons.pause_circle_rounded,
                        size: 15,
                        color: data.status.toString() == "1"
                            ? const Color(0xFF1D9E75)
                            : const Color(0xFFE24B4A),
                      ),
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    _showActionsDialog(
                      context,
                      data,
                      screenWidth,
                      screenHeight,
                    );
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFAF8FC),
                      border: Border(top: BorderSide(color: Color(0xFFF0ECF2))),
                    ),
                    child: Obx(
                      () => detailsController.isLoading.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                  strokeWidth: 2.4,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TODAY_ORDER",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .todayOrders
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: const Color(0xFF514A57),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TOTAL_ORDER",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .totalOrders
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: const Color(0xFF514A57),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TODAY_SALE",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .todaySale
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: const Color(0xFF1D9E75),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TOTAL_SALE",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .totalSale
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: const Color(0xFF1D9E75),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TODAY_PROFIT",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .todayProfit
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _statBox(
                                        label: languagesController.tr(
                                          "TOTAL_PROFIT",
                                        ),
                                        value: detailsController
                                            .allsubresellerDetailsData
                                            .value
                                            .data!
                                            .reseller!
                                            .totalProfit
                                            .toString(),
                                        currency: box.read("currency_code"),
                                        valueColor: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.14),
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_wallet_rounded,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: KText(
                                          text: languagesController.tr(
                                            "ACCOUNT_BALANCE",
                                          ),
                                          fontSize: screenHeight * 0.015,
                                          color: Colors.white.withOpacity(.78),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: detailsController
                                                  .allsubresellerDetailsData
                                                  .value
                                                  .data!
                                                  .reseller!
                                                  .balance
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "  ${box.read("currency_code")}",
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white.withOpacity(
                                                  .62,
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
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _statBox({
    required String label,
    required String value,
    required String currency,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFF0ECF2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 8.5,
              height: 1.2,
              color: Color(0xFFA29BA7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            currency,
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFFA29BA7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showActionsDialog(
    BuildContext context,
    dynamic data,
    double screenWidth,
    double screenHeight,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuAction(
                  assetPath: "assets/icons/usdicon.png",
                  label: languagesController.tr("CHANGE_BALANCE"),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    mypagecontroller.changePage(
                      ChangeBalance(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                  screenHeight: screenHeight,
                ),
                _divider(),
                _menuAction(
                  assetPath: "assets/icons/padlock.png",
                  label: languagesController.tr("SET_PASSWORD"),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    mypagecontroller.changePage(
                      SetPassword(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                  screenHeight: screenHeight,
                ),
                _divider(),
                _menuAction(
                  assetPath: "assets/icons/discount.png",
                  label: languagesController.tr("SET_COMMISSION_GROUP"),
                  iconColor: const Color(0xFF1D9E75),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _showCommissionSheet(context, data);
                  },
                  screenHeight: screenHeight,
                ),
                _divider(),
                _menuAction(
                  assetPath: "assets/icons/key.png",
                  label: languagesController.tr("SET_PIN"),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    mypagecontroller.changePage(
                      SetSubresellerPin(subID: data.id.toString()),
                      isMainPage: false,
                    );
                  },
                  screenHeight: screenHeight,
                ),
                _divider(),
                _menuAction(
                  assetPath: data.status.toString() == "1"
                      ? "assets/icons/pause.png"
                      : "assets/icons/active.png",
                  label: data.status.toString() == "1"
                      ? languagesController.tr("DEACTIVE")
                      : languagesController.tr("ACTIVE"),
                  onTap: () {
                    changeStatusController.channgestatus(data.id.toString());
                    Navigator.pop(dialogContext);
                  },
                  screenHeight: screenHeight,
                ),
                _divider(),
                _menuAction(
                  assetPath: "assets/icons/delete.png",
                  label: languagesController.tr("DELETE"),
                  labelColor: const Color(0xFFE24B4A),
                  iconColor: const Color(0xFFE24B4A),
                  onTap: () {
                    deleteSubResellerController.deletesub(data.id.toString());
                    Navigator.pop(dialogContext);
                  },
                  screenHeight: screenHeight,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    height: 44,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4F9),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: KText(
                      text: languagesController.tr("CLOSE"),
                      color: const Color(0xFF6E6774),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCommissionSheet(BuildContext context, dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .65,
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCD6E0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Obx(() {
                  if (commissionlistController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  final groups =
                      commissionlistController
                          .allgrouplist
                          .value
                          .data
                          ?.groups ??
                      [];

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final isSelected =
                          data.subResellerCommissionGroupId.toString() ==
                          group.id.toString();

                      return GestureDetector(
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          await controller.setgroup(
                            data.id.toString(),
                            group.id.toString(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(.07)
                                : const Color(0xFFFAF8FC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(.25)
                                  : const Color(0xFFEDE8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.groupName ?? '',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF403A46),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF9A93A0),
                                      ),
                                    ),
                                  ],
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
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuAction({
    required String assetPath,
    required String label,
    required VoidCallback onTap,
    required double screenHeight,
    Color? iconColor,
    Color? labelColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3F8),
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(assetPath, color: iconColor),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: KText(
                  text: label,
                  color: labelColor ?? const Color(0xFF5C5562),
                  fontSize: screenHeight * 0.016,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFFB4ADB9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 52),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFF1EDF3)),
    );
  }

  Widget _buildDeactivatedScreen(double screenWidth) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFFEDE8F0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.block_rounded,
                      size: 28,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dashboardController.deactiveStatus.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF302A35),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dashboardController.deactivateMessage.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF817A87),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            contentPadding: EdgeInsets.zero,
                            content: ContactDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 46,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/whatsapp.png",
                            height: 22,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 9),
                          KText(
                            text: languagesController.tr("CONTACTUS"),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: LogoutDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.07),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        languagesController.tr("LOGOUT"),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
