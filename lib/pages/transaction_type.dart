import 'package:afghannet/widgets/button_one.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/transaction_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/bottomsheet.dart';
import 'package:afghannet/widgets/drawer.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/drawer_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/hawala_rates_screen.dart';
import '../screens/receipts_screen.dart';
import '../screens/loan_screen.dart';
import '../screens/welcomescreen.dart';
import '../screens/withdraw_screen.dart';
import '../widgets/button.dart';
import '../widgets/menuiconwidget.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final Mypagecontroller mypagecontroller = Get.find();

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());
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
  }

  bool get _isDeactivated {
    return dashboardController.deactiveStatus.value.trim().toLowerCase() ==
        "deactivated";
  }

  void _showDeactivatedMessage() {
    Get.snackbar(
      dashboardController.deactiveStatus.toString(),
      dashboardController.deactivateMessage.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 1),
      icon: const Icon(Icons.block, color: Colors.white),
    );
  }

  void _openPage(Widget page) {
    if (_isDeactivated) {
      _showDeactivatedMessage();
      return;
    }

    mypagecontroller.changePage(page, isMainPage: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: _buildFlatMenuPanel(),
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
                text: languagesController.tr("TRANSACTIONS_TYPE"),
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: const Color(0xFF28232E),
              ),
            ),
          ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                CustomFullScreenSheet.show(context);
              },
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

  Widget _buildFlatMenuPanel() {
    return Container(
      width: double.infinity,
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
          _buildMenuRow(
            buttonName: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
            imagelink: "assets/icons/wallet.png",
            accentColor: const Color(0xff04B75D),
            onTap: () => _openPage(ReceiptsScreen()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("REQUES_LOAN_BALANCE"),
            imagelink: "assets/icons/transactionsicon.png",
            accentColor: const Color(0xff3498db),
            onTap: () => _openPage(RequestLoanScreen()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("HAWALA"),
            imagelink: "assets/icons/exchange.png",
            accentColor: const Color(0xffFE8F2D),
            onTap: () => _openPage(HawalaListScreen()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("HAWALA_RATES"),
            imagelink: "assets/icons/exchange-rate.png",
            accentColor: const Color(0xff4B7AFC),
            onTap: () => _openPage(HawalaCurrencyScreen()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("BALANCE_TRANSACTIONS"),
            imagelink: "assets/icons/transactionsicon.png",
            accentColor: const Color(0xffDE4B5E),
            onTap: () => _openPage(Transactions()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("TRANSFER_COMISSION_TO_BALANCE"),
            imagelink: "assets/icons/transactionsicon.png",
            accentColor: const Color(0xff9B59B6),
            onTap: () => _openPage(CommissionTransferScreen()),
          ),

          _divider(),

          _buildMenuRow(
            buttonName: languagesController.tr("WITHDRAW"),
            imagelink: "assets/icons/wallet.png",
            accentColor: const Color(0xff04B75D),
            onTap: () => _openPage(WithdrawScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required String buttonName,
    required String imagelink,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  imagelink,
                  color: accentColor,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  buttonName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B4551),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                Icons.chevron_right_rounded,
                size: 23,
                color: accentColor.withOpacity(.72),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 71, right: 14),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFF1EDF3)),
    );
  }
}
