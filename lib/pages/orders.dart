import 'dart:async';

import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/order_list_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/helpers/localtime_helper.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:afghannet/widgets/bottomsheet.dart';
import 'package:afghannet/widgets/drawer.dart';

import '../controllers/drawer_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';
import '../screens/order_details_screen.dart';
import '../widgets/menuiconwidget.dart';

class Orders extends StatefulWidget {
  Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String defaultValue = "";

  String secondDropDown = "";

  final orderlistController = Get.find<OrderlistController>();

  TextEditingController searchController = TextEditingController();
  late LanguagesController languagesController;

  List orderStatus = [];

  String search = "";

  final RxString selectedDate = ''.obs;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default date
      firstDate: DateTime(2000), // earliest date
      lastDate: DateTime(2100), // latest date
    );

    if (picked != null) {
      // Format the selected date as yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      selectedDate.value = formattedDate;
      print(formattedDate); // Print to console
      box.write("date", "selected_date=" + formattedDate.toString());
      orderlistController.finalList.clear();
      orderlistController.initialpage = 1;
      orderlistController.fetchOrderlistdata();
    }
  }

  final box = GetStorage();

  Timer? _debounce;

  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    if (orderlistController.finalList.length >=
        (orderlistController
                .allorderlist
                .value
                .payload
                ?.pagination
                .totalItems ??
            0)) {
      print(
        "End..........................................End.....................",
      );
    } else {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        orderlistController.initialpage++;
        // print(orderlistController.initialpage);
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        // print("nothing");
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  MyDrawerController drawerController = Get.put(MyDrawerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: const Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];
    box.write("date", "");
    box.write("orderstatus", "");
    box.write("search_target", "");
    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;
    orderlistController.fetchOrderlistdata();
    scrollController.addListener(refresh);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => dashboardController.deactiveStatus.value != "Deactivated"
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              backgroundColor: const Color(0xFFFBF9FD),
              body: SafeArea(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF9FD),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primaryColor.withOpacity(.05),
                            ),
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
                                  color: AppColors.primaryColor.withOpacity(
                                    .09,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withOpacity(
                                      .08,
                                    ),
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
                                  text: languagesController.tr("ORDERS"),
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
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: Ink(
                                  width: 42,
                                  height: 42,
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
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: screenWidth,
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
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Title ────────────────────────────────────────────────────────
                              KText(
                                text: languagesController.tr("FILTER"),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              SizedBox(height: 10),

                              // ── Status dropdown ───────────────────────────────────────────────
                              Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF8FC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFEDE8F0),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                          isDense: true,
                                          value: defaultValue,
                                          isExpanded: true,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.036,
                                            color: Colors.grey.shade700,
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: "",
                                              child: KText(
                                                text: languagesController.tr(
                                                  "ALL",
                                                ),
                                                fontSize: screenWidth * 0.036,
                                              ),
                                            ),
                                            ...orderStatus.map<
                                              DropdownMenuItem<String>
                                            >((data) {
                                              return DropdownMenuItem(
                                                value: data['value'],
                                                child: KText(
                                                  text: data['title'],
                                                  fontSize: screenWidth * 0.036,
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                          onChanged: (value) {
                                            box.write("orderstatus", value);
                                            orderlistController.finalList
                                                .clear();
                                            orderlistController.initialpage = 1;
                                            orderlistController
                                                .fetchOrderlistdata();
                                            setState(
                                              () => defaultValue = value!,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),

                              // ── Date picker ───────────────────────────────────────────────────
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAF8FC),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 0.5,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_rounded,
                                        size: 16,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Obx(
                                          () => KText(
                                            text: selectedDate.value == ""
                                                ? languagesController.tr("DATE")
                                                : selectedDate.value.toString(),
                                            fontSize: screenWidth * 0.036,
                                            color: selectedDate.value == ""
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_month_rounded,
                                        size: 18,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),

                              // ── Search ────────────────────────────────────────────────────────
                              Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF8FC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFEDE8F0),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search_rounded,
                                      size: 18,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Obx(
                                        () => TextField(
                                          keyboardType: TextInputType.phone,
                                          onChanged: (value) {
                                            if (_debounce?.isActive ?? false)
                                              _debounce!.cancel();
                                            _debounce = Timer(
                                              Duration(seconds: 1),
                                              () {
                                                orderlistController.finalList
                                                    .clear();
                                                orderlistController
                                                        .initialpage =
                                                    1;
                                                box.write(
                                                  "search_target",
                                                  value,
                                                );
                                                orderlistController
                                                    .fetchOrderlistdata();
                                              },
                                            );
                                          },
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.036,
                                            color: Colors.grey.shade700,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: languagesController.tr(
                                              "SEARCH_BY_PHOENUMBER",
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            hintStyle: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: screenWidth * 0.036,
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
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFFBF9FD),
                          child: Column(
                            children: [
                              Obx(
                                () =>
                                    orderlistController.isLoading.value == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ),
                              Obx(
                                () =>
                                    orderlistController.isLoading.value == false
                                    ? Container(
                                        child:
                                            orderlistController
                                                .allorderlist
                                                .value
                                                .data!
                                                .orders
                                                .isNotEmpty
                                            ? SizedBox()
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/empty.png",
                                                      height: 80,
                                                    ),
                                                    KText(
                                                      text: languagesController
                                                          .tr("NO_DATA_FOUND"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      )
                                    : SizedBox(),
                              ),
                              Expanded(
                                child: Obx(
                                  () =>
                                      orderlistController.isLoading.value ==
                                              false &&
                                          orderlistController
                                              .finalList
                                              .isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: RefreshIndicator(
                                            onRefresh: refresh,
                                            child: ListView.separated(
                                              controller: scrollController,
                                              padding: EdgeInsets.all(0),
                                              separatorBuilder:
                                                  (context, index) {
                                                    return const SizedBox(
                                                      height: 10,
                                                    );
                                                  },
                                              physics:
                                                  AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: false,
                                              itemCount: orderlistController
                                                  .finalList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final data = orderlistController
                                                    .finalList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => OrderDetailsScreen(
                                                          createDate: data
                                                              .createdAt
                                                              .toString(),
                                                          status: data.status
                                                              .toString(),
                                                          rejectReason: data
                                                              .rejectReason
                                                              .toString(),
                                                          companyName: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          bundleTitle: data
                                                              .bundle!
                                                              .bundleTitle!
                                                              .toString(),
                                                          rechargebleAccount: data
                                                              .rechargebleAccount!
                                                              .toString(),
                                                          validityType: data
                                                              .bundle!
                                                              .validityType!
                                                              .toString(),
                                                          sellingPrice: data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                          buyingPrice: data
                                                              .bundle!
                                                              .buyingPrice
                                                              .toString(),
                                                          orderID: data.id!
                                                              .toString(),
                                                          resellerName:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .contactName
                                                                  .toString(),
                                                          resellerPhone:
                                                              dashboardController
                                                                  .alldashboardData
                                                                  .value
                                                                  .data!
                                                                  .userInfo!
                                                                  .phone
                                                                  .toString(),
                                                          companyLogo: data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: screenWidth,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFEAE5ED,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                            12,
                                                            10,
                                                            12,
                                                            10,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 34,
                                                                height: 34,
                                                                decoration: BoxDecoration(
                                                                  color: _statusBg(
                                                                    data.status
                                                                        .toString(),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        11,
                                                                      ),
                                                                ),
                                                                child: Icon(
                                                                  data.status.toString() ==
                                                                          "0"
                                                                      ? Icons
                                                                            .schedule_rounded
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Icons
                                                                            .check_rounded
                                                                      : Icons.close_rounded,
                                                                  size: 17,
                                                                  color: _statusColor(
                                                                    data.status
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 9,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      data.rechargebleAccount
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            12.5,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Color(
                                                                          0xFF37313C,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Text(
                                                                      "${languagesController.tr("ORDER_ID")} #${data.id}",
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            9.5,
                                                                        color: Color(
                                                                          0xFF9A93A0,
                                                                        ),
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: _statusBg(
                                                                    data.status
                                                                        .toString(),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? languagesController.tr(
                                                                          "PENDING",
                                                                        )
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? languagesController.tr(
                                                                          "CONFIRMED",
                                                                        )
                                                                      : languagesController.tr(
                                                                          "REJECTED",
                                                                        ),
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        8.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: _statusColor(
                                                                      data.status
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          const SizedBox(
                                                            height: 8,
                                                          ),

                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: _compactInfo(
                                                                  icon: Icons
                                                                      .calendar_today_rounded,
                                                                  label: languagesController
                                                                      .tr(
                                                                        "DATE",
                                                                      ),
                                                                  value:
                                                                      DateFormat(
                                                                        'dd MMM yy',
                                                                      ).format(
                                                                        DateTime.parse(
                                                                          data.createdAt
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 1,
                                                                height: 26,
                                                                color:
                                                                    const Color(
                                                                      0xFFF0ECF2,
                                                                    ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: _compactPrice(
                                                                  label:
                                                                      languagesController
                                                                          .tr(
                                                                            "BUY",
                                                                          ),
                                                                  value:
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
                                                                        decimalDigits:
                                                                            2,
                                                                      ).format(
                                                                        double.tryParse(
                                                                              data.bundle!.buyingPrice.toString(),
                                                                            ) ??
                                                                            0,
                                                                      ),
                                                                  currency:
                                                                      box.read(
                                                                        "currency_code",
                                                                      ) ??
                                                                      '',
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 1,
                                                                height: 26,
                                                                color:
                                                                    const Color(
                                                                      0xFFF0ECF2,
                                                                    ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: _compactPrice(
                                                                  label: languagesController
                                                                      .tr(
                                                                        "SELL",
                                                                      ),
                                                                  value:
                                                                      NumberFormat.currency(
                                                                        locale:
                                                                            'en_US',
                                                                        symbol:
                                                                            '',
                                                                        decimalDigits:
                                                                            2,
                                                                      ).format(
                                                                        double.tryParse(
                                                                              data.bundle!.sellingPrice.toString(),
                                                                            ) ??
                                                                            0,
                                                                      ),
                                                                  currency:
                                                                      box.read(
                                                                        "currency_code",
                                                                      ) ??
                                                                      '',
                                                                  highlight:
                                                                      true,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : orderlistController.finalList.isEmpty
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: const Color(0xFFFBF9FD),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        dashboardController.deactiveStatus.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        textAlign: TextAlign.center,
                        dashboardController.deactivateMessage.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  contentPadding: EdgeInsets.all(0),
                                  content: ContactDialogBox(),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 45,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/whatsapp.png",
                                  height: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                KText(
                                  text: languagesController.tr("CONTACTUS"),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                content: LogoutDialogBox(),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: Text(
                              languagesController.tr("LOGOUT"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DetailsDialog extends StatelessWidget {
  DetailsDialog({
    super.key,
    this.status,
    this.bundletitle,
    this.phoneNumber,
    this.sellingPrice,
    this.orderId,
    this.imagelink,
    this.date,
  });

  String? status;
  String? bundletitle;
  String? phoneNumber;
  String? sellingPrice;
  String? orderId;
  String? imagelink;
  String? date;

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();

  final GlobalKey catpureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .88,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          child: Column(
            children: [
              RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        color: status.toString() == "0"
                            ? Color(0xffFFC107)
                            : status.toString() == "1"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Background Image with Opacity
                              Opacity(
                                opacity:
                                    0.2, // Adjust the opacity value (0.0 to 1.0)
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icons/logo.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              // Foreground Container with Status Icon
                              Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(5.0),
                                child: Image.asset(
                                  status.toString() == "0"
                                      ? "assets/icons/pending.png"
                                      : status.toString() == "1"
                                      ? "assets/icons/successful.png"
                                      : "assets/icons/rejected.png",
                                  height: 60,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            status.toString() == "0"
                                ? languagesController.tr("PENDING")
                                : status.toString() == "1"
                                ? languagesController.tr("CONFIRMED")
                                : languagesController.tr("REJECTED"),
                            style: TextStyle(
                              color: status.toString() == "0"
                                  ? Color(0xffFFC107)
                                  : status.toString() == "1"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("BUNDLE_TITLE"),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                bundletitle.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("PHONENUMBER"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                phoneNumber.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("SELLING_PRICE"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                sellingPrice.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("ORDER_ID"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                orderId.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 65,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: status.toString() == "1"
                                  ? AppColors.secondaryColor
                                  : Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Image.network(imagelink.toString()),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("DATE"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToDate(date.toString()),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("TIME"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToLocalTime(
                                                date.toString(),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),
              Container(
                height: 45,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          capturePng(catpureKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SAVE_TO_GALLERY"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SHARE"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      languagesController.tr("CLOSE"),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
// ── Cell helpers (add inside your State class) ────────────────────────────────

Widget _compactInfo({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF9E97A4)),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 8.5, color: Color(0xFFA39CA8)),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF514A57),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _compactPrice({
  required String label,
  required String value,
  required String currency,
  bool highlight = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 8.5, color: Color(0xFFA39CA8)),
        ),
        const SizedBox(height: 1),
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: highlight
                      ? AppColors.primaryColor
                      : const Color(0xFF514A57),
                ),
              ),
              TextSpan(
                text: " $currency",
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA39CA8),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoCell({required String label, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 9.5, color: Color(0xFFA29BA7)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3D3743),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget _buildPriceCell({
  required String label,
  required String value,
  required String currency,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 9, color: Color(0xFFBBBBBB))),
      SizedBox(height: 2),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            TextSpan(
              text: " $currency",
              style: TextStyle(fontSize: 9, color: Color(0xFFBBBBBB)),
            ),
          ],
        ),
      ),
    ],
  );
}

// ── Status helpers (add inside your State class) ──────────────────────────────
Color _statusColor(String status) {
  if (status == "0") return Color(0xFFFFC107);
  if (status == "1") return Colors.green;
  return Color(0xFFE24B4A);
}

Color _statusBg(String status) {
  if (status == "0") return Color(0xFFFFF8E1);
  if (status == "1") return Color(0xFFE9F2ED);
  return Color(0xFFFEECEC);
}
