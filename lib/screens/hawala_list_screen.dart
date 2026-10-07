import 'package:afghannet/controllers/branch_controller.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/hawala_cancel_controller.dart';
import '../controllers/hawala_list_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';
import '../pages/homepages.dart';
import '../pages/transaction_type.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/menuiconwidget.dart';
import 'create_hawala_screen.dart';

class HawalaListScreen extends StatefulWidget {
  HawalaListScreen({super.key});

  @override
  State<HawalaListScreen> createState() => _HawalaListScreenState();
}

class _HawalaListScreenState extends State<HawalaListScreen> {
  final box = GetStorage();
  final hawalalistController = Get.find<HawalaListController>();
  final Mypagecontroller mypagecontroller = Get.find();
  LanguagesController languagesController = Get.put(LanguagesController());
  BranchController branchController = Get.put(BranchController());
  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    final int totalPages =
        hawalalistController.allhawalalist.value.data!.pagination!.totalPages ??
        0;
    final int currentPage = hawalalistController.initialpage;
    if (currentPage >= totalPages) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      hawalalistController.initialpage++;
      if (hawalalistController.initialpage <= totalPages) {
        hawalalistController.fetchhawala();
      } else {
        hawalalistController.initialpage = totalPages;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    hawalalistController.finalList.clear();
    hawalalistController.initialpage = 1;
    hawalalistController.fetchhawala();
    branchController.fetchallbranch();
    scrollController.addListener(refresh);
  }

  Color _statusColor(String status) {
    if (status == "pending") return const Color(0xFFFFC107);
    if (status == "confirmed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color _statusBg(String status) {
    if (status == "pending") return const Color(0xFFFFF8E8);
    if (status == "confirmed") return const Color(0xFFEEF9F4);
    return const Color(0xFFFFF2F2);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      resizeToAvoidBottomInset: false,
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
                      text: languagesController.tr("HAWALA_ORDER_LIST"),
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

            // ── New Order button ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GestureDetector(
                onTap: () => mypagecontroller.changePage(
                  HawalaScreen(),
                  isMainPage: false,
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
                      Text(
                        languagesController.tr("NEW_ORDER"),
                        style: const TextStyle(
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

            // ── List ────────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => hawalalistController.isLoading.value == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: hawalalistController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  hawalalistController.finalList[index];
                              final status = data.status.toString();
                              final hawalaNum = data.hawalaCustomNumber != null
                                  ? data.hawalaCustomNumber.toString()
                                  : data.hawalaNumber.toString();

                              return GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    content: HawalaDetailsDialog(
                                      id: data.id.toString(),
                                      hawalaNumber: data.hawalaNumber,
                                      status: data.status,
                                      branchID: data.hawalaBranchId,
                                      senderName: data.senderName,
                                      receiverName: data.receiverName,
                                      fatherName: data.receiverFatherName,
                                      idcardnumber: data.receiverIdCardNumber,
                                      amount: data.hawalaAmount,
                                      hawalacurrencyRate:
                                          data.hawalaAmountCurrencyRate,
                                      hawalacurrencyCode:
                                          data.hawalaAmountCurrencyCode,
                                      resellercurrencyCode:
                                          data.resellerPreferedCurrencyCode,
                                      resellCurrencyRate:
                                          data.resellerPreferedCurrencyRate,
                                      paidbysender: data.commissionPaidBySender
                                          .toString(),
                                      paidbyreceiver: data
                                          .commissionPaidByReceiver
                                          .toString(),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  padding: const EdgeInsets.fromLTRB(
                                    11,
                                    10,
                                    10,
                                    10,
                                  ),
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: _statusBg(status),
                                          borderRadius: BorderRadius.circular(
                                            13,
                                          ),
                                        ),
                                        child: Icon(
                                          status == "confirmed"
                                              ? Icons
                                                    .check_circle_outline_rounded
                                              : status == "pending"
                                              ? Icons.schedule_rounded
                                              : Icons.cancel_outlined,
                                          size: 19,
                                          color: _statusColor(status),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${languagesController.tr("HAWALA_NUMBER")} #$hawalaNum',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Color(0xFF342E39),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 3,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _statusBg(status),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          9,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    status,
                                                    style: TextStyle(
                                                      fontSize: 8.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: _statusColor(
                                                        status,
                                                      ),
                                                      fontFamily: fontFamily,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _personInfo(
                                                    icon: Icons
                                                        .person_outline_rounded,
                                                    label: languagesController
                                                        .tr("SENDER_NAME"),
                                                    value: data.senderName
                                                        .toString(),
                                                    fontFamily: fontFamily,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: _personInfo(
                                                    icon: Icons
                                                        .person_pin_circle_outlined,
                                                    label: languagesController
                                                        .tr("RECEIVER_NAME"),
                                                    value: data.receiverName
                                                        .toString(),
                                                    fontFamily: fontFamily,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 9,
                                                          vertical: 7,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF7F1FC,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            11,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr(
                                                                "HAWALA_AMOUNT",
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 8.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                  0xFF9A939F,
                                                                ),
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          data.hawalaAmount
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 9,
                                                          vertical: 7,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFEEF9F4,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            11,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          languagesController.tr(
                                                            "PAYABLE_AMOUNT",
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 8.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                  0xFF839189,
                                                                ),
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          data.hawalaAmountCurrencyRate
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Color(
                                                                  0xFF1D9E75,
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 13,
                                          color: Color(0xFFB7B0BC),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personInfo({
    required IconData icon,
    required String label,
    required String value,
    String? fontFamily,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF9C95A1)),
        const SizedBox(width: 5),
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
                  color: const Color(0xFFA19AA6),
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A434F),
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hawalaRow(
    String label,
    String value, {
    bool showDivider = true,
    Color? valueColor,
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
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
}

class HawalaDetailsDialog extends StatelessWidget {
  HawalaDetailsDialog({
    super.key,
    this.id,
    this.hawalaNumber,
    this.hawalaCustomNumber,
    this.status,
    this.branchID,
    this.senderName,
    this.receiverName,
    this.fatherName,
    this.idcardnumber,
    this.amount,
    this.hawalacurrencyRate,
    this.hawalacurrencyCode,
    this.resellercurrencyCode,
    this.resellCurrencyRate,
    this.paidbysender,
    this.paidbyreceiver,
  });

  String? id, hawalaNumber, hawalaCustomNumber, status, branchID;
  String? senderName, receiverName, fatherName, idcardnumber, amount;
  String? hawalacurrencyRate, hawalacurrencyCode;
  String? resellercurrencyCode, resellCurrencyRate;
  String? paidbysender, paidbyreceiver;

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  BranchController branchController = Get.put(BranchController());
  CancelHawalaController cancelHawalaController = Get.put(
    CancelHawalaController(),
  );
  RxBool isopen = true.obs;

  final GlobalKey catpureKey = GlobalKey();
  final GlobalKey _shareKey = GlobalKey();

  Color get _statusColor {
    if (status == "pending") return const Color(0xFFFFC107);
    if (status == "confirmed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color get _statusBg {
    if (status == "pending") return const Color(0xFFFFF8E8);
    if (status == "confirmed") return const Color(0xFFEEF9F4);
    return const Color(0xFFFFF2F2);
  }

  String get _statusIcon {
    if (status == "pending") return "assets/icons/pending.png";
    if (status == "confirmed") return "assets/icons/successful.png";
    return "assets/icons/rejected.png";
  }

  String get _statusText {
    if (status == "pending") return languagesController.tr("PENDING");
    if (status == "confirmed") return languagesController.tr("CONFIRMED");
    return languagesController.tr("REJECTED");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    final branch = branchController.allbranch.value.data!.hawalabranches!
        .firstWhere((item) => item.id.toString() == branchID.toString());

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ════════════════════════════════════════════════════════
            // CAPTURE AREA — do NOT restructure RepaintBoundary keys
            // ════════════════════════════════════════════════════════
            RepaintBoundary(
              key: catpureKey,
              child: RepaintBoundary(
                key: _shareKey,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEDE8F0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Status header
                      Container(
                        width: double.infinity,
                        color: _statusBg,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _statusColor.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset("assets/icons/logo.png"),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    _statusIcon,
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _statusText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: _statusColor,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: amount.toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: _statusColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  ${hawalacurrencyCode ?? ''}',
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

                      // Info rows
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                        child: Column(
                          children: [
                            _row(
                              languagesController.tr("HAWALA_NUMBER"),
                              hawalaCustomNumber ?? hawalaNumber.toString(),
                              fontFamily: fontFamily,
                              valueColor: AppColors.primaryColor,
                            ),
                            _divider(),
                            _row(
                              languagesController.tr("SENDER_NAME"),
                              senderName.toString(),
                              fontFamily: fontFamily,
                            ),
                            _divider(),
                            _row(
                              languagesController.tr("RECEIVER_NAME"),
                              receiverName.toString(),
                              fontFamily: fontFamily,
                            ),
                            _divider(),
                            _row(
                              languagesController.tr("HAWALA_AMOUNT"),
                              '$amount ${hawalacurrencyCode ?? ''}',
                              fontFamily: fontFamily,
                              valueColor: AppColors.primaryColor,
                              valueBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dashed separator
                      _dashedLine(),
                      const SizedBox(height: 12),

                      // Branch card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.055),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.13),
                            ),
                          ),
                          child: Column(
                            children: [
                              _row(
                                languagesController.tr("BRANCH"),
                                branch.name.toString(),
                                fontFamily: fontFamily,
                                valueColor: AppColors.primaryColor,
                              ),
                              _divider(),
                              _row(
                                languagesController.tr("ADDRESS"),
                                branch.address.toString(),
                                fontFamily: fontFamily,
                                maxLines: 2,
                              ),
                              _divider(),
                              _row(
                                languagesController.tr("PHONE_NUMBER"),
                                branch.phoneNumber.toString(),
                                fontFamily: fontFamily,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ════════════════════════════════════════════════════════
            // END OF CAPTURE AREA
            // ════════════════════════════════════════════════════════
            const SizedBox(height: 10),

            // Save + Share
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => capturePng(catpureKey),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_rounded,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            languagesController.tr("SAVE_TO_GALLERY"),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => captureImageFromWidgetAsFile(_shareKey),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.share_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            languagesController.tr("SHARE"),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Cancel order (animated)
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: isopen.value
                    ? Visibility(
                        key: const ValueKey('cancel_btn'),
                        visible: status.toString() == "pending",
                        child: GestureDetector(
                          onTap: () => isopen.value = false,
                          child: Container(
                            height: 46,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF2F2),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFF2CCCC),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                languagesController.tr("CANCEL_ORDER"),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE24B4A),
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey('confirm_row'),
                        height: 46,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => isopen.value = true,
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
                                      languagesController.tr("NO"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontFamily: fontFamily,
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
                                  cancelHawalaController.cancelnow(id);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D9E75),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      languagesController.tr("YES"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Close
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    String? fontFamily,
    Color? valueColor,
    bool valueBold = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontFamily: fontFamily,
            ),
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
                fontWeight: valueBold ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? const Color(0xFF1A1A2E),
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

  Widget _dashedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
    );
  }
}
