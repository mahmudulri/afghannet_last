import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/dashboard_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/custom_text.dart';

class FinancialScreen extends StatelessWidget {
  FinancialScreen({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());
  final Mypagecontroller mypagecontroller = Get.find();
  final box = GetStorage();
  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      "dd MMM yyyy",
    ).format(DateTime.now());

    final allData = dashboardController.alldashboardData.value.data!;
    final currency = box.read("currency_code") ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  _buildTopAction(
                    onTap: () => mypagecontroller.goBack(),
                    child: Image.asset(
                      "assets/icons/backicon.png",
                      height: 18,
                      width: 18,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Obx(
                      () => KText(
                        text: languagesController.tr("FINANCIAL_REPORT"),
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: const Color(0xFF26212D),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  _buildTopAction(
                    onTap: () => CustomFullScreenSheet.show(context),
                    child: Center(child: MenuiconWIdget()),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 17),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(.20),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                "assets/icons/wallet.png",
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: languagesController.tr(
                                      "FINANCIAL_REPORT",
                                    ),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(.68),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.14),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                currency,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 15,
                                color: Colors.white.withOpacity(.88),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  languagesController.tr("DATE"),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(.72),
                                  ),
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 16,
                                color: Colors.white.withOpacity(.88),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  languagesController.tr("CURRENCY"),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(.72),
                                  ),
                                ),
                              ),
                              Text(
                                currency,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ───────────────────────────────────────────────────────
                  // FINANCIAL ITEMS
                  // ───────────────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.025),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        BalanceBox(
                          imagelink: "assets/icons/wallet.png",
                          boxname: languagesController.tr("BALANCE"),
                          balance: dashboardController
                              .userBalanceController
                              .balance
                              .toString(),
                          showDivider: true,
                          valueColor: AppColors.primaryColor,
                        ),

                        BalanceBox(
                          imagelink: "assets/icons/sales.png",
                          boxname: languagesController.tr("SALE"),
                          balance: allData.totalSoldAmount.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFF1D9E75),
                        ),

                        BalanceBox(
                          imagelink: "assets/icons/debit.png",
                          boxname: languagesController.tr("DEBIT"),
                          balance: allData.totalSoldAmount.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFFE24B4A),
                        ),

                        BalanceBox(
                          imagelink: "assets/icons/profit.png",
                          boxname: languagesController.tr("PROFIT"),
                          balance: allData.totalRevenue.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFF1D9E75),
                        ),

                        BalanceBox(
                          imagelink: "assets/icons/loan.png",
                          boxname: languagesController.tr("LOAN_BALANCE"),
                          balance: allData.loanBalance.toString(),
                          showDivider: true,
                          valueColor: const Color(0xFFE24B4A),
                        ),

                        BalanceBox(
                          imagelink: "assets/icons/comission.png",
                          boxname: languagesController.tr("COMISSION"),
                          balance: allData.userInfo!.totalearning.toString(),
                          showDivider: false,
                          valueColor: const Color(0xFF7D5FFF),
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

  Widget _buildTopAction({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEDE8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BalanceBox
// ══════════════════════════════════════════════════════════════════════════════

class BalanceBox extends StatelessWidget {
  BalanceBox({
    super.key,
    this.imagelink,
    this.boxname,
    this.balance,
    this.showDivider = true,
    this.valueColor,
  });

  String? imagelink;
  String? boxname;
  String? balance;
  bool showDivider;
  Color? valueColor;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final currency = box.read("currency_code") ?? '';
    final itemColor = valueColor ?? AppColors.primaryColor;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(imagelink.toString(), color: itemColor),
              ),

              const SizedBox(width: 12),

              // Label
              Expanded(
                child: Text(
                  boxname.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6F6876),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '',
                      decimalDigits: 2,
                    ).format(double.tryParse(balance.toString()) ?? 0),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: itemColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currency,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFAAA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 66, right: 8),
            child: Container(height: 1, color: const Color(0xFFF1EDF3)),
          ),
      ],
    );
  }
}
