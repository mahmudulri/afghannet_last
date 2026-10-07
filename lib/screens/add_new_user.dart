import 'dart:io';
import 'package:afghannet/controllers/add_sub_reseller_controller.dart';
import 'package:afghannet/controllers/country_list_controller.dart';
import 'package:afghannet/controllers/dashboard_controller.dart';
import 'package:afghannet/controllers/district_controller.dart';
import 'package:afghannet/controllers/province_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';
import 'package:afghannet/global_controller/page_controller.dart';
import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/authtextfield.dart';
import 'package:afghannet/widgets/button_one.dart';
import 'package:afghannet/widgets/menuiconwidget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/commission_group_controller.dart';
import '../widgets/custom_text.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  File? _selectedImage;

  final GetStorage box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );

  final AddSubResellerController addSubResellerController = Get.put(
    AddSubResellerController(),
  );

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final CommissionGroupController commissionlistController = Get.put(
    CommissionGroupController(),
  );

  String selected_comissiongroup = "";

  String selected_country = "";

  String selected_province = "";

  String selected_district = "";

  @override
  void initState() {
    super.initState();

    commissionlistController.fetchGrouplist();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFBF9FD),

        statusBarIconBrightness: Brightness.dark,

        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: Colors.white,

        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _resetDatafield();
  }

  void _resetDatafield() {
    addSubResellerController.groupId.value = '';

    selected_comissiongroup = "";

    addSubResellerController.countryId.value = '';

    selected_country = "";

    addSubResellerController.provinceId.value = '';

    selected_province = "";

    addSubResellerController.districtID.value = '';

    selected_district = "";
  }

  Future<void> _pickImage() async {
    await addSubResellerController.uploadImage();

    if (addSubResellerController.imageFile != null) {
      setState(() {
        _selectedImage = addSubResellerController.imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),

      resizeToAvoidBottomInset: true,

      body: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),

              children: [
                _buildProfileUploader(),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(22),

                    border: Border.all(color: const Color(0xFFEDE8F0)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.02),

                        blurRadius: 14,

                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      _label(languagesController.tr("FULL_NAME")),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr(
                          "ADD_FIRST_AND_LAST_NAME",
                        ),

                        controller:
                            addSubResellerController.resellerNameController,
                      ),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("COMPANY_NAME")),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr("COMPANY_NAME"),

                        controller:
                            addSubResellerController.contactNameController,
                      ),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("PHONENUMBER")),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_PHONE_NUMBER"),

                        controller: addSubResellerController.phoneController,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _label(languagesController.tr("EMAIL")),

                          const SizedBox(width: 6),

                          Text(
                            "(${languagesController.tr("OPTIONAL")})",

                            style: const TextStyle(
                              fontSize: 10.5,

                              color: Color(0xFFA39CA8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_EMAIL_ADDRESS"),

                        controller: addSubResellerController.emailController,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _label(languagesController.tr("SET_PIN")),

                          const SizedBox(width: 6),

                          Text(
                            "(${languagesController.tr("OPTIONAL")})",

                            style: const TextStyle(
                              fontSize: 10.5,

                              color: Color(0xFFA39CA8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr("SET_PIN"),

                        controller: addSubResellerController.pinController,
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _label(languagesController.tr("SET_PASSWORD")),

                          const SizedBox(width: 6),

                          Text(
                            "(${languagesController.tr("OPTIONAL")})",

                            style: const TextStyle(
                              fontSize: 10.5,

                              color: Color(0xFFA39CA8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Authtextfield(
                        hinttext: languagesController.tr("SET_PASSWORD"),

                        controller: addSubResellerController.passwordController,
                      ),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("COMMISSION_GROUP")),

                      const SizedBox(height: 7),

                      _buildCommissionDropdown(),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("COUNTRY_OF_RESIDENCE")),

                      const SizedBox(height: 7),

                      _buildCountryDropdown(),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("PROVINCE")),

                      const SizedBox(height: 7),

                      _buildProvinceDropdown(),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("DISTRICT")),

                      const SizedBox(height: 7),

                      _buildDistrictDropdown(),

                      const SizedBox(height: 14),

                      _label(languagesController.tr("DESIRED_CURRENCY")),

                      const SizedBox(height: 7),

                      Container(
                        height: 50,

                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(horizontal: 12),

                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8FC),

                          borderRadius: BorderRadius.circular(14),

                          border: Border.all(color: const Color(0xFFEDE8F0)),
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.currency_exchange_rounded,

                              size: 18,

                              color: AppColors.primaryColor,
                            ),

                            const SizedBox(width: 9),

                            Expanded(
                              child: Text(
                                box.read("currency_code")?.toString() ?? '',

                                style: const TextStyle(
                                  fontSize: 12.5,

                                  fontWeight: FontWeight.w600,

                                  color: Color(0xFF5B5561),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          _label(languagesController.tr("IDENTITY_ATTACHMENT")),

                          const SizedBox(width: 6),

                          Text(
                            "(${languagesController.tr("OPTIONAL")})",

                            style: const TextStyle(
                              fontSize: 10.5,

                              color: Color(0xFFA39CA8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Obx(
                        () => _buildAttachmentBox(
                          path: addSubResellerController
                              .selectedIdentityPath
                              .value,

                          emptyText: languagesController.tr(
                            "TAP_TO_UPLOAD_IDENTITY_IMAGE",
                          ),

                          onTap: () async {
                            await addSubResellerController
                                .uploadIdentityAttachment();
                          },

                          onRemove: () {
                            addSubResellerController
                                    .selectedIdentityPath
                                    .value =
                                '';
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          _label(languagesController.tr("EXTRA_PROOF")),

                          const SizedBox(width: 6),

                          Text(
                            "(${languagesController.tr("OPTIONAL")})",

                            style: const TextStyle(
                              fontSize: 10.5,

                              color: Color(0xFFA39CA8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Obx(
                        () => _buildAttachmentBox(
                          path: addSubResellerController
                              .selectedExtraProofPath
                              .value,

                          emptyText: languagesController.tr(
                            "TAP_TO_UPLOAD_EXTRA_PROOF",
                          ),

                          onTap: () async {
                            await addSubResellerController
                                .uploadExtraOptionalProof();
                          },

                          onRemove: () {
                            addSubResellerController
                                    .selectedExtraProofPath
                                    .value =
                                '';
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => DefaultButton(
                          buttonName:
                              addSubResellerController.isLoading.value == false
                              ? languagesController.tr("ADD_NOW")
                              : languagesController.tr("PLEASE_WAIT"),

                          mycolor: AppColors.primaryColor,

                          onpressed: () {
                            if (addSubResellerController
                                    .resellerNameController
                                    .text
                                    .isEmpty ||
                                addSubResellerController
                                    .contactNameController
                                    .text
                                    .isEmpty ||
                                addSubResellerController
                                    .phoneController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: languagesController.tr(
                                  "FILL_DATA_CORRECTLY",
                                ),

                                toastLength: Toast.LENGTH_SHORT,

                                gravity: ToastGravity.BOTTOM,

                                timeInSecForIosWeb: 1,

                                backgroundColor: Colors.black,

                                textColor: Colors.white,

                                fontSize: 16.0,
                              );
                            } else {
                              addSubResellerController.addNow();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
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
            child: GestureDetector(
              onTap: () {
                commissionlistController.fetchGrouplist();
              },

              child: KText(
                text: languagesController.tr("ADD_USER"),

                fontWeight: FontWeight.w800,

                fontSize: 16,

                color: const Color(0xFF2E2833),
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

  Widget _buildProfileUploader() {
    return Center(
      child: Obx(() {
        final hasImage =
            addSubResellerController.selectedImagePath.value.isNotEmpty;

        return GestureDetector(
          onTap: _pickImage,

          child: Stack(
            clipBehavior: Clip.none,

            children: [
              DottedBorder(
                color: AppColors.primaryColor.withOpacity(.25),

                strokeWidth: 1.5,

                dashPattern: const [6, 4],

                borderType: BorderType.Circle,

                child: Padding(
                  padding: const EdgeInsets.all(5),

                  child: CircleAvatar(
                    radius: 49,

                    backgroundColor: const Color(0xFFF7F4F9),

                    child: hasImage
                        ? ClipOval(
                            child: Image.file(
                              addSubResellerController.imageFile!,

                              width: 98,

                              height: 98,

                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Container(
                                width: 32,

                                height: 32,

                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    .08,
                                  ),

                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: const Icon(
                                  Icons.add_a_photo_outlined,

                                  size: 17,

                                  color: AppColors.primaryColor,
                                ),
                              ),

                              const SizedBox(height: 6),

                              KText(
                                text: languagesController.tr("UPLOAD_PHOTO"),

                                color: const Color(0xFF8F8895),

                                fontSize: 10.5,

                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              Positioned(
                right: -1,

                bottom: 3,

                child: Container(
                  width: 31,

                  height: 31,

                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,

                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(color: Colors.white, width: 2),
                  ),

                  child: const Icon(
                    Icons.edit_rounded,

                    size: 15,

                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _label(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 12,

        fontWeight: FontWeight.w700,

        color: Color(0xFF5C5562),
      ),
    );
  }

  Widget _buildCommissionDropdown() {
    return Obx(() {
      final List<dynamic> groups =
          (commissionlistController.allgrouplist.value.data?.groups as List?) ??
          <dynamic>[];

      return _dropdownShell(
        child: DropdownButtonFormField<String>(
          isExpanded: true,

          value: addSubResellerController.groupId.value.isEmpty
              ? null
              : addSubResellerController.groupId.value,

          decoration: const InputDecoration(
            border: InputBorder.none,

            contentPadding: EdgeInsets.zero,
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,

            color: Color(0xFFA39CA8),
          ),

          hint: Text(
            selected_comissiongroup,

            style: const TextStyle(fontSize: 12.5, color: Color(0xFF8F8895)),
          ),

          items: groups.map<DropdownMenuItem<String>>((g) {
            final id = (g?.id ?? '').toString();

            final name = (g?.groupName ?? '').toString();

            return DropdownMenuItem<String>(
              value: id,

              child: Text(
                name,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF4E4854),
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) return;

            dynamic picked;

            for (final g in groups) {
              if ((g?.id ?? '').toString() == value) {
                picked = g;

                break;
              }
            }

            addSubResellerController.groupId.value = value;

            selected_comissiongroup = (picked?.groupName ?? '').toString();
          },
        ),
      );
    });
  }

  Widget _buildCountryDropdown() {
    return Obx(() {
      final countries =
          countryListController.allcountryListData.value.data?.countries ??
          <dynamic>[];

      return _dropdownShell(
        child: DropdownButtonFormField<String>(
          isExpanded: true,

          value: addSubResellerController.countryId.value.isEmpty
              ? null
              : addSubResellerController.countryId.value,

          decoration: const InputDecoration(
            border: InputBorder.none,

            contentPadding: EdgeInsets.zero,
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,

            color: Color(0xFFA39CA8),
          ),

          hint: Text(
            selected_country,

            style: const TextStyle(fontSize: 12.5, color: Color(0xFF8F8895)),
          ),

          items: countries.map<DropdownMenuItem<String>>((c) {
            final id = (c?.id ?? '').toString();

            final name = (c?.countryName ?? '').toString();

            return DropdownMenuItem<String>(
              value: id,

              child: Text(
                name,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF4E4854),
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) return;

            dynamic picked;

            for (final c in countries) {
              if ((c?.id ?? '').toString() == value) {
                picked = c;

                break;
              }
            }

            addSubResellerController.countryId.value = value;

            selected_country = (picked?.countryName ?? '').toString();
          },
        ),
      );
    });
  }

  Widget _buildProvinceDropdown() {
    return Obx(() {
      final provinces =
          provinceController.allprovincelist.value.data?.provinces ??
          <dynamic>[];

      return _dropdownShell(
        child: DropdownButtonFormField<String>(
          isExpanded: true,

          value: addSubResellerController.provinceId.value.isEmpty
              ? null
              : addSubResellerController.provinceId.value,

          decoration: const InputDecoration(
            border: InputBorder.none,

            contentPadding: EdgeInsets.zero,
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,

            color: Color(0xFFA39CA8),
          ),

          hint: Text(
            selected_province,

            style: const TextStyle(fontSize: 12.5, color: Color(0xFF8F8895)),
          ),

          items: provinces.map<DropdownMenuItem<String>>((p) {
            final id = (p?.id ?? '').toString();

            final name = (p?.provinceName ?? '').toString();

            return DropdownMenuItem<String>(
              value: id,

              child: Text(
                name,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF4E4854),
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) return;

            dynamic picked;

            for (final p in provinces) {
              if ((p?.id ?? '').toString() == value) {
                picked = p;

                break;
              }
            }

            addSubResellerController.provinceId.value = value;

            selected_province = (picked?.provinceName ?? '').toString();
          },
        ),
      );
    });
  }

  Widget _buildDistrictDropdown() {
    return Obx(() {
      final districts =
          districtController.alldistrictList.value.data?.districts ??
          <dynamic>[];

      return _dropdownShell(
        child: DropdownButtonFormField<String>(
          isExpanded: true,

          value: addSubResellerController.districtID.value.isEmpty
              ? null
              : addSubResellerController.districtID.value,

          decoration: const InputDecoration(
            border: InputBorder.none,

            contentPadding: EdgeInsets.zero,
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,

            color: Color(0xFFA39CA8),
          ),

          hint: Text(
            selected_district,

            style: const TextStyle(fontSize: 12.5, color: Color(0xFF8F8895)),
          ),

          items: districts.map<DropdownMenuItem<String>>((d) {
            final id = (d?.id ?? '').toString();

            final name = (d?.districtName ?? '').toString();

            return DropdownMenuItem<String>(
              value: id,

              child: Text(
                name,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF4E4854),
                ),
              ),
            );
          }).toList(),

          onChanged: (value) {
            if (value == null) return;

            dynamic picked;

            for (final d in districts) {
              if ((d?.id ?? '').toString() == value) {
                picked = d;

                break;
              }
            }

            addSubResellerController.districtID.value = value;

            selected_district = (picked?.districtName ?? '').toString();
          },
        ),
      );
    });
  }

  Widget _dropdownShell({required Widget child}) {
    return Container(
      height: 50,

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FC),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFEDE8F0)),
      ),

      child: child,
    );
  }

  Widget _buildAttachmentBox({
    required String path,

    required String emptyText,

    required Future<void> Function() onTap,

    required VoidCallback onRemove,
  }) {
    final hasImage = path.isNotEmpty;

    return GestureDetector(
      onTap: onTap,

      child: DottedBorder(
        color: AppColors.primaryColor.withOpacity(.22),

        strokeWidth: 1.5,

        dashPattern: const [6, 4],

        borderType: BorderType.RRect,

        radius: const Radius.circular(15),

        child: Container(
          height: 116,

          width: double.infinity,

          decoration: BoxDecoration(
            color: const Color(0xFFFAF8FC),

            borderRadius: BorderRadius.circular(15),
          ),

          child: hasImage
              ? Stack(
                  fit: StackFit.expand,

                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),

                      child: Image.file(File(path), fit: BoxFit.cover),
                    ),

                    Positioned(
                      top: 7,

                      right: 7,

                      child: GestureDetector(
                        onTap: onRemove,

                        child: Container(
                          width: 28,

                          height: 28,

                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.58),

                            borderRadius: BorderRadius.circular(9),
                          ),

                          child: const Icon(
                            Icons.close_rounded,

                            size: 15,

                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      width: 36,

                      height: 36,

                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.08),

                        borderRadius: BorderRadius.circular(11),
                      ),

                      child: const Icon(
                        Icons.upload_file_rounded,

                        size: 19,

                        color: AppColors.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      child: KText(
                        text: emptyText,

                        color: const Color(0xFF8F8895),

                        fontSize: 10.5,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
