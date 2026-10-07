import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../global_controller/time_zone_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({
    super.key,
    this.createDate,
    this.status,
    this.rejectReason,
    this.companyName,
    this.bundleTitle,
    this.rechargebleAccount,
    this.validityType,
    this.sellingPrice,
    this.buyingPrice,
    this.orderID,
    this.resellerName,
    this.resellerPhone,
    this.companyLogo,
    this.amount,
  });
  String? createDate, status, rejectReason, companyName, bundleTitle;
  String? rechargebleAccount, validityType, sellingPrice, buyingPrice;
  String? orderID, resellerName, resellerPhone, companyLogo, amount;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  bool showprice = false;
  final GlobalKey _captureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();

  Color get _statusColor {
    if (widget.status == "0") return const Color(0xFFFFC107);
    if (widget.status == "1") return const Color(0xFF7d5fff);
    return const Color(0xFFE24B4A);
  }

  Color get _statusColorDark {
    if (widget.status == "0") return const Color(0xFFB8860B);
    if (widget.status == "1") return const Color(0xFF5B3FCC);
    return const Color(0xFFA32D2D);
  }

  String get _statusLabel {
    if (widget.status == "0") return languagesController.tr("PENDING");
    if (widget.status == "1") return languagesController.tr("CONFIRMED");
    return languagesController.tr("REJECTED");
  }

  String get _validityLabel {
    switch (widget.validityType) {
      case "yearly":
        return languagesController.tr("YEARLY");
      case "unlimited":
        return languagesController.tr("UNLIMITED");
      case "monthly":
        return languagesController.tr("MONTHLY");
      case "weekly":
        return languagesController.tr("WEEKLY");
      case "daily":
        return languagesController.tr("DAILY");
      case "hourly":
        return languagesController.tr("HOURLY");
      case "nightly":
        return languagesController.tr("NIGHTLY");
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF15131C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
            child: Column(
              children: [
                // ════════════════════════════════════════════════
                // PART 1 — Main detail card
                // ════════════════════════════════════════════════
                RepaintBoundary(
                  key: _captureKey,
                  child: RepaintBoundary(
                    key: shareKey,
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // ── Header ─────────────────────────────
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _statusColorDark.withOpacity(.96),
                                  _statusColor.withOpacity(.88),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -15,
                                  right: -15,
                                  child: Container(
                                    width: 62,
                                    height: 62,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  left: 10,
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => print(widget.status),
                                      child: Center(
                                        child: Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.18,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(9),
                                          child: Image.asset(
                                            "assets/icons/logo.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.18),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              _statusLabel,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (widget.status == "2" &&
                                        widget.rejectReason != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.rejectReason.toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ── Bundle row ─────────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF8FC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(
                                        color: const Color(0xFFEDE8F0),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      widget.companyLogo.toString(),
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 17,
                                        color: Color(0xFF9D96A3),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      widget.bundleTitle.toString(),
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF3B3541),
                                      ),
                                    ),
                                  ),
                                  if (_validityLabel.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(.08),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _validityLabel,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // ── Info rows ──────────────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                            child: Column(
                              children: [
                                _row(
                                  languagesController.tr("ORDER_ID"),
                                  "AF#- ${widget.orderID}",
                                ),
                                _row(
                                  languagesController.tr("DATE"),
                                  convertToDate(widget.createDate.toString()),
                                ),
                                _row(
                                  languagesController.tr("TIME"),
                                  convertToLocalTime(
                                    widget.createDate.toString(),
                                  ),
                                ),
                                _row(
                                  languagesController.tr("PHONE_NUMBER"),
                                  widget.rechargebleAccount.toString(),
                                ),
                                _row(
                                  languagesController.tr("SENDER"),
                                  widget.resellerName.toString(),
                                ),
                                if (showprice)
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        .06,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("PRICE"),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFBBBBBB),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.parse(
                                                        widget.sellingPrice
                                                            .toString(),
                                                      ),
                                                    ),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: _statusColor,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "  ${box.read("currency_code")}",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFFBBBBBB),
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
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ════════════════════════════════════════════════
                // PART 2 — Action card
                // ════════════════════════════════════════════════
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(.12)),
                  ),
                  child: Column(
                    children: [
                      // ── Top row: Hide + Close ─────────────────
                      Row(
                        children: [
                          // Hide / Show icon button
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => showprice = !showprice),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F6FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                child: Icon(
                                  showprice
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Close icon button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFECACA),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: Color(0xFFE24B4A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ── Bottom row: Save + Share ──────────────
                      Row(
                        children: [
                          // Save to gallery
                          Expanded(
                            child: GestureDetector(
                              onTap: () => capturePng(_captureKey),
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.download_rounded,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 6),
                                    KText(
                                      text: languagesController.tr(
                                        "SAVE_TO_GALLERY",
                                      ),
                                      fontSize: 12,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Share
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  captureImageFromWidgetAsFile(shareKey),
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
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
                                    KText(
                                      text: languagesController.tr("SHARE"),
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
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
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9B94A1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3A3440),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFF1EDF3), thickness: 1, height: 1),
      ],
    );
  }
}
