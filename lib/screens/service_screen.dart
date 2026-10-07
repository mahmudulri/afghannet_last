import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:afghannet/controllers/bundle_controller.dart';
import 'package:afghannet/controllers/drawer_controller.dart';
import 'package:afghannet/controllers/service_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';

import '../widgets/custom_text.dart';
import 'social_bundles.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final ScrollController scrollController = ScrollController();
  final GetStorage box = GetStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();

    serviceController.fetchservices();

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

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screenWidth),

            const SizedBox(height: 6),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (serviceController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2.3,
                      ),
                    );
                  }

                  final services =
                      serviceController.allserviceslist.value.data?.services ??
                      [];

                  if (services.isEmpty) {
                    return Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.06),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(
                          Icons.grid_view_rounded,
                          size: 42,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }

                  final List<Color> bgColors = [
                    const Color(0xFFF7F1FC),
                    const Color(0xFFF1F6FC),
                    const Color(0xFFF1F8F4),
                    const Color(0xFFFCF5F1),
                    const Color(0xFFF2FAFA),
                    const Color(0xFFF7FAF2),
                    const Color(0xFFFFF8E8),
                    const Color(0xFFFFF1F1),
                  ];

                  final List<Color> accentColors = [
                    AppColors.primaryColor,
                    const Color(0xFF4B7FAF),
                    const Color(0xFF2B8B6F),
                    const Color(0xFF9C6B4B),
                    const Color(0xFF287A71),
                    const Color(0xFF64833E),
                    const Color(0xFFB28A24),
                    const Color(0xFFCA5555),
                  ];

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.86,
                        ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final data = services[index];

                      final bg = bgColors[index % bgColors.length];

                      final accent = accentColors[index % accentColors.length];

                      return _ServiceCard(
                        data: data,
                        bgColor: bg,
                        accentColor: accent,
                        onTap: () {
                          box.write("company_id", data.companyId);

                          mypagecontroller.changePage(
                            SocialBundles(),
                            isMainPage: false,
                          );
                        },
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
              text: languagesController.tr("SERVICES"),
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

class _ServiceCard extends StatefulWidget {
  final dynamic data;
  final Color bgColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.data,
    required this.bgColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });

        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_pressed ? 0.96 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _pressed
                ? widget.accentColor.withOpacity(.28)
                : const Color(0xFFEDE8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_pressed ? .01 : .018),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: widget.accentColor.withOpacity(.10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.data.company?.companyLogo ?? '',
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.4,
                          color: widget.accentColor.withOpacity(.45),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.business_outlined,
                      size: 20,
                      color: widget.accentColor.withOpacity(.55),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.data.company?.companyName ?? 'Unknown',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B3541),
              ),
            ),

            const SizedBox(height: 5),

            Container(
              height: 3,
              width: 22,
              decoration: BoxDecoration(
                color: widget.accentColor.withOpacity(.18),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
