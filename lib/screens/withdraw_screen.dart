import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/withdrawlist_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'create_withdraw_screen.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  final WithdrawlistController withdrawlistController = Get.put(
    WithdrawlistController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();

    withdrawlistController.fetchlist();

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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
      case 'completed':
        return const Color(0xFF1D9E75);

      case 'pending':
        return const Color(0xFFE6A700);

      case 'rejected':
      case 'cancelled':
        return const Color(0xFFE24B4A);

      default:
        return const Color(0xFF8E8793);
    }
  }

  Color _getStatusBg(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
      case 'completed':
        return const Color(0xFFEEF9F4);

      case 'pending':
        return const Color(0xFFFFF8E8);

      case 'rejected':
      case 'cancelled':
        return const Color(0xFFFFF2F2);

      default:
        return const Color(0xFFF5F2F7);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
      case 'completed':
        return Icons.check_circle_outline_rounded;

      case 'pending':
        return Icons.schedule_rounded;

      case 'rejected':
      case 'cancelled':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            _buildCreateButton(),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                if (withdrawlistController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.3,
                    ),
                  );
                }

                final requests = withdrawlistController
                    .allwithdrawlist
                    .value
                    .data
                    ?.withdrawRequests;

                if (requests == null || requests.isEmpty) {
                  return _buildEmptyState(fontFamily);
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 2, 14, 18),
                  itemCount: requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final request = requests[index];

                    return _buildWithdrawCard(request, fontFamily);
                  },
                );
              }),
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
              text: languagesController.tr("WITHDRAW"),
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

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            mypagecontroller.changePage(
              CreateWithdrawScreen(),
              isMainPage: false,
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(.16),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),

                const SizedBox(width: 9),

                Text(
                  languagesController.tr("NEW_WITHDRAW_REQUEST"),
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
    );
  }

  Widget _buildEmptyState(String? fontFamily) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.07),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 32,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(height: 13),

            Text(
              languagesController.tr("NO_DATA_FOUND"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8C8591),
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawCard(dynamic request, String? fontFamily) {
    final status = request.status?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.015),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _getStatusBg(status),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  _getStatusIcon(status),
                  size: 19,
                  color: _getStatusColor(status),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languagesController.tr("NET_AMOUNT"),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF97909D),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      request.netAmount ?? '0',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusBg(status),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.isEmpty ? 'N/A' : status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: _getStatusColor(status),
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildAmountBox(
                  label: languagesController.tr("AMOUNT"),
                  amount: request.amount ?? '0',
                  icon: Icons.payments_outlined,
                  color: AppColors.primaryColor,
                  background: const Color(0xFFF7F1FC),
                  fontFamily: fontFamily,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildAmountBox(
                  label: languagesController.tr("COMMISSION"),
                  amount: request.commissionAmount ?? '0',
                  icon: Icons.percent_rounded,
                  color: const Color(0xFFB28A24),
                  background: const Color(0xFFFFF8E8),
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),

          if (request.bankDetails != null) ...[
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF0ECF2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.07),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          languagesController.tr("BANK_DETAILS"),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4E4754),
                            fontFamily: fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  _buildBankDetailRow(
                    languagesController.tr("BANK_NAME"),
                    request.bankDetails!.bankName ?? 'N/A',
                    fontFamily,
                  ),

                  _buildBankDetailRow(
                    languagesController.tr("ACCOUNT_HOLDER"),
                    request.bankDetails!.accountHolderName ?? 'N/A',
                    fontFamily,
                  ),

                  _buildBankDetailRow(
                    languagesController.tr("ACCOUNT_NUMBER"),
                    request.bankDetails!.accountNumber ?? 'N/A',
                    fontFamily,
                  ),

                  if (request.bankDetails!.iban != null &&
                      request.bankDetails!.iban!.isNotEmpty)
                    _buildBankDetailRow(
                      languagesController.tr("IBAN"),
                      request.bankDetails!.iban!,
                      fontFamily,
                    ),

                  const SizedBox(height: 6),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0ECF2),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDateInfo(
                          Icons.calendar_today_outlined,
                          languagesController.tr("CREATED"),
                          request.createdAt != null
                              ? DateFormat(
                                  'dd MMM yyyy',
                                ).format(request.createdAt!)
                              : 'N/A',
                          fontFamily,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _buildDateInfo(
                          Icons.update_rounded,
                          languagesController.tr("UPDATED"),
                          request.updatedAt != null
                              ? DateFormat(
                                  'dd MMM yyyy',
                                ).format(request.updatedAt!)
                              : 'N/A',
                          fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountBox({
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
    required Color background,
    String? fontFamily,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(.72),
                    fontFamily: fontFamily,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value, String? fontFamily) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF97909D),
              fontFamily: fontFamily,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4E4754),
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(
    IconData icon,
    String label,
    String date,
    String? fontFamily,
  ) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F2F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 13, color: const Color(0xFF918A96)),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9A939F),
                  fontFamily: fontFamily,
                ),
              ),

              const SizedBox(height: 1),

              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF514A57),
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
