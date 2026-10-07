import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/menuiconwidget.dart';

class CommissionGroupScreen extends StatefulWidget {
  const CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final GetStorage box = GetStorage();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CommissionGroupController commissionlistController =
      Get.find<CommissionGroupController>();

  final Mypagecontroller mypagecontroller = Get.find();

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

    commissionlistController.fetchGrouplist();
  }

  @override
  Widget build(BuildContext context) {
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

            _buildSearchCreate(fontFamily),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                if (commissionlistController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.3,
                    ),
                  );
                }

                final groups =
                    commissionlistController.allgrouplist.value.data!.groups!;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 2, 14, 18),
                  physics: const BouncingScrollPhysics(),
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final data = groups[index];

                    final isPercentage =
                        data.commissionType.toString() == "percentage";

                    return _buildGroupCard(
                      data: data,
                      isPercentage: isPercentage,
                      fontFamily: fontFamily,
                    );
                  },
                );
              }),
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
              languagesController.tr("COMMISSION_GROUP"),
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

  Widget _buildSearchCreate(String? fontFamily) {
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
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CreateGroupBox(),
                  ),
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

  Widget _buildGroupCard({
    required dynamic data,
    required bool isPercentage,
    required String? fontFamily,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(.07),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.groupName.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF332D38),
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
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
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Container(
            constraints: const BoxConstraints(minWidth: 72),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  languagesController.tr("AMOUNT"),
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9B94A0),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  data.amount.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateGroupBox extends StatefulWidget {
  const CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final GetStorage box = GetStorage();

  final AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final fontFamily = box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(16),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.group_add_outlined,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    languagesController.tr("COMMISSION_GROUP"),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: const Color(0xFF342E39),
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildLabel(languagesController.tr("GROUP_NAME"), fontFamily),

            const SizedBox(height: 6),

            Authtextfield(
              hinttext: languagesController.tr("ENTER_GROUP_NAME"),
              controller: addCommsionGroupController.nameController,
            ),

            const SizedBox(height: 14),

            _buildLabel(languagesController.tr("COMMISSION_TYPE"), fontFamily),

            const SizedBox(height: 6),

            _buildCommissionSelector(),

            const SizedBox(height: 14),

            _buildLabel(languagesController.tr("AMOUNT"), fontFamily),

            const SizedBox(height: 6),

            Authtextfield(
              hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: addCommsionGroupController.amountController,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      addCommsionGroupController.amountController.clear();

                      addCommsionGroupController.nameController.clear();

                      addCommsionGroupController.commissiontype.value = "";

                      addCommsionGroupController.commitype.value = "";

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE1DCE4)),
                      ),
                      child: Center(
                        child: Text(
                          languagesController.tr("CANCEL"),
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF756E7B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      if (addCommsionGroupController
                              .nameController
                              .text
                              .isNotEmpty &&
                          addCommsionGroupController
                              .amountController
                              .text
                              .isNotEmpty &&
                          addCommsionGroupController.commissiontype.value !=
                              "") {
                        addCommsionGroupController.createnow();
                      }
                    },
                    child: Obx(
                      () => Container(
                        height: 48,
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
                        child: Center(
                          child: Text(
                            addCommsionGroupController.isLoading.value == false
                                ? languagesController.tr("CREATE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
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
                  return GestureDetector(
                    onTap: () {
                      addCommsionGroupController.commitype.value =
                          commissiontype[index]["name"];

                      addCommsionGroupController.commissiontype.value =
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
                            child: const Icon(
                              Icons.percent_rounded,
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
                Icons.percent_rounded,
                size: 14,
                color: AppColors.primaryColor,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Obx(
                () => Text(
                  addCommsionGroupController.commitype.value.toString(),
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
}
