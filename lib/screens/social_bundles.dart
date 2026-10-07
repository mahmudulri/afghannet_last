import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import 'package:afghannet/controllers/bundle_controller.dart';
import 'package:afghannet/controllers/confirm_pin_controller.dart';
import 'package:afghannet/controllers/country_list_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/controllers/service_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/helpers/price.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import 'country_selection.dart';

class SocialBundles extends StatefulWidget {
  const SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final serviceController = Get.find<ServiceController>();
  final confirmPinController = Get.find<ConfirmPinController>();
  final bundleController = Get.find<BundleController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  int selectedIndex = -1;
  int duration_selectedIndex = -1;

  final box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();

    confirmPinController.numberController.clear();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    bundleController.finalList.clear();
    bundleController.initialpage = 1;

    scrollController.addListener(refresh);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
        0;

    final int currentPage = bundleController.initialpage;

    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage = totalPages;
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final list = bundleController.finalList;

                        if (list.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              strokeWidth: 2.3,
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppColors.primaryColor,
                          onRefresh: refresh,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 3, bottom: 12),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            controller: scrollController,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final data = list[index];

                              return _buildBundleItem(
                                context,
                                data,
                                screenWidth,
                              );
                            },
                          ),
                        );
                      }),
                    ),

                    Obx(
                      () => bundleController.isLoading.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
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
              languagesController.tr("COMMUNICATION_PACKAGES"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildBundleItem(
    BuildContext context,
    dynamic data,
    double screenWidth,
  ) {
    final currency = box.read("currency_code") ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          box.write("bundleID", data.id.toString());

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: SocialdialogBox(
                companyname: data.service!.company!.companyName.toString(),
                title: data.bundleTitle,
                validity: data.validityType,
                buyingprice: data.buyingPrice,
                sellingprice: data.sellingPrice,
                imagelink: data.service!.company!.companyLogo.toString(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFFEDE8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.017),
                  blurRadius: 9,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF8FC),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFFEDE8F0)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: data.service!.company!.companyLogo.toString(),
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(strokeWidth: 1.2),
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.business_outlined,
                      size: 19,
                      color: Color(0xFFA39CA8),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.bundleTitle.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF332D38),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 27,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF9F4),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.north_east_rounded,
                                    size: 12,
                                    color: Color(0xFF1D9E75),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    languagesController.tr("SALE"),
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF65A58F),
                                    ),
                                  ),
                                  const Spacer(),
                                  PriceTextView(
                                    price: data.sellingPrice.toString(),
                                    textStyle: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF187D5E),
                                    ),
                                  ),
                                  Text(
                                    ' $currency',
                                    style: const TextStyle(
                                      fontSize: 7.5,
                                      color: Color(0xFF65A58F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 7),

                          Expanded(
                            child: Container(
                              height: 27,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4F4),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.south_west_rounded,
                                    size: 12,
                                    color: Color(0xFFE24B4A),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    languagesController.tr("BUY"),
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFB66B6B),
                                    ),
                                  ),
                                  const Spacer(),
                                  PriceTextView(
                                    price: data.buyingPrice.toString(),
                                    textStyle: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFB94242),
                                    ),
                                  ),
                                  Text(
                                    ' $currency',
                                    style: const TextStyle(
                                      fontSize: 7.5,
                                      color: Color(0xFFB66B6B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFFBBB4C0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  const SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  final String? companyname;
  final String? title;
  final String? validity;
  final String? buyingprice;
  final String? sellingprice;
  final String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  String selectedCode = "+93";

  final countrylistController = Get.find<CountryListController>();
  final confirmPinController = Get.find<ConfirmPinController>();

  final box = GetStorage();
  final FocusNode _focusNode = FocusNode();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .82,
      ),
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
      child: Obx(
        () => confirmPinController.isLoading.value == false
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.07),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(.16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(.10),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.imagelink.toString(),
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.business_outlined,
                                color: Color(0xFFA39CA8),
                              ),
                            ),
                          ),

                          const SizedBox(width: 11),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.companyname.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF342E39),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  widget.title.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.25,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF746D7A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4F4),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.south_west_rounded,
                                  size: 15,
                                  color: Color(0xFFE24B4A),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        languagesController.tr("BUY"),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFB66B6B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.buyingprice.toString(),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFFB94242),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${box.read("currency_code")}",
                                            style: const TextStyle(
                                              fontSize: 8.5,
                                              color: Color(0xFFB66B6B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF9F4),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.north_east_rounded,
                                  size: 15,
                                  color: Color(0xFF1D9E75),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        languagesController.tr("SALE"),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF65A58F),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.sellingprice.toString(),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF187D5E),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${box.read("currency_code")}",
                                            style: const TextStyle(
                                              fontSize: 8.5,
                                              color: Color(0xFF65A58F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEDE8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            color: AppColors.primaryColor,
                            size: 19,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: TextField(
                              controller: confirmPinController.numberController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: languagesController.tr("ENTER_ID"),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA39CA8),
                                  fontSize: 13,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF443E49),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 9),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEDE8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              maxLength: 4,
                              controller: confirmPinController.pinController,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: languagesController.tr("PIN"),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA39CA8),
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              if (confirmPinController
                                  .numberController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_ID"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              if (confirmPinController
                                  .pinController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_YOUR_PIN"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              print("ready for recharge...");

                              confirmPinController.placeOrder(context);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      .18,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    languagesController.tr("CONFIRMATION"),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
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
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE1DCE4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.close_rounded,
                                    color: Color(0xFF756E7B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    languagesController.tr("CANCEL"),
                                    style: const TextStyle(
                                      color: Color(0xFF756E7B),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                  height: 220,
                  width: 220,
                  child: Lottie.asset('assets/loties/recharge.json'),
                ),
              ),
      ),
    );
  }
}
