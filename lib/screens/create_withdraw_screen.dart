import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/widgets/button_one.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/create_withdraw_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';

class CreateWithdrawScreen extends StatelessWidget {
  CreateWithdrawScreen({super.key});

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CreateWithdrawController createWithdrawController = Get.put(
    CreateWithdrawController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                children: [
                  _buildSectionCard(
                    icon: Icons.payments_outlined,
                    title: languagesController.tr("CREATE_NEW_WITHDRAW"),
                    child: Column(
                      children: [
                        _buildField(
                          title: languagesController.tr("AMOUNT"),
                          controller: createWithdrawController.amountController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("ACCOUNT_NAME"),
                          controller:
                              createWithdrawController.accountNameController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("ACCOUNT_NUMBER"),
                          controller:
                              createWithdrawController.accountNumberController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("BANK_NAME"),
                          controller:
                              createWithdrawController.bankNameController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("NOTES"),
                          controller: createWithdrawController.notesController,
                          fontFamily: fontFamily,
                          bottomSpace: 0,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildSectionCard(
                    icon: Icons.account_balance_outlined,
                    title: languagesController.tr("BANK_DETAILS"),
                    child: Column(
                      children: [
                        _buildField(
                          title: languagesController.tr("BANK_NAME"),
                          controller:
                              createWithdrawController.bankDetailNameController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("ACCOUNT_HOLDER_NAME"),
                          controller:
                              createWithdrawController.bankHolderNameController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("ACCOUNT_NUMBER"),
                          controller: createWithdrawController
                              .bankAccountNumberController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("IBAN"),
                          controller: createWithdrawController.ibanController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("BRANCH"),
                          controller: createWithdrawController.branchController,
                          fontFamily: fontFamily,
                        ),

                        _buildField(
                          title: languagesController.tr("SWIFT_CODE"),
                          controller:
                              createWithdrawController.swiftCodeController,
                          fontFamily: fontFamily,
                          bottomSpace: 0,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Obx(
                    () => DefaultButton(
                      buttonName:
                          createWithdrawController.isLoading.value == false
                          ? languagesController.tr("CREATE_NOW")
                          : languagesController.tr("PLEASE_WAIT"),
                      mycolor: AppColors.primaryColor,
                      onpressed: createWithdrawController.isLoading.value
                          ? null
                          : () {
                              createWithdrawController.createBankWithdraw();
                            },
                    ),
                  ),
                ],
              ),
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
              text: languagesController.tr("CREATE_NEW_WITHDRAW"),
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

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.07),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: AppColors.primaryColor),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF423B48),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  Widget _buildField({
    required String title,
    required TextEditingController controller,
    String? fontFamily,
    double bottomSpace = 14,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF615A67),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              fontFamily: fontFamily,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.012),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Authtextfield(controller: controller, hinttext: ""),
          ),
        ],
      ),
    );
  }
}
