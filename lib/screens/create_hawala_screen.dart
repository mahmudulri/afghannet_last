import 'dart:io';

import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/button_one.dart';

class HawalaScreen extends StatefulWidget {
  const HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  final AddHawalaController addHawalaController = Get.put(
    AddHawalaController(),
  );

  final SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final BranchController branchController = Get.put(BranchController());

  final HawalaCurrencyController hawalaCurrencyController = Get.put(
    HawalaCurrencyController(),
  );

  final GetStorage box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;

  final pageController = Get.find<Mypagecontroller>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  @override
  void initState() {
    super.initState();

    hawalaCurrencyController.fetchcurrency();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    addHawalaController.amountController.clear();
    addHawalaController.currency.value = '';
    addHawalaController.finalAmount.value = '';
    conversationController.selectedCurrency.value = "";
    addHawalaController.senderNameController.clear();
    addHawalaController.receiverNameController.clear();
    addHawalaController.fatherNameController.clear();
    addHawalaController.idcardController.clear();
    addHawalaController.currencyID.value == "";
    addHawalaController.paidbyreceiver.value = "";
    addHawalaController.paidbysender.value = "";
    addHawalaController.branchId.value = "";
    addHawalaController.currency.value = "";
    addHawalaController.currency2.value = "";
    addHawalaController.branch.value = "";

    currencyController.fetchCurrencyList();
    branchController.fetchallbranch();

    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

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
                  Container(
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
                        _buildLabel(
                          languagesController.tr("SENDER_NAME"),
                          fontFamily,
                        ),
                        const SizedBox(height: 6),
                        Authtextfield(
                          hinttext: "",
                          controller: addHawalaController.senderNameController,
                        ),

                        const SizedBox(height: 14),

                        _buildLabel(
                          languagesController.tr("RECEIVER_NAME"),
                          fontFamily,
                        ),
                        const SizedBox(height: 6),
                        Authtextfield(
                          hinttext: "",
                          controller:
                              addHawalaController.receiverNameController,
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  hawalaCurrencyController.fetchcurrency();
                                },
                                child: _buildLabel(
                                  languagesController.tr("HAWALA_AMOUNT"),
                                  fontFamily,
                                ),
                              ),
                            ),
                            Text(
                              languagesController.tr("CURRENCY"),
                              style: TextStyle(
                                color: const Color(0xFF615A67),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF8FC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFEDE8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(.07),
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: const Icon(
                                        Icons.payments_outlined,
                                        size: 15,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}'),
                                          ),
                                        ],
                                        controller: addHawalaController
                                            .amountController,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF403A46),
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          final selected = addHawalaController
                                              .selectedRate
                                              .value;

                                          if (selected == null ||
                                              addHawalaController
                                                  .currency
                                                  .value
                                                  .isEmpty) {
                                            addHawalaController
                                                    .finalAmount
                                                    .value =
                                                "0.00";
                                            return;
                                          }

                                          double input =
                                              double.tryParse(
                                                addHawalaController
                                                    .amountController
                                                    .text
                                                    .trim(),
                                              ) ??
                                              0;

                                          double dAmount =
                                              double.tryParse(
                                                selected.amount?.toString() ??
                                                    "0",
                                              ) ??
                                              0;

                                          double sRate =
                                              double.tryParse(
                                                selected.sellRate?.toString() ??
                                                    "0",
                                              ) ??
                                              0;

                                          double result = 0;

                                          if (dAmount > 0 && sRate > 0) {
                                            result = (input / dAmount) * sRate;
                                          }

                                          addHawalaController
                                              .finalAmount
                                              .value = result.toStringAsFixed(
                                            2,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 9),

                            Expanded(
                              child: Obx(() {
                                final List<dynamic> rates =
                                    (hawalaCurrencyController
                                            .hawalafilteredcurrency
                                            .value
                                            .data
                                            ?.rates
                                        as List?) ??
                                    <dynamic>[];

                                double _toDouble(dynamic v) {
                                  if (v == null) return 0;
                                  return double.tryParse(v.toString()) ?? 0;
                                }

                                final bool langIsFa =
                                    box.read("language").toString() == "Fa";

                                final Map<String, dynamic> uniqueByToId = {};

                                for (final r in rates) {
                                  final String toId =
                                      ((r?.toCurrency?.id) ?? '').toString();

                                  if (toId.isEmpty) continue;

                                  uniqueByToId.putIfAbsent(toId, () => r);
                                }

                                final dropdownItems = uniqueByToId.entries
                                    .map<DropdownMenuItem<String>>((e) {
                                      final symbol =
                                          ((e.value?.toCurrency?.symbol) ?? '')
                                              .toString();

                                      return DropdownMenuItem<String>(
                                        value: e.key,
                                        child: Text(
                                          symbol,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF554E5B),
                                          ),
                                        ),
                                      );
                                    })
                                    .toList();

                                final currentValue =
                                    addHawalaController.currencyID.value;

                                final bool valueExists =
                                    currentValue.isNotEmpty &&
                                    uniqueByToId.containsKey(currentValue);

                                return Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFEDE8F0),
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment: !langIsFa
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    value: valueExists ? currentValue : null,
                                    items: dropdownItems,
                                    onChanged: (value) {
                                      if (value == null) return;

                                      final selectedRate = uniqueByToId[value];

                                      addHawalaController.currencyID.value =
                                          value;

                                      addHawalaController.currency.value =
                                          ((selectedRate?.toCurrency?.symbol) ??
                                                  '')
                                              .toString();

                                      addHawalaController.selectedRate.value =
                                          selectedRate;

                                      final input = _toDouble(
                                        addHawalaController
                                            .amountController
                                            .text
                                            .trim(),
                                      );

                                      final dAmount = _toDouble(
                                        selectedRate?.amount,
                                      );

                                      final sRate = _toDouble(
                                        selectedRate?.sellRate,
                                      );

                                      double result = 0;

                                      if (dAmount > 0 && sRate > 0) {
                                        result = (input / dAmount) * sRate;
                                      }

                                      addHawalaController.finalAmount.value =
                                          result.toStringAsFixed(2);
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF938C98),
                                      size: 20,
                                    ),
                                    hint: Text(
                                      addHawalaController.currency.value.isEmpty
                                          ? ''
                                          : addHawalaController.currency.value,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF756E7B),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Obx(
                          () => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withOpacity(.82),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    .15,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.14),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    addHawalaController.finalAmount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  box.read("currency_code") ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          languagesController.tr(
                            "FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE",
                          ),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.5,
                            height: 1.35,
                            fontFamily: fontFamily,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildLabel(
                          languagesController.tr("BRANCH"),
                          fontFamily,
                        ),

                        const SizedBox(height: 7),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _openBranchDialog(
                                context,
                                screenWidth,
                                fontFamily,
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Ink(
                              height: 52,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF8FC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFEDE8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        .07,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.account_tree_outlined,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Obx(
                                      () => Text(
                                        addHawalaController.branch.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF6F6875),
                                          fontFamily: fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF938C98),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Obx(
                          () => DefaultButton1(
                            buttonName:
                                addHawalaController.isLoading.value == false
                                ? languagesController.tr("CONFIRM_AND_SUBMIT")
                                : languagesController.tr("PLEASE_WAIT"),
                            height: 50,
                            width: double.maxFinite,
                            onpressed: () async {
                              if (addHawalaController
                                      .senderNameController
                                      .text
                                      .isNotEmpty &&
                                  addHawalaController
                                      .receiverNameController
                                      .text
                                      .isNotEmpty &&
                                  addHawalaController
                                      .amountController
                                      .text
                                      .isNotEmpty &&
                                  addHawalaController.branchId.value != "") {
                                print("All is ok............");

                                bool success = await addHawalaController
                                    .createhawala();

                                if (success) {
                                  Get.find<Mypagecontroller>().goBack();
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Enter All data",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
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
              text: languagesController.tr("CREATE_HAWALA"),
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

  Widget _buildLabel(String text, String? fontFamily) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF615A67),
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
      ),
    );
  }

  void _openBranchDialog(
    BuildContext context,
    double screenWidth,
    String? fontFamily,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: screenWidth,
            constraints: const BoxConstraints(maxHeight: 320),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9FD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEDE8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.10),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Obx(
              () => branchController.isLoading.value == false
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: branchController
                          .allbranch
                          .value
                          .data!
                          .hawalabranches!
                          .length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final data = branchController
                            .allbranch
                            .value
                            .data!
                            .hawalabranches![index];

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              addHawalaController.branch.value = data.name
                                  .toString();

                              addHawalaController.branchId.value = data.id
                                  .toString();

                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(13),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: const Color(0xFFEDE8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        .07,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.location_city_outlined,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      data.name.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF4B4451),
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: Color(0xFFB4ADB8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2.2,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
