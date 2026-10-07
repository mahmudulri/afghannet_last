import 'package:afghannet/widgets/button.dart';
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
import 'package:intl/intl.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/drawer_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/welcomescreen.dart';

class Transactions extends StatefulWidget {
  Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final RxString selectedOrderStatus = "".obs;

  final List<Map<String, String>> orderStatus = [
    {"titleKey": "CREDIT", "value": "credit"},
    {"titleKey": "DEBIT", "value": "debit"},
  ];

  final RxString selectedCategoryType = "".obs;

  final List<Map<String, String>> categoryType = [
    {"titleKey": "ADMIN_TO_RESELLER", "value": "admin-reseller"},
    {"titleKey": "RESELLER_TO_ADMIN", "value": "reseller-subreseller"},
  ];
  final RxString selectedPurposeType = "".obs;
  final List<Map<String, String>> purposeType = [
    {"titleKey": "ORDER", "value": "order"},
    {"titleKey": "MONEY_TRANSFER", "value": "money"},
  ];

  final box = GetStorage();

  bool isFilterOpen = false;

  // String defaultValue = "";

  // String secondDropDown = "";

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Future<void> pickStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      startDate.value = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print("Selected Start Date: $formattedDate");
      box.write("startdate", "&filter_startdate=$formattedDate");

      // Reset end date if it's before start date
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (startDate.value == null) {
      Get.snackbar(
        languagesController.tr("WARNING"),
        languagesController.tr("SELECT_START_DATE_FIRST"),
      );
      return;
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value!,
      firstDate: startDate.value!, // 👈 important
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDate.value = picked;
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print("Selected Start Date: $formattedDate");
      box.write("enddate", "&filter_enddate=$formattedDate");
    }
  }

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  void initState() {
    super.initState();
    box.write("transactiontype", "");
    box.write("category", "");
    box.write("purpose", "");
    box.write("startdate", "");
    box.write("enddate", "");

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD), // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    transactionController.fetchTransactionData();
  }

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFBF9FD),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 40, 12, 0),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
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
                        () => KText(
                          text: languagesController.tr("TRANSACTIONS"),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: const Color(0xFF2E2833),
                        ),
                      ),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // mypagecontroller.openDrawer();
                          },
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
            Expanded(
              child: Container(
                color: const Color(0xFFFBF9FD),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    // ── Filter toggle button ──────────────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => isFilterOpen = !isFilterOpen),
                        child: Container(
                          height: 50,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  languagesController.tr("FILTER_TRANSACTION"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                isFilterOpen
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Collapsible filter panel ──────────────────────────────────────────────────
                    Visibility(
                      visible: isFilterOpen,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.fromLTRB(14, 9, 14, 0),
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
                        child: isFilterOpen
                            ? Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Type dropdown ───────────────────────────────
                                    _filterLabel(
                                      languagesController.tr("TYPE"),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDropdown(
                                      valueObs: selectedOrderStatus,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "",
                                          child: KText(
                                            text: languagesController.tr("ALL"),
                                            fontSize: screenWidth * 0.036,
                                          ),
                                        ),
                                        ...orderStatus
                                            .map<DropdownMenuItem<String>>((
                                              data,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: data['value'],
                                                child: KText(
                                                  text: languagesController.tr(
                                                    data['titleKey']!,
                                                  ),
                                                  fontSize: screenWidth * 0.036,
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ],
                                      onChanged: (value) {
                                        selectedOrderStatus.value = value ?? "";
                                        box.write(
                                          "transactiontype",
                                          "&filter_transactiontype=$value",
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    // ── Category dropdown ───────────────────────────
                                    _filterLabel(
                                      languagesController.tr("SELECT_CATEGORY"),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDropdown(
                                      valueObs: selectedCategoryType,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "",
                                          child: KText(
                                            text: languagesController.tr("ALL"),
                                            fontSize: screenWidth * 0.036,
                                          ),
                                        ),
                                        ...categoryType
                                            .map<DropdownMenuItem<String>>((
                                              data,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: data['value'],
                                                child: KText(
                                                  text: languagesController.tr(
                                                    data['titleKey']!,
                                                  ),
                                                  fontSize: screenWidth * 0.036,
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ],
                                      onChanged: (value) {
                                        selectedCategoryType.value =
                                            value ?? "";
                                        box.write(
                                          "category",
                                          "&filter_transactioncategory=$value",
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    // ── Purpose dropdown ────────────────────────────
                                    _filterLabel(
                                      languagesController.tr("SELECT_PURPOSE"),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDropdown(
                                      valueObs: selectedPurposeType,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "",
                                          child: KText(
                                            text: languagesController.tr("ALL"),
                                            fontSize: screenWidth * 0.036,
                                          ),
                                        ),
                                        ...purposeType
                                            .map<DropdownMenuItem<String>>((
                                              data,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: data['value'],
                                                child: KText(
                                                  text: languagesController.tr(
                                                    data['titleKey']!,
                                                  ),
                                                  fontSize: screenWidth * 0.036,
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ],
                                      onChanged: (value) {
                                        selectedPurposeType.value = value ?? "";
                                        box.write(
                                          "purpose",
                                          "&filter_transactionpurpose=$value",
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),

                                    // ── Date range ──────────────────────────────────
                                    Row(
                                      children: [
                                        // Start date
                                        Obx(
                                          () => Expanded(
                                            child: _buildDateField(
                                              label: startDate.value == null
                                                  ? languagesController.tr(
                                                      "START_DATE",
                                                    )
                                                  : DateFormat(
                                                      'yyyy/MM/dd',
                                                    ).format(startDate.value!),
                                              onTap: () =>
                                                  pickStartDate(context),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // End date
                                        Obx(
                                          () => Expanded(
                                            child: _buildDateField(
                                              label: endDate.value == null
                                                  ? languagesController.tr(
                                                      "END_DATE",
                                                    )
                                                  : DateFormat(
                                                      'yyyy/MM/dd',
                                                    ).format(endDate.value!),
                                              onTap: () => pickEndDate(context),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // ── Action buttons ──────────────────────────────
                                    Obx(
                                      () => Row(
                                        children: [
                                          // Apply filter
                                          Expanded(
                                            flex: 5,
                                            child: GestureDetector(
                                              onTap: () => transactionController
                                                  .fetchTransactionData(),
                                              child: Container(
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: KText(
                                                    text: languagesController
                                                        .tr("APPLY_FILTER"),
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        screenWidth * 0.034,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          // Remove filter
                                          Expanded(
                                            flex: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                selectedOrderStatus.value = "";
                                                selectedCategoryType.value = "";
                                                selectedPurposeType.value = "";
                                                startDate.value = null;
                                                endDate.value = null;
                                                box.write(
                                                  "transactiontype",
                                                  "",
                                                );
                                                box.write("category", "");
                                                box.write("purpose", "");
                                                box.write("startdate", "");
                                                box.write("enddate", "");
                                                transactionController
                                                    .fetchTransactionData();
                                              },
                                              child: Container(
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: KText(
                                                    text: languagesController
                                                        .tr("REMOVE_FILTER"),
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        screenWidth * 0.034,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      if (transactionController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final transactions = transactionController
                          .alltransactionlist
                          .value
                          .data
                          ?.resellerBalanceTransactions;

                      if (transactions == null || transactions.isEmpty) {
                        return Center(
                          child: Text(
                            languagesController.tr("NO_DATA_FOUND"),

                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // If data exists but you don't want to show a list
                      return const SizedBox();
                    }),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Obx(
                        () => transactionController.isLoading.value == false
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactionController
                                    .alltransactionlist
                                    .value
                                    .data!
                                    .resellerBalanceTransactions
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = transactionController
                                      .alltransactionlist
                                      .value
                                      .data!
                                      .resellerBalanceTransactions[index];

                                  final isDebit =
                                      data.status.toString() == "debit";
                                  final typeColor = isDebit
                                      ? const Color(0xFFE24B4A)
                                      : const Color(0xFF1D9E75);
                                  final typeBg = isDebit
                                      ? const Color(0xFFFEF2F2)
                                      : const Color(0xFFE9F2ED);
                                  final currency =
                                      box.read("currency_code") ?? '';

                                  return Container(
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
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: typeBg,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Icon(
                                            isDebit
                                                ? Icons.north_east_rounded
                                                : Icons.south_west_rounded,
                                            color: typeColor,
                                            size: 19,
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
                                                      data
                                                          .reseller!
                                                          .resellerName
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Color(
                                                          0xFF342E39,
                                                        ),
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
                                                      color: typeBg,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            9,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      isDebit
                                                          ? languagesController
                                                                .tr("DEBIT")
                                                          : languagesController
                                                                .tr("CREDIT"),
                                                      style: TextStyle(
                                                        fontSize: 8.5,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: typeColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: 12,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    DateFormat(
                                                      "dd MMM yyyy",
                                                    ).format(
                                                      DateTime.parse(
                                                        data.createdAt
                                                            .toString(),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 9.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 9,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: typeBg,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          isDebit ? '- ' : '+ ',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: typeColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          NumberFormat.currency(
                                                            locale: 'en_US',
                                                            symbol: '',
                                                            decimalDigits: 2,
                                                          ).format(
                                                            double.parse(
                                                              data.amount
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 12.5,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: typeColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          currency,
                                                          style: TextStyle(
                                                            fontSize: 8.5,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: typeColor
                                                                .withOpacity(
                                                                  .70,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(),
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
  }

  // ── Helpers (add inside your State class) ─────────────────────────────────────

  Widget _filterLabel(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade500,
    ),
  );

  Widget _buildDropdown({
    required RxString valueObs,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            value: valueObs.value.isEmpty ? null : valueObs.value,
            isExpanded: true,
            hint: KText(text: languagesController.tr("ALL"), fontSize: 14),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade400,
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({required String label, required VoidCallback onTap}) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.calendar_month_rounded,
              size: 18,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
