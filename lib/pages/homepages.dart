import 'dart:async';
import 'package:afghannet/widgets/drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:afghannet/accounting/accounting_base.dart';
import 'package:afghannet/controllers/notifications_controller.dart';
import 'package:afghannet/models/country_list_model.dart';
import 'package:afghannet/pages/notification_details_page.dart';
import 'package:afghannet/screens/all_notifications_page.dart';
import 'package:afghannet/screens/financial_screen.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:afghannet/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/bundle_controller.dart';
import 'package:afghannet/controllers/confirm_pin_controller.dart';
import 'package:afghannet/controllers/country_list_controller.dart';
import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/screens/credit_transfer.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/custom_recharge_controller.dart';
import '../global_controller/balance_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/country_selection.dart';
import '../screens/service_screen.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import 'package:intl/intl.dart';
import '../widgets/menuiconwidget.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List mycolor = [
    const Color(0xffF4EBFC),
    const Color(0xffEEF1FF),
    const Color(0xffE9F5EF),
    const Color(0xffFFF2EC),
    const Color(0xffEAF8F8),
    const Color(0xffF5F9EB),
  ];

  final List<String> icons = [
    "assets/icons/sim.png",
    "assets/icons/social-bundles.png",
    "assets/icons/dataplan.png",
    "assets/icons/credit-transfer.png",
    "assets/icons/callsmsplan.png",
  ];

  DashboardController dashboardController = Get.put(DashboardController());
  final bundleController = Get.find<BundleController>();
  final box = GetStorage();
  final confirmPinController = Get.find<ConfirmPinController>();
  final NumberFormat _formatter = NumberFormat('#,##0');
  LanguagesController languagesController = Get.put(LanguagesController());
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  NotificationController notificationController = Get.put(
    NotificationController(),
  );

  final categorisListController = Get.find<CategorisListController>();
  final countryListController = Get.find<CountryListController>();

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  List<Map<String, String>> get items => [
    {
      'name': languagesController.tr("BALANCE"),
      'icon': 'assets/icons/balance2.png',
    },
    {'name': languagesController.tr("DEBIT"), 'icon': 'assets/icons/debit.png'},
    {
      'name': languagesController.tr("PROFIT"),
      'icon': 'assets/icons/profit2.png',
    },
    {
      'name': languagesController.tr("SALE"),
      'icon': 'assets/icons/profit2.png',
    },
    {
      'name': languagesController.tr("COMISSION"),
      'icon': 'assets/icons/profit2.png',
    },
  ];

  final ScrollController scrollController = ScrollController();
  final PageController _pageController = PageController();
  final Mypagecontroller mypagecontroller = Get.find();
  var currentIndex = 0.obs;

  final companyController = Get.find<CompanyController>();

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  @override
  void initState() {
    super.initState();

    _checkforUpdate();
    notificationController.fetchData();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    companyController.fetchCompany();
    countrylistController.fetchCountryData();
    dashboardController.fetchDashboardData();
    categorisListController.fetchcategories();
  }

  Future<void> _checkforUpdate() async {
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    await InAppUpdate.startFlexibleUpdate();

    InAppUpdate.completeFlexibleUpdate()
        .then((_) {})
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = DateFormat("dd MMM yyyy").format(DateTime.now());

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBF9FD),
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2.6,
            ),
          ),
        );
      }

      if (dashboardController.deactiveStatus.value.trim().toLowerCase() ==
          "deactivated") {
        return Scaffold(
          backgroundColor: const Color(0xFFFBF9FD),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.10),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.lock_person_rounded,
                          color: AppColors.primaryColor,
                          size: 31,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        dashboardController.deactiveStatus.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF24202A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dashboardController.deactivateMessage.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.55,
                          color: Color(0xFF8A8391),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                              contentPadding: EdgeInsets.zero,
                              content: ContactDialogBox(),
                            ),
                          ),
                          icon: Image.asset(
                            "assets/icons/whatsapp.png",
                            height: 22,
                            color: Colors.white,
                          ),
                          label: KText(
                            text: languagesController.tr("CONTACTUS"),
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: LogoutDialogBox(),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            languagesController.tr("LOGOUT"),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => dashboardController.fetchDashboardData(),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F3F8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 25,
                            color: Color(0xFF706A77),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const MyDrawer(),
          backgroundColor: const Color(0xFFFBF9FD),
          body: Column(
            children: [
              _buildTopBar(),

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    await dashboardController.fetchDashboardData();
                    await notificationController.fetchData();
                    await companyController.fetchCompany();
                    await countrylistController.fetchCountryData();
                    await categorisListController.fetchcategories();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 26),
                    child: Column(
                      children: [
                        _buildBanner(),

                        const SizedBox(height: 9),

                        _buildSliderDots(),

                        const SizedBox(height: 14),

                        _buildFinancialCard(
                          formattedDate: formattedDate,
                          screenWidth: screenWidth,
                        ),

                        const SizedBox(height: 14),

                        _buildAfghanistanRechargeButton(),

                        const SizedBox(height: 18),

                        _buildCategoriesGrid(screenHeight),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FD),
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor.withOpacity(.05)),
        ),
      ),
      child: Row(
        children: [
          Obx(() {
            final url = dashboardController
                .alldashboardData
                .value
                .data
                ?.userInfo
                ?.profileImageUrl;

            return Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(.10),
                ),
                image: (url != null && url.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (url == null || url.isEmpty)
                  ? const Icon(
                      Icons.person_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    )
                  : null,
            );
          }),

          const SizedBox(width: 11),

          Expanded(
            child: Obx(
              () => dashboardController.isLoading.value
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KText(
                          text: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .resellerName
                              .toString(),
                          color: const Color(0xFF28232E),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 2),
                        Visibility(
                          visible:
                              dashboardController
                                      .alldashboardData
                                      .value
                                      .data
                                      ?.resellerGroup !=
                                  null &&
                              dashboardController
                                      .alldashboardData
                                      .value
                                      .data!
                                      .resellerGroup !=
                                  "null",
                          child: Text(
                            dashboardController
                                    .alldashboardData
                                    .value
                                    .data
                                    ?.resellerGroup ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF938C9A),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          _buildNotificationButton(),

          const SizedBox(width: 8),

          _buildHeaderAction(
            onTap: () {
              Get.to(() => AccountingBaseScreen());
            },
            child: const Icon(
              Icons.account_balance_rounded,
              color: AppColors.primaryColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 8),

          _buildHeaderAction(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Center(child: MenuiconWIdget()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFEDE8F0)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Obx(() {
      final unreadCount = notificationController.unreadlength.value;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showNotificationPopup(context);
          },
          borderRadius: BorderRadius.circular(13),
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFEDE8F0)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF4B4552),
                  size: 23,
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: -4,
                    top: -5,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFBF9FD),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBanner() {
    return GestureDetector(
      onTap: () => companyController.fetchCompany(),
      child: Container(
        width: double.infinity,
        height: 148,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Obx(() {
            final sliderItems =
                dashboardController
                    .alldashboardData
                    .value
                    .data!
                    .advertisementSliders ??
                [];

            if (sliderItems.isEmpty) {
              return const SizedBox();
            }

            return PageView.builder(
              controller: _pageController,
              itemCount: sliderItems.length,
              onPageChanged: (i) => currentIndex.value = i,
              itemBuilder: (_, i) {
                return Image.network(
                  sliderItems[i].adSliderImageUrl ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFF0EDF2),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF9E98A4),
                      ),
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSliderDots() {
    return Obx(() {
      final sliderItems =
          dashboardController
              .alldashboardData
              .value
              .data!
              .advertisementSliders ??
          [];

      if (sliderItems.length <= 1) {
        return const SizedBox(height: 2);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          sliderItems.length,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: currentIndex.value == i ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentIndex.value == i
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(.15),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFinancialCard({
    required String formattedDate,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: () =>
          mypagecontroller.changePage(FinancialScreen(), isMainPage: false),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(.22),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.16),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      "assets/icons/wallet.png",
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languagesController.tr("FINANCIAL_REPORT"),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.white.withOpacity(.68),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Obx(
                    () => dashboardController.isLoading.value == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(
                                  double.tryParse(
                                        dashboardController
                                            .userBalanceController
                                            .balance
                                            .toString(),
                                      ) ??
                                      0,
                                ),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                box.read("currency_code") ?? '',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(.72),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildBottomStatNew(
                      label: languagesController.tr("BALANCE"),
                      icon: Icons.account_balance_wallet_outlined,
                      showBorder: true,
                    ),
                  ),
                  Expanded(
                    child: _buildBottomStatNew(
                      label: languagesController.tr("SEE_ALL"),
                      icon: Icons.arrow_forward_rounded,
                      showBorder: false,
                      isAction: true,
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

  Widget _buildAfghanistanRechargeButton() {
    return DefaultButton1(
      height: 52,
      buttonName: languagesController.tr("AFGHANISTAN_RECHARGE"),
      onpressed: () {
        Country? afghanistan;

        if (countryListController.finalCountryList.isNotEmpty) {
          try {
            afghanistan = countryListController.finalCountryList.firstWhere(
              (country) =>
                  country.countryName?.trim().toLowerCase() == "afghanistan",
            );
          } catch (e) {
            afghanistan = null;
          }

          if (afghanistan != null) {
            print("The ID for Afghanistan is: ${afghanistan.id}");

            box.write("country_id", afghanistan.id);

            box.write("countryName", afghanistan.countryName ?? "Afghanistan");

            box.write("maxlength", afghanistan.phoneNumberLength ?? "10");

            box.write(
              "enable_operator_lookup",
              afghanistan.enableOperatorLookup,
            );

            box.write("validity_type", "");
            box.write("company_id", "");
            box.write("search_tag", "");
          } else {
            print("Afghanistan not found in the country list.");
          }
        } else {
          print("Country list is empty.");
        }

        mypagecontroller.changePage(CreditTransfer(), isMainPage: false);
      },
    );
  }

  Widget _buildCategoriesGrid(double screenHeight) {
    return Obx(
      () => categorisListController.isLoading.value == false
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .88,
              ),
              itemCount: categorisListController
                  .allcategorieslist
                  .value
                  .data!
                  .servicecategories!
                  .length,
              itemBuilder: (context, index) {
                final data = categorisListController
                    .allcategorieslist
                    .value
                    .data!
                    .servicecategories![index];

                final color = mycolor[index % mycolor.length];
                final icon = icons[index % icons.length];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      box.write("service_category_id", data.id);

                      if (data.type.toString() == "nonsocial") {
                        mypagecontroller.changePage(
                          InternetPack(),
                          isMainPage: false,
                        );
                      } else {
                        box.write("validity_type", "");
                        box.write("search_tag", "");
                        box.write("service_category_id", data.id);
                        box.write("country_id", "");
                        box.write("company_id", "");

                        mypagecontroller.changePage(
                          ServiceScreen(),
                          isMainPage: false,
                        );
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEDE9F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.025),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: data.categoryImageUrl.toString() == "null"
                                ? Image.asset(icon, fit: BoxFit.contain)
                                : Image.network(
                                    data.categoryImageUrl.toString(),
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return Image.asset(
                                        icon,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              data.categoryName.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF49434F),
                                fontWeight: FontWeight.w700,
                                fontSize: screenHeight * 0.0138,
                                height: 1.25,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: 22,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(.22),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2.6,
              ),
            ),
    );
  }

  Widget _buildBottomStatNew({
    required String label,
    required IconData icon,
    required bool showBorder,
    bool isAction = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          right: showBorder
              ? BorderSide(color: Colors.white.withOpacity(.14), width: 1)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(.92)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isAction ? FontWeight.w700 : FontWeight.w600,
              color: Colors.white.withOpacity(.92),
            ),
          ),
        ],
      ),
    );
  }

  void showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (context) {
        return Dialog(
          alignment: Alignment.topRight,
          insetPadding: const EdgeInsets.only(
            top: 70,
            right: 15,
            left: 25,
            bottom: 30,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxHeight: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Obx(() {
              final isLoading = notificationController.isLoading.value;

              final notifications =
                  notificationController
                      .allnotificationlist
                      .value
                      .data
                      ?.notifications ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(.10),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            languagesController.tr("NOTIFICATIONS"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF29242F),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF8E8794),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xFFF0ECF2),
                  ),

                  if (isLoading)
                    SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2.6,
                        ),
                      ),
                    )
                  else if (notifications.isEmpty)
                    SizedBox(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F3F8),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.notifications_off_outlined,
                              size: 30,
                              color: Color(0xFFA19AA7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            languagesController.tr("NO_NOTIFICATIONS"),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7F7886),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: notifications.length > 10
                            ? 10
                            : notifications.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 68,
                            color: Color(0xFFF1EDF3),
                          );
                        },
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return InkWell(
                            onTap: () async {
                              Get.back();

                              await Get.to(
                                () => NotificationDetailsPage(
                                  notification: notification,
                                ),
                              );

                              await notificationController.fetchData();
                            },
                            child: Container(
                              color: notification.isRead == false
                                  ? AppColors.primaryColor.withOpacity(.045)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 42,
                                        width: 42,
                                        decoration: BoxDecoration(
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                                    .withOpacity(.11)
                                              : const Color(0xFFF5F3F6),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          size: 20,
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                              : const Color(0xFF9C95A2),
                                        ),
                                      ),
                                      if (notification.isRead == false)
                                        Positioned(
                                          right: -1,
                                          top: -1,
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight:
                                                notification.isRead == false
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: const Color(0xFF36303C),
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          notification.message ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            height: 1.4,
                                            color: Color(0xFF817A88),
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          notification.createdAt == null
                                              ? ""
                                              : DateFormat(
                                                  "dd MMM yyyy, hh:mm a",
                                                ).format(
                                                  notification.createdAt!
                                                      .toLocal(),
                                                ),
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            color: Color(0xFFA29BA8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0ECF2),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();

                          await Get.to(() => const AllNotificationsPage());

                          await notificationController.fetchData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          languagesController.tr("VIEW_ALL"),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
