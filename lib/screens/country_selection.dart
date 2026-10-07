import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/bundle_controller.dart';
import 'package:afghannet/controllers/country_list_controller.dart';
import 'package:afghannet/controllers/service_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/models/country_list_model.dart';

import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/menuiconwidget.dart';
import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  const InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final BundleController bundleController = Get.put(BundleController());

  final ServiceController serviceController = Get.put(ServiceController());

  final GetStorage box = GetStorage();

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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screenWidth),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (countrylistController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.5,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languagesController.tr("BOOKING_FOR"),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C5562),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.42,
                              ),
                          itemCount:
                              countrylistController.finalCountryList.length,
                          itemBuilder: (context, index) {
                            final Country data =
                                countrylistController.finalCountryList[index];

                            return _buildCountryCard(data, index, screenHeight);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
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
            child: Text(
              languagesController.tr("COUNTRY_SELECTION"),
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

  Widget _buildCountryCard(Country data, int index, double screenHeight) {
    final backgrounds = [
      const Color(0xFFF7F1FC),
      const Color(0xFFF1F6FC),
      const Color(0xFFF1F8F4),
      const Color(0xFFFCF5F1),
      const Color(0xFFF2FAFA),
      const Color(0xFFF7FAF2),
    ];

    final accents = [
      AppColors.primaryColor,
      const Color(0xFF4B7FAF),
      const Color(0xFF2B8B6F),
      const Color(0xFF9C6B4B),
      const Color(0xFF287A71),
      const Color(0xFF64833E),
    ];

    final bg = backgrounds[index % backgrounds.length];
    final accent = accents[index % accents.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final Country selectedCountry = data;
          final bool enableOperatorLookup =
              selectedCountry.enableOperatorLookup;

          box.write("country_id", selectedCountry.id);
          box.write("countryName", selectedCountry.countryName ?? "");
          box.write("maxlength", selectedCountry.phoneNumberLength ?? "");
          box.write("enable_operator_lookup", enableOperatorLookup);
          box.write("validity_type", "");
          box.write("company_id", "");
          box.write("search_tag", "");

          serviceController.reserveDigit.clear();
          bundleController.resetBundles();

          print("Selected country: ${selectedCountry.countryName}");
          print("Selected lookup value: $enableOperatorLookup");
          print("Stored lookup value: ${box.read("enable_operator_lookup")}");

          mypagecontroller.changePage(
            RechargeScreen(enableOperatorLookup: enableOperatorLookup),
            isMainPage: false,
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accent.withOpacity(.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: accent.withOpacity(.14)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.025),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      data.countryFlagImageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.flag_outlined,
                        color: accent.withOpacity(.75),
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  data.countryName ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: screenHeight * 0.017,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 28,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
