import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    hawalacurrencycontroller.fetchcurrency();
  }

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.goBack();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            "assets/icons/backicon.png",
                            height: 40,
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          languagesController.tr("HAWALA_RATES"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          CustomFullScreenSheet.show(context);
                        },
                        child: MenuiconWIdget(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Obx(
                () => hawalacurrencycontroller.isLoading.value == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: hawalacurrencycontroller
                                .allcurrencylist
                                .value
                                .data!
                                .rates!
                                .length,
                            itemBuilder: (context, index) {
                              final data = hawalacurrencycontroller
                                  .allcurrencylist
                                  .value
                                  .data!
                                  .rates![index];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Left accent bar
                                      Container(
                                        width: 4,
                                        color: AppColors.primaryColor,
                                      ),

                                      // Content
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Currency pair row
                                              Row(
                                                children: [
                                                  // From currency pill
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${data.amount}  ${data.fromCurrency!.name}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: 16,
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // To currency pill
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.08),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withOpacity(0.3),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      data.toCurrency!.name
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Divider(
                                                color: Colors.grey.shade100,
                                                thickness: 1,
                                                height: 1,
                                              ),
                                              const SizedBox(height: 12),

                                              // Buy + Sell row
                                              Row(
                                                children: [
                                                  // Buy rate
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFE9F2ED,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .arrow_downward_rounded,
                                                                color: Color(
                                                                  0xFF1D9E75,
                                                                ),
                                                                size: 13,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Obx(
                                                                () => Text(
                                                                  languagesController
                                                                      .tr(
                                                                        "BUYING",
                                                                      ),
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                      0xFF1D9E75,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            '${data.buyRate}  ${data.toCurrency!.symbol}',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFF1D9E75,
                                                                  ),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),

                                                  // Sell rate
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFFFF8E1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .arrow_upward_rounded,
                                                                color: Color(
                                                                  0xFFB8860B,
                                                                ),
                                                                size: 13,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Obx(
                                                                () => Text(
                                                                  languagesController
                                                                      .tr(
                                                                        "SELLING",
                                                                      ),
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                      0xFFB8860B,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            '${data.sellRate}  ${data.toCurrency!.symbol}',
                                                            style:
                                                                const TextStyle(
                                                                  color: Color(
                                                                    0xFFB8860B,
                                                                  ),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
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
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
