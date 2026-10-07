import 'dart:io'; // for exit(0)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:afghannet/services/dashboard_service.dart';
import 'package:afghannet/utils/colors.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import 'receipts_screen.dart';
import 'service_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());
  LanguagesController languagesController = Get.put(LanguagesController());

  final List<String> namesKeys = ["HOME", "TRANSACTIONS", "ORDERS", "NETWORK"];

  final List<String> imagedata = [
    "assets/icons/home.png",
    "assets/icons/transactiontype.png",
    "assets/icons/orders.png",
    "assets/icons/network.png",
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    mypagecontroller.setUpdateIndexCallback((index) {
      setState(() {
        selectedIndex = index;
      });
    });
  }

  // Future<bool> handleBackPressed() async {
  //   if (mypagecontroller.pageStack.length > 1) {
  //     mypagecontroller.goBack();
  //     return false; // just pop inner page
  //   }

  //   // root page reached → allow system to exit
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false, // 🔥 খুব গুরুত্বপূর্ণ
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (mypagecontroller.pageStack.length > 1) {
          mypagecontroller.goBack();
        } else {
          SystemNavigator.pop(); // ✅ Android 15 root exit
        }
      },
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          extendBody: true,
          body: mypagecontroller.pageStack.last,

          // ── FAB ───────────────────────────────────────────────────────────────────
          floatingActionButton: SizedBox(
            width: 56,
            height: 56,
            child: Transform.translate(
              offset: const Offset(0, 16),
              child: FloatingActionButton(
                onPressed: () {
                  if (dashboardController.deactiveStatus.value
                          .trim()
                          .toLowerCase() ==
                      "deactivated") {
                    Get.snackbar(
                      dashboardController.deactiveStatus.toString(),
                      dashboardController.deactivateMessage.toString(),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(12),
                      duration: const Duration(seconds: 1),
                      icon: const Icon(Icons.block, color: Colors.white),
                    );
                  } else {
                    mypagecontroller.changePage(
                      ReceiptsScreen(),
                      isMainPage: false,
                    );
                  }
                },
                backgroundColor: AppColors.primaryColor,
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          // ── Bottom nav ────────────────────────────────────────────────────────────
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...List.generate(imagedata.length, (index) {
                      final bool isSelected =
                          mypagecontroller.lastSelectedIndex == index;

                      return GestureDetector(
                        onTap: () =>
                            mypagecontroller.goToMainPageByIndex(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                imagedata[index],
                                width: 22,
                                height: 22,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                languagesController.tr(namesKeys[index]),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).asMap().entries.expand((entry) {
                      if (entry.key == 1) {
                        return [entry.value, const SizedBox(width: 48)];
                      }
                      return [entry.value];
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
