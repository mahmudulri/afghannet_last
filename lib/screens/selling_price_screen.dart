import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/controllers/update_selling_price_controller.dart';
import 'package:afghannet/widgets/authtextfield.dart';

import '../controllers/categories_controller.dart';
import '../controllers/delete_selling_price_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../utils/colors.dart';
import '../widgets/button.dart';
import '../widgets/menuiconwidget.dart';
import 'create_selling_price_screen.dart';

class SellingPriceScreen extends StatefulWidget {
  const SellingPriceScreen({super.key});

  @override
  State<SellingPriceScreen> createState() => _SellingPriceScreenState();
}

class _SellingPriceScreenState extends State<SellingPriceScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );

  final UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
  );

  final GetStorage box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();

  final categorisListController = Get.find<CategorisListController>();

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    categorisListController.fetchcategories();
    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

            const SizedBox(height: 8),

            _buildSearchCreateSection(screenWidth, fontFamily),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Obx(() {
                  if (sellingPriceController.isLoading.value ||
                      serviceController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2.3,
                      ),
                    );
                  }

                  final pricings =
                      sellingPriceController.allpricelist.value.data!.pricings!;

                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 2, bottom: 18),
                    physics: const BouncingScrollPhysics(),
                    itemCount: pricings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final data = pricings[index];

                      final service = serviceController
                          .allservices
                          .value
                          .data!
                          .services
                          .firstWhere(
                            (s) => s.id.toString() == data.serviceId.toString(),
                          );

                      final categoryName = categorisListController
                          .allcategorieslist
                          .value
                          .data!
                          .servicecategories!
                          .firstWhere(
                            (cat) =>
                                cat.id.toString() ==
                                data.service!.serviceCategoryId.toString(),
                            orElse: () => Servicecategory(categoryName: ''),
                          )
                          .categoryName
                          .toString();

                      final isPercentage =
                          data.commissionType.toString() == "percentage";

                      return _buildPricingCard(
                        context: context,
                        data: data,
                        service: service,
                        categoryName: categoryName,
                        isPercentage: isPercentage,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        fontFamily: fontFamily,
                      );
                    },
                  );
                }),
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
            child: Text(
              languagesController.tr("SELLING_PRICE"),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xFF2E2833),
              ),
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

  Widget _buildSearchCreateSection(double screenWidth, String? fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEDE8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: Color(0xFFA39CA8),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF5F5865),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: languagesController.tr("SEARCH"),
                        hintStyle: TextStyle(
                          color: const Color(0xFFA39CA8),
                          fontSize: 12.5,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 9),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                mypagecontroller.changePage(
                  CreateSellingPriceScreen(),
                  isMainPage: false,
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      languagesController.tr("CREATE_NEW"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required BuildContext context,
    required dynamic data,
    required dynamic service,
    required String categoryName,
    required bool isPercentage,
    required double screenWidth,
    required double screenHeight,
    required String? fontFamily,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 10, 10),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE8F0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                service.company!.companyLogo.toString(),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.business_outlined,
                  size: 19,
                  color: Color(0xFFA39CA8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.company!.companyName.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF332D38),
                        ),
                      ),
                    ),

                    const SizedBox(width: 7),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.07),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isPercentage
                            ? const Color(0xFFFFF8E8)
                            : const Color(0xFFEEF9F4),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPercentage
                                ? Icons.percent_rounded
                                : Icons.payments_outlined,
                            size: 12,
                            color: isPercentage
                                ? const Color(0xFFB28A24)
                                : const Color(0xFF1D9E75),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPercentage
                                ? languagesController.tr("PERCENTAGE")
                                : languagesController.tr("FIXED"),
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: isPercentage
                                  ? const Color(0xFFB28A24)
                                  : const Color(0xFF1D9E75),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Text(
                      languagesController.tr("AMOUNT"),
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9A939F),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F1FC),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        data.amount.toString(),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(
                icon: Icons.edit_rounded,
                color: AppColors.primaryColor,
                background: const Color(0xFFF7F1FC),
                onTap: () {
                  updateSellingPriceController.amountController.text = data
                      .amount
                      .toString();

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
                      content: _buildEditDialog(
                        context,
                        data,
                        screenWidth,
                        screenHeight,
                        fontFamily,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 7),

              _actionButton(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFE24B4A),
                background: const Color(0xFFFFF2F2),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                      content: DeleteDialog(priceID: data.id.toString()),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
      ),
    );
  }

  Widget _buildEditDialog(
    BuildContext context,
    dynamic data,
    double screenWidth,
    double screenHeight,
    String? fontFamily,
  ) {
    return Container(
      width: screenWidth,
      constraints: BoxConstraints(maxHeight: screenHeight * .80),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  languagesController.tr("SELLING_PRICE"),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF342E39),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            languagesController.tr("AMOUNT"),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF615A67),
              fontFamily: fontFamily,
            ),
          ),

          const SizedBox(height: 6),

          Authtextfield(
            hinttext: languagesController.tr("ENTER_AMOUNT"),
            controller: updateSellingPriceController.amountController,
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(commissiontype.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == commissiontype.length - 1 ? 0 : 7,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              updateSellingPriceController.commitype.value =
                                  commissiontype[index]["name"];

                              updateSellingPriceController
                                      .commissiontype
                                      .value =
                                  commissiontype[index]["value"];

                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF8FC),
                                borderRadius: BorderRadius.circular(12),
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
                                      color: AppColors.primaryColor.withOpacity(
                                        .07,
                                      ),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Icon(
                                      commissiontype[index]["value"] ==
                                              "percentage"
                                          ? Icons.percent_rounded
                                          : Icons.payments_outlined,
                                      size: 14,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      commissiontype[index]["name"],
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF514A57),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEDE8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      size: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Obx(
                      () => Text(
                        updateSellingPriceController.commitype.value.toString(),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF615A67),
                        ),
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF9D96A2),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 13),

          Text(
            languagesController.tr("SERVICE"),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF615A67),
              fontFamily: fontFamily,
            ),
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => updateSellingPriceController.catName.value != ''
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEDE8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF8FC),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Image.network(
                                  updateSellingPriceController.logolink
                                      .toString(),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      updateSellingPriceController.serviceName
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF423B48),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      updateSellingPriceController.catName
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF938C98),
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

              const SizedBox(width: 8),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        insetPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: UpdateServiceBox(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF8E8793),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Obx(
            () => DefaultButton1(
              height: 50,
              width: screenWidth,
              buttonName: updateSellingPriceController.isLoading.value == false
                  ? languagesController.tr("UPDATE_NOW")
                  : languagesController.tr("PLEASE_WAIT"),
              onpressed: () {
                if (updateSellingPriceController
                        .amountController
                        .text
                        .isNotEmpty &&
                    updateSellingPriceController.commissiontype.value != "" &&
                    updateSellingPriceController
                        .serviceidcontroller
                        .text
                        .isNotEmpty) {
                  updateSellingPriceController.updatenow(data.id.toString());
                } else {
                  Fluttertoast.showToast(
                    msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
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
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, this.priceID});

  String? priceID;

  final DeleteSellingPriceController controller = Get.put(
    DeleteSellingPriceController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFE24B4A),
              size: 24,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            languagesController.tr("DO_YOU_WANT_TO_DELETE"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF403A46),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteprice(priceID.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24B4A),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          controller.isLoading.value == false
                              ? languagesController.tr("YES")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: const Color(0xFFE1DCE4)),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("NO"),
                        style: const TextStyle(
                          color: Color(0xFF756E7B),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
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
    );
  }
}

class UpdateServiceBox extends StatelessWidget {
  UpdateServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final categorisListController = Get.find<CategorisListController>();

  final UpdateSellingPriceController updateSellingPriceController = Get.put(
    UpdateSellingPriceController(),
  );

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 500,
        width: screenWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9FD),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEDE8F0)),
        ),
        child: Obx(() {
          if (serviceController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2.2,
              ),
            );
          }

          final services = serviceController.allservices.value.data!.services;

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: .86,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final data = services[index];

              final catName = categorisListController
                  .allcategorieslist
                  .value
                  .data!
                  .servicecategories!
                  .firstWhere(
                    (cat) =>
                        cat.id.toString() == data.serviceCategoryId.toString(),
                    orElse: () => Servicecategory(categoryName: ''),
                  )
                  .categoryName
                  .toString();

              return GestureDetector(
                onTap: () {
                  updateSellingPriceController.serviceidcontroller.text = data
                      .id
                      .toString();

                  updateSellingPriceController.catName.value = catName;

                  updateSellingPriceController.logolink.value = data
                      .company!
                      .companyLogo
                      .toString();

                  updateSellingPriceController.serviceName.value = data
                      .company!
                      .companyName
                      .toString();

                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFEDE8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(
                          data.company!.companyLogo.toString(),
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        data.company!.companyName.toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF403A46),
                          fontFamily: fontFamily,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        catName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8.5,
                          color: const Color(0xFF938C98),
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
