import 'package:afghannet/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/only_service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/button_one.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final categorisListController = Get.find<CategorisListController>();

  final AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  final GetStorage box = GetStorage();

  List commissiontype = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 22),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                          languagesController.tr("AMOUNT"),
                          fontFamily,
                        ),

                        const SizedBox(height: 7),

                        Authtextfield(
                          hinttext: languagesController.tr("ENTER_AMOUNT"),
                          controller:
                              addSellingPriceController.amountController,
                        ),

                        const SizedBox(height: 16),

                        _buildLabel(
                          languagesController.tr("COMMISSION_TYPE"),
                          fontFamily,
                        ),

                        const SizedBox(height: 7),

                        _buildCommissionSelector(),

                        const SizedBox(height: 16),

                        _buildLabel(
                          languagesController.tr("SERVICE"),
                          fontFamily,
                        ),

                        const SizedBox(height: 7),

                        _buildServiceSelector(),

                        const SizedBox(height: 24),

                        Obx(
                          () => DefaultButton1(
                            height: 50,
                            width: screenWidth,
                            buttonName:
                                addSellingPriceController.isLoading.value ==
                                    false
                                ? languagesController.tr("CREATE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            onpressed: () {
                              if (addSellingPriceController
                                      .amountController
                                      .text
                                      .isNotEmpty &&
                                  addSellingPriceController
                                          .commissiontype
                                          .value !=
                                      "" &&
                                  addSellingPriceController
                                      .serviceidcontroller
                                      .text
                                      .isNotEmpty) {
                                addSellingPriceController.createnow();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Fill data",
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
              text: languagesController.tr("CREATE_SELLING_PRICE"),
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
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF615A67),
        fontFamily: fontFamily,
      ),
    );
  }

  Widget _buildCommissionSelector() {
    return GestureDetector(
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
                        addSellingPriceController.commitype.value =
                            commissiontype[index]["name"];

                        addSellingPriceController.commissiontype.value =
                            commissiontype[index]["value"];

                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8FC),
                          borderRadius: BorderRadius.circular(12),
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
                              child: Icon(
                                commissiontype[index]["value"] == "percentage"
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
          color: const Color(0xFFFAF8FC),
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
                  addSellingPriceController.commitype.value.toString(),
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
    );
  }

  Widget _buildServiceSelector() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => addSellingPriceController.catName.value != ''
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
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF8FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            addSellingPriceController.logolink.toString(),
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addSellingPriceController.serviceName
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
                                addSellingPriceController.catName.toString(),
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
                : Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8FC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEDE8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(.07),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.apps_rounded,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: Text(
                            languagesController.tr("SERVICE"),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8E8793),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  child: ServiceBox(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              width: 50,
              height: 50,
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
    );
  }
}

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final categorisListController = Get.find<CategorisListController>();

  final AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
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
                  addSellingPriceController.serviceidcontroller.text = data.id
                      .toString();

                  addSellingPriceController.catName.value = catName;

                  addSellingPriceController.logolink.value = data
                      .company!
                      .companyLogo
                      .toString();

                  addSellingPriceController.serviceName.value = data
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
