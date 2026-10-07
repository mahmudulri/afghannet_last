import 'package:afghannet/global_controller/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';
import '../widgets/menuiconwidget.dart';

class Helpscreen extends StatefulWidget {
  const Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
  final HelpController helpController = Get.find<HelpController>();
  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();

    helpController.helpService();

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
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            Expanded(
              child: Obx(() {
                if (helpController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2.3,
                    ),
                  );
                }

                final articles = helpController.helpdata.value.data!.articles!;

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
                  itemCount: articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final data = articles[index];

                    return _HelpCard(
                      index: index,
                      title: data.title.toString(),
                      description: data.description.toString(),
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
              languagesController.tr("GUIDE"),
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
}

class _HelpCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;

  const _HelpCard({
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final accents = [
      AppColors.primaryColor,
      const Color(0xFF4B7FAF),
      const Color(0xFF2B8B6F),
      const Color(0xFF9C6B4B),
      const Color(0xFF287A71),
      const Color(0xFF64833E),
    ];

    final backgrounds = [
      const Color(0xFFF7F1FC),
      const Color(0xFFF1F6FC),
      const Color(0xFFF1F8F4),
      const Color(0xFFFCF5F1),
      const Color(0xFFF2FAFA),
      const Color(0xFFF7FAF2),
    ];

    final accent = accents[index % accents.length];
    final background = backgrounds[index % backgrounds.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 18,
                  color: accent,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF342E39),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF0ECF2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 15,
                  color: accent.withOpacity(.75),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6E6774),
                    ),
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
