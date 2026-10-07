import 'package:afghannet/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';

import '../controllers/payments_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/menuiconwidget.dart';
import 'create_payments_screen.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

final Mypagecontroller mypagecontroller = Get.find();
LanguagesController languagesController = Get.put(LanguagesController());

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  List orderStatus = [];
  String defaultValue = "";
  String secondDropDown = "";

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  PaymentsController paymentsController = Get.put(PaymentsController());

  @override
  void initState() {
    super.initState();

    paymentsController.fetchpayments();

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => mypagecontroller.changePage(
                  CreatePaymentsScreen(),
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
                        color: AppColors.primaryColor.withOpacity(.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
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
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      KText(
                        text: languagesController.tr("ADD_NEW_RECEIPT"),
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (paymentsController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                final payments =
                    paymentsController.allpaymentslist.value.data!.payments;

                if (payments.isEmpty) {
                  return Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.06),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    await paymentsController.fetchpayments();
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: payments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final data = payments[index];
                      return _buildPaymentCard(context, data, screenWidth);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              text: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
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
}

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

  String? status;
  String? paymentmethod;
  String? amount;
  String? performedByName;
  String? notes;
  String? currency;
  String? date;
  String? image1;
  String? image2;
  String? image3;

  final box = GetStorage();
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  Color get _statusColor {
    if (status == "pending") return const Color(0xFFE4A800);
    if (status == "completed") return const Color(0xFF1D9E75);
    return const Color(0xFFE24B4A);
  }

  Color get _statusBg {
    if (status == "pending") return const Color(0xFFFFF7DB);
    if (status == "completed") return const Color(0xFFEAF7F1);
    return const Color(0xFFFFECEC);
  }

  IconData get _statusIcon {
    if (status == "pending") return Icons.schedule_rounded;
    if (status == "completed") return Icons.check_circle_rounded;
    return Icons.cancel_rounded;
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .82,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              color: _statusBg,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(_statusIcon, color: _statusColor, size: 25),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: amount.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF322C37),
                                ),
                              ),
                              TextSpan(
                                text: '  $currency',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8F8895),
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

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                ),
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
                    _divider(),
                    _row(
                      languagesController.tr("DATE"),
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(DateTime.parse(date.toString())),
                    ),
                    if (notes != null && notes!.isNotEmpty) ...[
                      _divider(),
                      _row(
                        languagesController.tr("NOTES"),
                        notes.toString(),
                        fontFamily: fontFamily,
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 82,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _imageThumb(image1),
                  const SizedBox(width: 8),
                  _imageThumb(image2),
                  const SizedBox(width: 8),
                  _imageThumb(image3),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 46,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E0E8)),
                  ),
                  child: KText(
                    text: languagesController.tr("CLOSE"),
                    fontSize: 13,
                    color: const Color(0xFF625B68),
                    fontWeight: FontWeight.w700,
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF938C99),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3E3844),
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1EDF3));
  }

  Widget _imageThumb(String? url) {
    final isEmpty = url == null || url.isEmpty || url == 'null';

    return Container(
      width: 92,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F9),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: isEmpty
          ? const Center(
              child: Icon(
                Icons.image_outlined,
                size: 24,
                color: Color(0xFFC3BCC7),
              ),
            )
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 22,
                  color: Color(0xFFC3BCC7),
                ),
              ),
            ),
    );
  }
}

Color _statusColor(String status) {
  if (status == "pending") return const Color(0xFFE4A800);
  if (status == "completed") return const Color(0xFF1D9E75);
  return const Color(0xFFE24B4A);
}

Color _statusBg(String status) {
  if (status == "pending") return const Color(0xFFFFF7DB);
  if (status == "completed") return const Color(0xFFEAF7F1);
  return const Color(0xFFFFECEC);
}

IconData _statusIcon(String status) {
  if (status == "pending") return Icons.schedule_rounded;
  if (status == "completed") return Icons.check_rounded;
  return Icons.close_rounded;
}

Widget _buildPaymentCard(
  BuildContext context,
  dynamic data,
  double screenWidth,
) {
  final status = data.status.toString();
  final statusColor = _statusColor(status);
  final statusBg = _statusBg(status);

  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: PaymentDialog(
            status: data.status,
            paymentmethod: data.paymentMethod!.methodName,
            amount: data.amount,
            performedByName: data.performedByName,
            currency: data.currency!.code,
            notes: data.notes,
            date: data.paymentDate.toString(),
            image1: data.paymentImageUrl,
            image2: data.extraImage1Url,
            image3: data.extraImage2Url,
          ),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDE8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.018),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _statusIcon(status),
                      size: 18,
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.paymentMethod!.methodName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3A3440),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          data.performedByName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9A93A0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: data.amount.toString(),
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF342E39),
                              ),
                            ),
                            TextSpan(
                              text: ' ${data.currency!.symbol}',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9D96A3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 9),

              Container(height: 1, color: const Color(0xFFF1EDF3)),

              const SizedBox(height: 9),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: Color(0xFFA49DA9),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat(
                      'dd MMM yyyy',
                    ).format(DateTime.parse(data.paymentDate.toString())),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7F7885),
                    ),
                  ),

                  const Spacer(),

                  if (data.notes != null &&
                      data.notes.toString().trim().isNotEmpty)
                    Flexible(
                      child: Text(
                        data.notes.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF9A93A0),
                        ),
                      ),
                    ),

                  const SizedBox(width: 6),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFFB5AEBB),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
