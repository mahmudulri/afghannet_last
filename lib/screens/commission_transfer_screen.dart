import 'package:afghannet/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../controllers/categories_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../controllers/transferlist_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/button.dart';
import 'create_transfer_screen.dart';

class CommissionTransferScreen extends StatefulWidget {
  const CommissionTransferScreen({super.key});

  @override
  State<CommissionTransferScreen> createState() =>
      _CommissionTransferScreenState();
}

class _CommissionTransferScreenState extends State<CommissionTransferScreen> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final TransferlistController transferlistController = Get.put(
    TransferlistController(),
  );

  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );

  final GetStorage box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();

  final categorisListController = Get.find<CategorisListController>();

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  @override
  void initState() {
    super.initState();

    transferlistController.fetchdata();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();

    if (value == "pending") {
      return const Color(0xFFE6A700);
    }

    if (value == "completed" || value == "approved" || value == "confirmed") {
      return const Color(0xFF1D9E75);
    }

    return const Color(0xFFE24B4A);
  }

  Color _statusBg(String status) {
    final value = status.toLowerCase();

    if (value == "pending") {
      return const Color(0xFFFFF8E8);
    }

    if (value == "completed" || value == "approved" || value == "confirmed") {
      return const Color(0xFFEEF9F4);
    }

    return const Color(0xFFFFF2F2);
  }

  IconData _statusIcon(String status) {
    final value = status.toLowerCase();

    if (value == "pending") {
      return Icons.schedule_rounded;
    }

    if (value == "completed" || value == "approved" || value == "confirmed") {
      return Icons.check_circle_outline_rounded;
    }

    return Icons.cancel_outlined;
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
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            _buildSearchCreateRow(screenWidth, fontFamily),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Obx(() {
                  if (transferlistController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2.3,
                      ),
                    );
                  }

                  final requests = transferlistController
                      .alltransferlist
                      .value
                      .data!
                      .requests!;

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 2, bottom: 18),
                    itemCount: requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final data = requests[index];

                      return _buildTransferCard(
                        data: data,
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
            child: KText(
              text: languagesController.tr("TRANSFER_COMISSION"),
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

  Widget _buildSearchCreateRow(double screenWidth, String? fontFamily) {
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
                  CreateTransferScreen(),
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

  Widget _buildTransferCard({
    required dynamic data,
    required String? fontFamily,
  }) {
    final status = data.status.toString();

    final bool hasNotes =
        data.adminNotes.toString() != "null" &&
        data.adminNotes.toString().trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusBg(status),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _statusIcon(status),
              size: 19,
              color: _statusColor(status),
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
                        languagesController.tr("AMOUNT"),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF96909B),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBg(status),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: _statusColor(status),
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  data.amount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),

                if (hasNotes) ...[
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8FC),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: const Color(0xFFF0ECF2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 13,
                          color: Color(0xFF9C95A1),
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languagesController.tr("NOTES"),
                                style: const TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9A939F),
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                data.adminNotes.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF514A57),
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
