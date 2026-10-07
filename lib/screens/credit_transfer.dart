import 'package:afghannet/controllers/currency_controller.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/widgets/bottomsheet.dart';
import 'package:afghannet/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:afghannet/controllers/country_list_controller.dart';
import 'package:afghannet/controllers/custom_history_controller.dart';
import 'package:afghannet/controllers/custom_recharge_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/pages/homepages.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/button_one.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/recharge_config_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/afghan_recharge_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/button.dart';

class CreditTransfer extends StatefulWidget {
  CreditTransfer({super.key});

  @override
  State<CreditTransfer> createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
  final customhistoryController = Get.find<CustomHistoryController>();

  final countryListController = Get.find<CountryListController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final CurrencyController currencyController = Get.find<CurrencyController>();

  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  final box = GetStorage();
  int selectedIndex = 0;

  final FocusNode _focusNode = FocusNode();

  RxList<bool> expandedIndices = <bool>[].obs;

  final ScrollController scrollController = ScrollController();

  final dashboardController = Get.find<DashboardController>();
  final companyController = Get.find<CompanyController>();

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  final AfghanRechargeController controller =
      Get.find<AfghanRechargeController>();

  final RechargeConfigController configController =
      Get.find<RechargeConfigController>();

  Future<void> refresh() async {
    // Pull-to-refresh can call this before the ScrollController is attached.
    // In that case, refresh the first page safely instead of reading position.
    if (!scrollController.hasClients) {
      customhistoryController.finalList.clear();
      customhistoryController.initialpage = 1;
      await customhistoryController.fetchHistory();
      return;
    }

    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination
            ?.totalPages ??
        0;

    final int currentPage = customhistoryController.initialpage;

    // If this call came from pull-to-refresh and we're not at the bottom,
    // reload the first page.
    if (scrollController.position.pixels <
        scrollController.position.maxScrollExtent) {
      customhistoryController.finalList.clear();
      customhistoryController.initialpage = 1;
      await customhistoryController.fetchHistory();
      return;
    }

    // Pagination: stop if we are already on the last page.
    if (totalPages <= 0 || currentPage >= totalPages) {
      return;
    }

    customhistoryController.initialpage++;

    if (customhistoryController.initialpage <= totalPages) {
      await customhistoryController.fetchHistory();
    } else {
      customhistoryController.initialpage = totalPages;
    }
  }

  @override
  void initState() {
    super.initState();
    configController.fetchrechargeConfig();
    controller.reset();
    conversationController.resetConversion();
    customRechargeController.amountController.clear();
    customRechargeController.numberController.clear();

    currencyController.fetchCurrencyList();

    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    customhistoryController.fetchHistory();
    scrollController.addListener(refresh);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD), // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );

    customRechargeController.numberController.addListener(() {
      final text = customRechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final Mypagecontroller mypagecontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF9FD),
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => mypagecontroller.goBack(),
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFEDE8F0),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 17,
                                color: Color(0xFF4C4652),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            languagesController.tr("AFGHANISTAN_RECHARGE"),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: const Color(0xFF2E2833),
                            ),
                          ),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            // onTap: () => mypagecontroller.openDrawer(),
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFEDE8F0),
                                ),
                              ),
                              child: Center(child: MenuiconWIdget()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFEDE8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.018),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Flag ────────────────────────────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 38,
                          width: 70,
                          color: Colors.grey.shade200,
                          child: Image.network(
                            countryListController.flagimageurl.toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.flag, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Phone number field ───────────────────────────────────────
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8FC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEDE8F0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                controller:
                                    customRechargeController.numberController,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: languagesController.tr(
                                    "PHONENUMBER",
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            // Company logo
                            Obx(() {
                              final company =
                                  companyController.matchedCompany.value;
                              return Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                  image: company != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            company.companyLogo ?? '',
                                          ),
                                          fit: BoxFit.contain,
                                        )
                                      : null,
                                ),
                                child: company == null
                                    ? Icon(
                                        Icons.business_rounded,
                                        size: 18,
                                        color: Colors.grey.shade300,
                                      )
                                    : null,
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Amount field ─────────────────────────────────────────────
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8FC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEDE8F0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.payments_rounded,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                onChanged: controller.calculate,
                                controller:
                                    customRechargeController.amountController,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: languagesController.tr("AMOUNT"),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "AFN",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Converted amount ─────────────────────────────────────────
                      Obx(
                        () => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F1FC),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.currency_exchange_rounded,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 7),
                              const Spacer(),
                              Text(
                                "${controller.convertedAmount.value.toStringAsFixed(2)} ${controller.box.read("currency_symbol")}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Buying / Selling ─────────────────────────────────────────
                      Obx(
                        () => Row(
                          children: [
                            // Buying
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E8),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFFFE082),
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFE082),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_downward_rounded,
                                            size: 10,
                                            color: Color(0xFFB8860B),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          languagesController.tr("BUYING"),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFB8860B),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          box.read("currency_symbol"),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Color(0xFFD4A017),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.buyingPrice.value
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFB8860B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Selling
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF9F4),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFA5D6B0),
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFC8E6C9),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_upward_rounded,
                                            size: 10,
                                            color: Color(0xFF1D9E75),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          languagesController.tr("SELLING"),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1D9E75),
                                          ),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          box.read("currency_symbol"),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Color(0xFF1D9E75),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.sellingPrice.value
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1D9E75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Send button ──────────────────────────────────────────────
                      GestureDetector(
                        onTap: () {
                          if (customRechargeController
                                  .numberController
                                  .text
                                  .isEmpty ||
                              customRechargeController
                                  .amountController
                                  .text
                                  .isEmpty) {
                            Fluttertoast.showToast(
                              msg: languagesController.tr(
                                "ENTER_REQUIRED_DATA",
                              ),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBF9FD),
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFEDE8F0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                .10,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        width: screenWidth,
                                        child: Obx(
                                          () =>
                                              customRechargeController
                                                      .isLoading
                                                      .value ==
                                                  false
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                    20,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 52,
                                                        height: 52,
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .primaryColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                14,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          Icons.send_rounded,
                                                          color: AppColors
                                                              .primaryColor,
                                                          size: 24,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 14,
                                                      ),
                                                      Text(
                                                        languagesController.tr(
                                                          "ARE_YOU_SURE_TO_TRANSFER",
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xFF1A1A2E,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          // Confirm
                                                          Expanded(
                                                            flex: 3,
                                                            child: GestureDetector(
                                                              onTap: () =>
                                                                  customRechargeController
                                                                      .placeOrder(
                                                                        context,
                                                                      ),
                                                              child: Container(
                                                                height: 46,
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFF1D9E75,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    languagesController.tr(
                                                                      "CONFIRMATION",
                                                                    ),
                                                                    style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          // Cancel
                                                          Expanded(
                                                            flex: 2,
                                                            child: GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                              child: Container(
                                                                height: 46,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    languagesController
                                                                        .tr(
                                                                          "CANCEL",
                                                                        ),
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
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
                                                )
                                              : SizedBox(
                                                  height: 200,
                                                  child: Lottie.asset(
                                                    'assets/loties/recharge.json',
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
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
                              const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              KText(
                                text: languagesController.tr(
                                  "SEND_TO_DESTINATION",
                                ),
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9FD),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Obx(() {
                          if (expandedIndices.length !=
                              customhistoryController.finalList.length) {
                            expandedIndices.assignAll(
                              List.generate(
                                customhistoryController.finalList.length,
                                (index) => false,
                              ),
                            );
                          }

                          return customhistoryController.isLoading.value ==
                                      false &&
                                  customhistoryController.finalList.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: customhistoryController
                                        .finalList
                                        .length,
                                    itemBuilder: (context, index) {
                                      final data = customhistoryController
                                          .finalList[index];

                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 9,
                                        ),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFFEDE8F0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                .014,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            ExpansionTile(
                                              key: Key(
                                                index.toString(),
                                              ), // Ensure state retention
                                              initiallyExpanded:
                                                  expandedIndices[index],
                                              onExpansionChanged: (isExpanded) {
                                                expandedIndices[index] =
                                                    isExpanded;
                                              },
                                              tilePadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              title: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.bundle!.bundleTitle
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        data.rechargebleAccount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: expandedIndices[index]
                                                  ? null
                                                  : GestureDetector(
                                                      onTap: () {
                                                        expandedIndices[index] =
                                                            true;
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(width: 5),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .chevronDown,
                                                            size:
                                                                screenHeight *
                                                                0.022,
                                                            color: Color(
                                                              0xff1890FF,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "TRANSFER_STATUS",
                                                            ),
                                                          ),
                                                          Text(
                                                            data.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? languagesController
                                                                      .tr(
                                                                        "PENDING",
                                                                      )
                                                                : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                ? languagesController
                                                                      .tr(
                                                                        "SUCCESS",
                                                                      )
                                                                : languagesController
                                                                      .tr(
                                                                        "REJECTED",
                                                                      ),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  box
                                                                          .read(
                                                                            "language",
                                                                          )
                                                                          .toString() ==
                                                                      "Fa"
                                                                  ? Get.find<
                                                                          FontController
                                                                        >()
                                                                        .currentFont
                                                                  : null,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("AMOUNT"),
                                                          ),
                                                          Text(
                                                            "${data.bundle.amount} ${box.read("currency_code")}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("DATE"),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  box
                                                                          .read(
                                                                            "language",
                                                                          )
                                                                          .toString() ==
                                                                      "Fa"
                                                                  ? Get.find<
                                                                          FontController
                                                                        >()
                                                                        .currentFont
                                                                  : null,
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'yyyy-MM-dd',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("TIME"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  box
                                                                          .read(
                                                                            "language",
                                                                          )
                                                                          .toString() ==
                                                                      "Fa"
                                                                  ? Get.find<
                                                                          FontController
                                                                        >()
                                                                        .currentFont
                                                                  : null,
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'hh:mm a',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : customhistoryController.finalList.isEmpty
                              ? SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      customhistoryController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data = customhistoryController
                                        .finalList[index];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 9),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          ExpansionTile(
                                            key: Key(
                                              index.toString(),
                                            ), // Ensure state retention
                                            initiallyExpanded:
                                                expandedIndices[index],
                                            onExpansionChanged: (isExpanded) {
                                              expandedIndices[index] =
                                                  isExpanded;
                                            },
                                            tilePadding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            title: Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data
                                                            .bundle!
                                                            .service!
                                                            .company!
                                                            .companyLogo
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.bundle!.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.rechargebleAccount
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing: expandedIndices[index]
                                                ? null
                                                : GestureDetector(
                                                    onTap: () {
                                                      expandedIndices[index] =
                                                          true;
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 5),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .chevronDown,
                                                          size:
                                                              screenHeight *
                                                              0.022,
                                                          color: Color(
                                                            0xff1890FF,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController.tr(
                                                            "TRANSFER_STATUS",
                                                          ),
                                                        ),
                                                        Text(
                                                          data.status
                                                                      .toString() ==
                                                                  "0"
                                                              ? languagesController
                                                                    .tr(
                                                                      "PENDING",
                                                                    )
                                                              : data.status
                                                                        .toString() ==
                                                                    "1"
                                                              ? languagesController
                                                                    .tr(
                                                                      "SUCCESS",
                                                                    )
                                                              : languagesController
                                                                    .tr(
                                                                      "REJECTED",
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("AMOUNT"),
                                                        ),
                                                        Text(
                                                          "${data.bundle.amount} ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("DATE"),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'yyyy-MM-dd',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("TIME"),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'hh:mm a',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
