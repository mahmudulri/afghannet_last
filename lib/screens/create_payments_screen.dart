import 'dart:io';

import 'package:afghannet/widgets/button.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/add_payment_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/payment_method_controller.dart';
import '../controllers/payment_type_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/button_one.dart';
import '../widgets/menuiconwidget.dart';

class CreatePaymentsScreen extends StatefulWidget {
  const CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  final SignInController signInController = Get.put(SignInController());
  final CurrencyController currencyController = Get.put(CurrencyController());
  final PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );
  final PaymentTypeController paymentTypeController = Get.put(
    PaymentTypeController(),
  );
  final AddPaymentController addPaymentController = Get.put(
    AddPaymentController(),
  );
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GetStorage box = GetStorage();

  late Rx<DateTime?> mydate;

  final selectedMethod = "".obs;
  final selectedType = "".obs;
  final selectedcurrency = "".obs;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    mydate = Rx<DateTime?>(now);

    addPaymentController.selectedDate.value = DateFormat(
      'yyyy-MM-dd',
    ).format(now);

    paymentMethodController.fetchmethods();
    currencyController.fetchCurrencyList();
    paymentTypeController.fetchtypes();

    selectedcurrency.value = box.read("currency_code")?.toString() ?? '';
    addPaymentController.currencyID.value =
        box.read("countryID")?.toString() ?? '';

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

  Future<void> pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mydate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF322C37),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      mydate.value = picked;
      addPaymentController.selectedDate.value = DateFormat(
        'yyyy-MM-dd',
      ).format(picked);
    }
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                          color: Colors.black.withOpacity(.02),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(languagesController.tr("PAYMENT_METHOD")),
                        const SizedBox(height: 7),

                        _buildSelector(
                          valueObs: selectedMethod,
                          icon: Icons.account_balance_wallet_outlined,
                          onTap: () {
                            _showPaymentMethodDialog(context, screenWidth);
                          },
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _label(languagesController.tr("AMOUNT")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: _label(languagesController.tr("CURRENCY")),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
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
                                    const Icon(
                                      Icons.payments_outlined,
                                      size: 18,
                                      color: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: addPaymentController
                                            .amountController,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}'),
                                          ),
                                        ],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3E3844),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(
                                            color: const Color(0xFFA49DA9),
                                            fontSize: 13,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              flex: 2,
                              child: _buildSelector(
                                valueObs: selectedcurrency,
                                icon: Icons.currency_exchange_rounded,
                                onTap: () {
                                  _showCurrencyDialog(context, screenWidth);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        _label(languagesController.tr("PAYMENT_DATE")),
                        const SizedBox(height: 7),

                        GestureDetector(
                          onTap: () => pickStartDate(context),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF8FC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFEDE8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      addPaymentController.selectedDate.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF5B5561),
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFFAAA3AF),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        _label(languagesController.tr("TRACKING_CODE")),
                        const SizedBox(height: 7),

                        Authtextfield(
                          hinttext: "",
                          controller:
                              addPaymentController.trackingCodeController,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            _label(languagesController.tr("NOTES")),
                            const SizedBox(width: 6),
                            Text(
                              "(${languagesController.tr("OPTIONAL")})",
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFFA39CA8),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        Authtextfield(
                          hinttext: "",
                          controller: addPaymentController.noteController,
                        ),

                        const SizedBox(height: 15),

                        _label(languagesController.tr("PAYMENT_TYPE")),
                        const SizedBox(height: 7),

                        _buildSelector(
                          valueObs: selectedType,
                          icon: Icons.swap_horiz_rounded,
                          onTap: () {
                            _showPaymentTypeDialog(context, screenWidth);
                          },
                        ),

                        const SizedBox(height: 16),

                        _label(languagesController.tr("UPLOAD_IMAGES")),
                        const SizedBox(height: 9),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_ONE"),
                                addPaymentController.paymentImagePath,
                                () => addPaymentController.pickImage("payment"),
                              ),
                              const SizedBox(width: 10),
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_TOW"),
                                addPaymentController.extraImage1Path,
                                () => addPaymentController.pickImage("extra1"),
                              ),
                              const SizedBox(width: 10),
                              buildImageUploaderBox(
                                context,
                                languagesController.tr("IMAGE_THREE"),
                                addPaymentController.extraImage2Path,
                                () => addPaymentController.pickImage("extra2"),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Obx(
                          () => DefaultButton1(
                            height: 50,
                            width: screenWidth,
                            buttonName:
                                addPaymentController.isLoading.value == false
                                ? languagesController.tr("ADD_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            onpressed: () {
                              if (addPaymentController
                                      .payment_method_id
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .amountController
                                      .text
                                      .isEmpty ||
                                  addPaymentController
                                      .currencyID
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .selectedDate
                                      .value
                                      .isEmpty ||
                                  addPaymentController
                                      .trackingCodeController
                                      .text
                                      .isEmpty) {
                                Fluttertoast.showToast(
                                  msg:
                                      "Please fill all required fields correctly",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                addPaymentController.addNow();
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

          const SizedBox(width: 12),

          Expanded(
            child: KText(
              text: languagesController.tr("ADD_NEW_RECEIPT"),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF5C5562),
      ),
    );
  }

  Widget _buildSelector({
    required RxString valueObs,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEDE8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(
                () => Text(
                  valueObs.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B5561),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFA39CA8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .72,
            ),
            padding: const EdgeInsets.all(14),
            child: Obx(
              () => paymentMethodController.isLoading.value == false
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: paymentMethodController
                          .allmethods
                          .value
                          .data!
                          .paymentMethods!
                          .length,
                      itemBuilder: (context, index) {
                        final data = paymentMethodController
                            .allmethods
                            .value
                            .data!
                            .paymentMethods![index];

                        return GestureDetector(
                          onTap: () {
                            addPaymentController.payment_method_id.value = data
                                .id
                                .toString();

                            selectedMethod.value = data.methodName.toString();

                            Navigator.pop(dialogContext);
                          },
                          child: PaymentMethodBox(
                            methodName: data.methodName,
                            bankName: data.bankName,
                            holderName: data.accountHolderName,
                            cardNumber: data.cardNumber,
                            accountNumber: data.accountNumber,
                            sebaNumber: data.shebaNumber,
                            details: data.accountDetails,
                            imagelink: data.accountImage,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 320),
            padding: const EdgeInsets.all(14),
            child: Obx(
              () => currencyController.isLoading.value == false
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: currencyController
                          .allcurrencylist
                          .value
                          .data!
                          .currencies!
                          .length,
                      separatorBuilder: (_, __) => const SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final data = currencyController
                            .allcurrencylist
                            .value
                            .data!
                            .currencies![index];

                        final isSelected =
                            selectedcurrency.value == data.code.toString();

                        return GestureDetector(
                          onTap: () {
                            addPaymentController.currencyID.value = data.id
                                .toString();

                            selectedcurrency.value = data.code.toString();

                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(.07)
                                  : const Color(0xFFFAF8FC),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor.withOpacity(.25)
                                    : const Color(0xFFEDE8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  data.symbol.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    data.code.toString(),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4E4854),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 19,
                                    color: AppColors.primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showPaymentTypeDialog(BuildContext context, double screenWidth) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 260),
            padding: const EdgeInsets.all(14),
            child: Obx(
              () => paymentTypeController.isLoading.value == false
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: paymentTypeController
                          .alltypes
                          .value
                          .data!
                          .paymentTypes!
                          .length,
                      separatorBuilder: (_, __) => const SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final data = paymentTypeController
                            .alltypes
                            .value
                            .data!
                            .paymentTypes![index];

                        final isSelected =
                            selectedType.value == data.name.toString();

                        return GestureDetector(
                          onTap: () {
                            addPaymentController.payment_type_id.value = data.id
                                .toString();

                            selectedType.value = data.name.toString();

                            Navigator.pop(dialogContext);
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(.07)
                                  : const Color(0xFFFAF8FC),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor.withOpacity(.25)
                                    : const Color(0xFFEDE8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.name.toString(),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4E4854),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 19,
                                    color: AppColors.primaryColor,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildImageUploaderBox(
  BuildContext context,
  String label,
  RxString imagePath,
  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 116,
            height: 104,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8FC),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFEDE8F0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath.value.isNotEmpty
                ? Image.file(
                    File(imagePath.value),
                    width: 116,
                    height: 104,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.08),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF8E8794),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => imagePath.value = '',
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.58),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class PaymentMethodBox extends StatelessWidget {
  PaymentMethodBox({
    super.key,
    this.methodName,
    this.bankName,
    this.holderName,
    this.cardNumber,
    this.accountNumber,
    this.sebaNumber,
    this.details,
    this.imagelink,
  });

  String? methodName;
  String? bankName;
  String? holderName;
  String? cardNumber;
  String? accountNumber;
  String? sebaNumber;
  String? details;
  String? imagelink;

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cardNumber != null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDE8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    methodName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3B3541),
                    ),
                  ),
                ),

                if (imagelink != null && imagelink!.isNotEmpty)
                  Container(
                    width: 46,
                    height: 34,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8FC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                    ),
                    child: Image.network(
                      imagelink!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image_outlined,
                        size: 17,
                        color: Color(0xFFB7B0BC),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 11),

            _copyRow(
              label: languagesController.tr("CARD_NUMBER"),
              value: cardNumber.toString(),
              onCopy: () => _copy(cardNumber!, 'Card number'),
            ),

            const SizedBox(height: 8),

            _copyRow(
              label: languagesController.tr("ACCOUNT_NUMBER"),
              value: accountNumber.toString(),
              onCopy: () => _copy(accountNumber!, 'Account number'),
            ),

            const SizedBox(height: 10),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF1EDF3)),

            const SizedBox(height: 10),

            _infoRow(
              languagesController.tr("HOLDER_NAME"),
              holderName.toString(),
            ),

            const SizedBox(height: 6),

            _infoRow(languagesController.tr("BANK_NAME"), bankName.toString()),

            if (sebaNumber != null) ...[
              const SizedBox(height: 6),
              _infoRow(
                languagesController.tr("SEBA_NUMBER"),
                sebaNumber.toString(),
              ),
            ],

            if (details != null && details!.isNotEmpty) ...[
              const SizedBox(height: 6),
              _infoRow(
                languagesController.tr("DETAILS"),
                details.toString(),
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copy(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));

    Get.snackbar(
      'Copied',
      '$label copied',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  Widget _copyRow({
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF99929F),
              fontWeight: FontWeight.w500,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3C3642),
              ),
            ),
          ),

          GestureDetector(
            onTap: onCopy,
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.copy_rounded,
                size: 13,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF99929F),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C3642),
            ),
          ),
        ),
      ],
    );
  }
}
