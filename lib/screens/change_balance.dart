import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/authtextfield.dart';

import '../controllers/change_balance_controller.dart';
import '../widgets/menuiconwidget.dart';

class ChangeBalance extends StatefulWidget {
  String? subID;

  ChangeBalance({super.key, this.subID});

  @override
  State<ChangeBalance> createState() => _ChangeBalanceState();
}

class _ChangeBalanceState extends State<ChangeBalance> {
  int _value = 1;

  final Mypagecontroller mypagecontroller = Get.find();

  final BalanceController balanceController = Get.put(BalanceController());

  final GetStorage box = GetStorage();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    balanceController.status.value = "credit";
  }

  Color get _activeColor =>
      _value == 1 ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A);

  Color get _activeBg =>
      _value == 1 ? const Color(0xFFEEF9F4) : const Color(0xFFFFF2F2);

  IconData get _activeIcon =>
      _value == 1 ? Icons.add_rounded : Icons.remove_rounded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  _buildTypeSelector(),

                  const SizedBox(height: 12),

                  _buildBalanceForm(),
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
            child: Text(
              languagesController.tr("CHANGE_BALANCE"),
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

  Widget _buildTypeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeTab(
              value: 1,
              icon: Icons.south_west_rounded,
              title: languagesController.tr("CREDIT"),
              color: const Color(0xFF1D9E75),
              background: const Color(0xFFEEF9F4),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: _buildTypeTab(
              value: 2,
              icon: Icons.north_east_rounded,
              title: languagesController.tr("DEBIT"),
              color: const Color(0xFFE24B4A),
              background: const Color(0xFFFFF2F2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab({
    required int value,
    required IconData icon,
    required String title,
    required Color color,
    required Color background,
  }) {
    final bool selected = _value == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (value == 1) {
            balanceController.status.value = "credit";
          } else {
            balanceController.status.value = "debit";
          }

          setState(() {
            _value = value;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? background : const Color(0xFFFAF8FC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? color.withOpacity(.25)
                  : const Color(0xFFF0ECF2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: selected ? color : const Color(0xFFE5E0E8),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: selected ? Colors.white : const Color(0xFFAAA3AF),
                ),
              ),

              const SizedBox(width: 7),

              Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? color : const Color(0xFF9A939F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceForm() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _activeBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_activeIcon, size: 18, color: _activeColor),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languagesController.tr("AMOUNT"),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF423B48),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _value == 1
                          ? languagesController.tr("CREDIT")
                          : languagesController.tr("DEBIT"),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: _activeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: Obx(
                  () => Authtextfield(
                    hinttext: languagesController.tr("ENTER_AMOUNT"),
                    controller: balanceController.amountController,
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Container(
                height: 50,
                constraints: const BoxConstraints(minWidth: 92),
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        "assets/icons/afghanistan.png",
                        width: 24,
                        height: 17,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Text(
                      box.read("currency_code") ?? '',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF68616E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Obx(
            () => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: balanceController.isLoading.value
                    ? null
                    : () {
                        if (balanceController.amountController.text.isEmpty ||
                            balanceController.status.value == '') {
                          Fluttertoast.showToast(
                            msg: languagesController.tr("ENTER_AMOUNT"),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        if (balanceController.status.value == "credit") {
                          balanceController.credit(widget.subID.toString());
                        } else {
                          balanceController.debit(widget.subID.toString());
                        }
                      },
                borderRadius: BorderRadius.circular(15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: balanceController.isLoading.value
                        ? const Color(0xFFD8D3DB)
                        : _activeColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: balanceController.isLoading.value
                        ? []
                        : [
                            BoxShadow(
                              color: _activeColor.withOpacity(.16),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      balanceController.isLoading.value == false
                          ? languagesController.tr("CONFIRMATION")
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
    );
  }
}
