import 'package:afghannet/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/screens/add_new_user.dart';
import 'package:afghannet/widgets/bottomsheet.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';
import '../controllers/loanlist_controller.dart';
import '../controllers/payments_controller.dart';
import '../controllers/request_loan_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import 'create_payments_screen.dart';

// ── Top-level declarations (keep as is) ──────────────────────────────────────
final Mypagecontroller mypagecontroller = Get.find();
LanguagesController languagesController = Get.put(LanguagesController());

// ══════════════════════════════════════════════════════════════════════════════
// RequestLoanScreen
// ══════════════════════════════════════════════════════════════════════════════
class RequestLoanScreen extends StatefulWidget {
  const RequestLoanScreen({super.key});

  @override
  State<RequestLoanScreen> createState() => _RequestLoanScreenState();
}

class _RequestLoanScreenState extends State<RequestLoanScreen> {
  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  LoanlistController loanlistController = Get.put(LoanlistController());
  RequestLoanController requestLoanController = Get.put(
    RequestLoanController(),
  );

  @override
  void initState() {
    super.initState();
    loanlistController.fetchLoan();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == "pending") return const Color(0xFFFFC107);
    if (status == "completed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color _statusBg(String status) {
    if (status == "pending") return const Color(0xFFFFF8E8);
    if (status == "completed") return const Color(0xFFEEF9F4);
    return const Color(0xFFFFF2F2);
  }

  String _statusLabel(String status) {
    if (status == "pending") return languagesController.tr("PENDING");
    if (status == "completed") return languagesController.tr("COMPLETED");
    return languagesController.tr("ROLLBACKED");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => mypagecontroller.goBack(),
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
                  const Spacer(),
                  Obx(
                    () => KText(
                      text: languagesController.tr("LOAN_REQUEST"),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      // onTap: () => mypagecontroller.openDrawer(),
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
            ),
            const SizedBox(height: 12),

            // ── Add new request button ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: _buildLoanDialog(context, screenWidth, fontFamily),
                  ),
                ),
                child: Container(
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => KText(
                          text: languagesController.tr("ADD_NEW_REQUEST"),
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Loan list ────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(
                  () => loanlistController.isLoading.value == false
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: loanlistController
                              .allloanlist
                              .value
                              .data!
                              .balances!
                              .data!
                              .length,
                          itemBuilder: (context, index) {
                            final data = loanlistController
                                .allloanlist
                                .value
                                .data!
                                .balances!
                                .data![index];
                            final status = data.status.toString();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFEDE8F0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.015),
                                    blurRadius: 9,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Left color bar
                                    Container(
                                      width: 4,
                                      color: _statusColor(status),
                                    ),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        children: [
                                          // Header: amount + status
                                          Container(
                                            color: _statusBg(status),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 7,
                                                      height: 7,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _statusColor(
                                                          status,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      _statusLabel(status),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: _statusColor(
                                                          status,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: data.amount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: _statusColor(
                                                            status,
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '  ${data.currency!.symbol}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: _statusColor(
                                                            status,
                                                          ).withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Info rows
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              14,
                                              8,
                                              14,
                                              12,
                                            ),
                                            child: Column(
                                              children: [
                                                _loanRow(
                                                  languagesController.tr(
                                                    "TRANSACTION_TYPE",
                                                  ),
                                                  data.transactionType
                                                      .toString(),
                                                  showDivider: true,
                                                ),
                                                _loanRow(
                                                  languagesController.tr(
                                                    "REMAINING_BALANCE",
                                                  ),
                                                  '${data.remainingBalance} ${data.currency!.code}',
                                                  showDivider: true,
                                                  valueColor:
                                                      AppColors.primaryColor,
                                                ),
                                                _loanRow(
                                                  languagesController.tr(
                                                    "NOTES",
                                                  ),
                                                  data.description.toString(),
                                                  showDivider: true,
                                                  maxLines: 1,
                                                  fontFamily: fontFamily,
                                                ),
                                                _loanRow(
                                                  languagesController.tr(
                                                    "DATE",
                                                  ),
                                                  DateFormat(
                                                    'dd MMM yyyy',
                                                  ).format(
                                                    DateTime.parse(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),
                                                  showDivider: false,
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
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loanRow(
    String label,
    String value, {
    bool showDivider = true,
    Color? valueColor,
    int maxLines = 1,
    String? fontFamily,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF1A1A2E),
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: Colors.grey.shade100, thickness: 1, height: 1),
      ],
    );
  }

  // Loan request dialog
  Widget _buildLoanDialog(
    BuildContext context,
    double screenWidth,
    String? fontFamily,
  ) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              languagesController.tr("ENTER_LOAN_AMOUNT"),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Amount field
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE8F0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: requestLoanController.amountController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: languagesController.tr("ENTER_AMOUNT"),
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ),
                Text(
                  box.read("currency_code") ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1DCE4)),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("CANCEL"),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (requestLoanController
                        .amountController
                        .text
                        .isNotEmpty) {
                      requestLoanController.requestloan();
                    } else {
                      Fluttertoast.showToast(
                        msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Obx(
                    () => Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(.16),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          requestLoanController.isLoading.value == false
                              ? languagesController.tr("SUBMIT")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
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
// PaymentDialog
// ══════════════════════════════════════════════════════════════════════════════
class PaymentDialog extends StatelessWidget {
  PaymentDialog({
    super.key,
    this.status,
    this.paymentmethod,
    this.amount,
    this.performedByName,
    this.notes,
    this.currency,
    this.date,
    this.image1,
    this.image2,
    this.image3,
  });

  String? status, paymentmethod, amount, performedByName;
  String? notes, currency, date, image1, image2, image3;
  final box = GetStorage();

  Color get _statusColor {
    if (status == "pending") return const Color(0xFFFFC107);
    if (status == "completed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color get _statusBg {
    if (status == "pending") return const Color(0xFFFFF8E8);
    if (status == "completed") return const Color(0xFFEEF9F4);
    return const Color(0xFFFFF2F2);
  }

  String get _statusIcon {
    if (status == "pending") return "assets/icons/pending.png";
    if (status == "completed") return "assets/icons/successful.png";
    return "assets/icons/rejected.png";
  }

  String get _statusLabel {
    if (status == "pending") return languagesController.tr("PENDING");
    if (status == "completed") return languagesController.tr("COMPLETED");
    return languagesController.tr("REJECTED");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: _statusBg,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _statusColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(_statusIcon),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: amount.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: _statusColor,
                        ),
                      ),
                      TextSpan(
                        text: '  $currency',
                        style: TextStyle(
                          fontSize: 12,
                          color: _statusColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info rows ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                _row(
                  languagesController.tr("PAYMENT_METHOD"),
                  paymentmethod.toString(),
                ),
                _divider(),
                _row(
                  languagesController.tr("PERFORMED_BY"),
                  performedByName.toString(),
                ),
                if (notes != null && notes!.isNotEmpty) ...[
                  _divider(),
                  _row(
                    languagesController.tr("NOTES"),
                    notes.toString(),
                    fontFamily: fontFamily,
                    maxLines: 2,
                  ),
                ],
                _divider(),
                _row(
                  languagesController.tr("DATE"),
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(date.toString())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Images ─────────────────────────────────────────────────
          SizedBox(
            height: 78,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _imgThumb(image1),
                const SizedBox(width: 8),
                _imgThumb(image2),
                const SizedBox(width: 8),
                _imgThumb(image3),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dashed divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                30,
                (i) => Expanded(
                  child: Container(
                    height: 1,
                    color: i.isEven ? Colors.grey.shade200 : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Close button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    languagesController.tr("CLOSE"),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    String? fontFamily,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(color: Colors.grey.shade100, thickness: 1, height: 1);

  Widget _imgThumb(String? url) {
    final empty = url == null || url.isEmpty || url == 'null';
    return Container(
      width: 90,
      height: 78,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: empty
          ? Center(
              child: Icon(
                Icons.image_outlined,
                size: 22,
                color: Colors.grey.shade300,
              ),
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 20,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
    );
  }
}
