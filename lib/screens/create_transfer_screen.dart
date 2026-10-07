import 'package:afghannet/widgets/button.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/create_transfer_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/only_service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../utils/colors.dart';
import '../widgets/button_one.dart';

class CreateTransferScreen extends StatefulWidget {
  const CreateTransferScreen({super.key});

  @override
  State<CreateTransferScreen> createState() => _CreateTransferScreenState();
}

class _CreateTransferScreenState extends State<CreateTransferScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final CreateTransferController controller = Get.put(
    CreateTransferController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  final GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();

    controller.amountController.clear();

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    final totalEarning = dashboardController
        .alldashboardData
        .value
        .data!
        .userInfo!
        .totalearning
        .toString();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                        Text(
                          languagesController.tr("AMOUNT"),
                          style: TextStyle(
                            color: const Color(0xFF615A67),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamily,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Container(
                          height: 58,
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF8FC),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFEDE8F0)),
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
                                  Icons.payments_outlined,
                                  size: 17,
                                  color: AppColors.primaryColor,
                                ),
                              ),

                              const SizedBox(width: 9),

                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: controller.amountController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF403A46),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F1FC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(.10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 17,
                                  color: AppColors.primaryColor,
                                ),
                              ),

                              const SizedBox(width: 9),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      totalEarning,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      languagesController.tr("AMOUNT"),
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: const Color(0xFF958E9A),
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    controller.amountController.text =
                                        totalEarning;
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: KText(
                                      text: languagesController.tr("ALL"),
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Obx(
                          () => DefaultButton1(
                            height: 50,
                            width: screenWidth,
                            buttonName: controller.isLoading.value == false
                                ? languagesController.tr("CREATE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            onpressed: () {
                              if (controller.amountController.text.isNotEmpty) {
                                controller.createnow();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Fill data",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
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
              text: languagesController.tr("CREATE_TRANSFER_REQUEST"),
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
