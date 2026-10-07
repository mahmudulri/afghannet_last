import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:afghannet/controllers/currency_controller.dart';
import 'package:afghannet/global_controller/languages_controller.dart';

import 'package:afghannet/utils/colors.dart';
import 'package:afghannet/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/country_list_controller.dart';
import '../controllers/district_controller.dart';
import '../controllers/province_controller.dart';
import '../controllers/sign_up_controller.dart';
import '../models/currency_model.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/socialbuttonbox.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final SignUpController signUpController = Get.put(SignUpController());

  final GetStorage box = GetStorage();

  final String phoneNumber = "+93708488200";

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    countryListController.fetchCountryData();
    districtController.fetchDistrict();
    provinceController.fetchProvince();
    currencyController.fetchCurrencyList();
  }

  bool get isRtl {
    final direction = box.read("direction")?.toString().toLowerCase();
    return direction == "rtl";
  }

  TextAlign get fieldTextAlign {
    return isRtl ? TextAlign.right : TextAlign.left;
  }

  Alignment get fieldAlignment {
    return isRtl ? Alignment.centerRight : Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
                decoration: const BoxDecoration(color: Color(0xffF5F7FB)),
                child: Column(
                  children: [
                    KText(
                      text: languagesController.tr("REGISTER"),
                      color: const Color(0xff152A52),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 7),

                    KText(
                      text: languagesController.tr("CREATE_NEW_ACCOUNT"),
                      color: const Color(0xff7A869A),
                      fontSize: 13,
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xffE8ECF2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.055),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 22),

                    /// FULL NAME
                    _fieldLabel(languagesController.tr("FULL_NAME")),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.resellerNameController,
                      hintText: languagesController.tr("ENTER_YOUR_FULL_NAME"),
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 17),

                    /// CONTACT NAME
                    _fieldLabel(languagesController.tr("CONTACT_NAME")),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.contactNameController,
                      hintText: languagesController.tr("ENTER_CONTACT_NAME"),
                      icon: Icons.badge_outlined,
                    ),

                    const SizedBox(height: 17),

                    /// PHONE
                    _fieldLabel(languagesController.tr("PHONE_NUMBER")),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.phoneController,
                      hintText: languagesController.tr("ENTER_PHONE_NUMBER"),
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 8),

                    /// EMAIL
                    _fieldLabel(
                      languagesController.tr("EMAIL"),
                      optional: true,
                    ),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.emailController,
                      hintText: languagesController.tr("EMAIL_ADDRESS"),
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 8),

                    /// CURRENCY
                    _fieldLabel(languagesController.tr("CURRENCY")),

                    const SizedBox(height: 8),

                    _currencyDropdown(),

                    const SizedBox(height: 17),

                    /// COUNTRY
                    _fieldLabel(languagesController.tr("COUNTRY_OF_RESIDENCE")),

                    const SizedBox(height: 8),

                    _countryDropdown(),

                    const SizedBox(height: 17),

                    /// PROVINCE
                    _fieldLabel(
                      languagesController.tr("PROVINCE"),
                      optional: true,
                    ),

                    const SizedBox(height: 8),

                    _provinceDropdown(),

                    const SizedBox(height: 17),

                    /// DISTRICT
                    _fieldLabel(
                      languagesController.tr("DISTRICT"),
                      optional: true,
                    ),

                    const SizedBox(height: 8),

                    _districtDropdown(),

                    const SizedBox(height: 30),

                    const SizedBox(height: 22),

                    /// PROFILE PHOTO
                    _fieldLabel(
                      languagesController.tr("UPLOAD_PHOTO"),
                      optional: true,
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: Obx(
                        () => GestureDetector(
                          onTap: () async {
                            await signUpController.uploadImage();

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 118,
                                width: 118,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xffDCE3EE),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.07),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: const Color(0xffF4F7FB),
                                  child:
                                      signUpController
                                          .selectedImagePath
                                          .value
                                          .isEmpty
                                      ? Icon(
                                          Icons.person_outline_rounded,
                                          size: 50,
                                          color: AppColors.primaryColor
                                              .withOpacity(.65),
                                        )
                                      : ClipOval(
                                          child: Image.file(
                                            signUpController.imageFile!,
                                            width: 110,
                                            height: 110,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),

                              Positioned(
                                bottom: 0,
                                right: 2,
                                child: Container(
                                  height: 34,
                                  width: 34,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// IDENTITY
                    _fieldLabel(
                      languagesController.tr("IDENTITY_ATTACHMENT"),
                      optional: true,
                    ),

                    const SizedBox(height: 9),

                    Obx(
                      () => _uploadBox(
                        hasImage: signUpController
                            .selectedIdentityPath
                            .value
                            .isNotEmpty,
                        imagePath: signUpController.selectedIdentityPath.value,
                        emptyText: languagesController.tr(
                          "TAP_TO_UPLOAD_IDENTITY_IMAGE",
                        ),
                        icon: Icons.credit_card_outlined,
                        onTap: () async {
                          await signUpController.uploadIdentityAttachment();

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onRemove: () {
                          signUpController.selectedIdentityPath.value = '';
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// EXTRA PROOF
                    _fieldLabel(
                      languagesController.tr("EXTRA_PROOF"),
                      optional: true,
                    ),

                    const SizedBox(height: 9),

                    Obx(
                      () => _uploadBox(
                        hasImage: signUpController
                            .selectedExtraProofPath
                            .value
                            .isNotEmpty,
                        imagePath:
                            signUpController.selectedExtraProofPath.value,
                        emptyText: languagesController.tr(
                          "TAP_TO_UPLOAD_EXTRA_PROOF",
                        ),
                        icon: Icons.file_upload_outlined,
                        onTap: () async {
                          await signUpController.uploadExtraOptionalProof();

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onRemove: () {
                          signUpController.selectedExtraProofPath.value = '';
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// PIN
                    _fieldLabel(
                      languagesController.tr("ENTER_YOUR_PIN"),
                      optional: true,
                    ),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.pinController,
                      hintText: languagesController.tr("NEW_PIN"),
                      icon: Icons.pin_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    const SizedBox(height: 17),

                    /// CONFIRM PIN
                    _fieldLabel(
                      languagesController.tr("CONFIRM_PIN"),
                      optional: true,
                    ),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.confirmPinController,
                      hintText: languagesController.tr("CONFIRM_PIN"),
                      icon: Icons.verified_user_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    const SizedBox(height: 17),

                    /// PASSWORD
                    _fieldLabel(languagesController.tr("PASSWORD")),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.passwordController,
                      hintText: languagesController.tr("PASSWORD"),
                      icon: Icons.lock_outline_rounded,
                      obscureText: !isPasswordVisible,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 21,
                            color: const Color(0xff78869C),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 17),

                    /// CONFIRM PASSWORD
                    _fieldLabel(languagesController.tr("CONFIRM_PASSWORD")),

                    const SizedBox(height: 8),

                    _authField(
                      controller: signUpController.confirmPassController,
                      hintText: languagesController.tr("CONFIRM_PASSWORD"),
                      icon: Icons.lock_reset_outlined,
                      obscureText: !isConfirmPasswordVisible,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 21,
                            color: const Color(0xff78869C),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================================
                    /// REGISTER
                    /// =========================================
                    Obx(
                      () => _registerButton(
                        screenWidth: screenWidth,
                        text: signUpController.isLoading.value
                            ? languagesController.tr("PLEASE_WAIT")
                            : languagesController.tr("REGISTER"),
                        loading: signUpController.isLoading.value,
                        onTap: () async {
                          if (signUpController.isLoading.value) {
                            return;
                          }

                          final error = signUpController.validateInputs();

                          if (error != null) {
                            Get.snackbar(
                              languagesController.tr("INVALID_INPUT"),
                              error,
                              backgroundColor: Colors.red.shade700,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.all(15),
                            );

                            return;
                          }

                          await signUpController.registernow();
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: KText(
                            text: languagesController.tr("ALREADY_REGISTERED"),
                            color: const Color(0xff7B8799),
                            fontSize: 13.5,
                          ),
                        ),

                        const SizedBox(width: 7),

                        GestureDetector(
                          onTap: Get.back,
                          child: KText(
                            text: languagesController.tr("LOGIN"),
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// =========================================
              /// SOCIAL
              /// =========================================
              _socialSection(),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 35,
                    color: const Color(0xffD5DBE5),
                  ),

                  const SizedBox(width: 10),

                  KText(
                    text: languagesController.tr("FIND_US_ON"),
                    color: const Color(0xff7B8799),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),

                  const SizedBox(width: 10),

                  Container(
                    height: 1,
                    width: 35,
                    color: const Color(0xffD5DBE5),
                  ),
                ],
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FIELD LABEL
  // =========================================================

  Widget _fieldLabel(String text, {bool optional = false}) {
    return Row(
      mainAxisAlignment: isRtl
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: KText(
            text: text,
            color: AppColors.fontColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (optional) ...[
          const SizedBox(width: 5),

          KText(
            text: "(${languagesController.tr("OPTIONAL")})",
            color: Colors.white.withOpacity(.75),
            fontSize: 11,
          ),
        ],
      ],
    );
  }

  // =========================================================
  // AUTH FIELD
  // =========================================================

  Widget _authField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),

          Icon(icon, size: 20, color: AppColors.fontColor.withOpacity(.8)),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              textAlign: fieldTextAlign,
              cursorColor: AppColors.primaryColor,
              inputFormatters: inputFormatters,
              style: const TextStyle(
                color: Color(0xff233F78),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.fontColor.withOpacity(.65),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                isDense: true,
              ),
            ),
          ),

          if (suffixIcon != null) suffixIcon,

          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // =========================================================
  // DROPDOWN WRAPPER
  // =========================================================

  Widget _dropdownWrapper({
    required IconData prefixIcon,
    required Widget child,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            prefixIcon,
            size: 20,
            color: AppColors.fontColor.withOpacity(.8),
          ),

          const SizedBox(width: 10),

          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _dropdownIcon() {
    return Icon(
      Icons.keyboard_arrow_down_rounded,
      color: AppColors.primaryColor,
      size: 23,
    );
  }

  TextStyle get dropdownStyle {
    return const TextStyle(
      color: Color(0xff233F78),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get dropdownHintStyle {
    return TextStyle(
      color: AppColors.fontColor.withOpacity(.65),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  // =========================================================
  // CURRENCY
  // =========================================================

  Widget _currencyDropdown() {
    return _dropdownWrapper(
      prefixIcon: Icons.currency_exchange_outlined,
      child: Obx(() {
        final List<Currency> currencies =
            currencyController.allcurrencylist.value.data?.currencies ??
            <Currency>[];

        final List<Currency> usableCurrencies = currencies
            .where((currency) => currency.id != null)
            .toList();

        final String? selectedCurrencyId =
            signUpController.currencyId.value.isEmpty
            ? null
            : signUpController.currencyId.value;

        final bool selectedExists =
            selectedCurrencyId != null &&
            usableCurrencies.any(
              (currency) => currency.id.toString() == selectedCurrencyId,
            );

        final String? currentValue = selectedExists ? selectedCurrencyId : null;

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: _dropdownIcon(),

            hint: Align(
              alignment: fieldAlignment,
              child: Text(
                languagesController.tr("CURRENCY"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: dropdownHintStyle,
              ),
            ),

            selectedItemBuilder: (context) {
              return usableCurrencies.map<Widget>((currency) {
                return Align(
                  alignment: fieldAlignment,
                  child: Text(
                    _currencyName(currency),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                );
              }).toList();
            },

            items: usableCurrencies.map<DropdownMenuItem<String>>((currency) {
              return DropdownMenuItem<String>(
                value: currency.id.toString(),
                child: Align(
                  alignment: fieldAlignment,
                  child: Text(
                    _currencyName(currency),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                ),
              );
            }).toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              signUpController.currencyId.value = value;

              final Currency? selectedCurrency = usableCurrencies
                  .firstWhereOrNull(
                    (currency) => currency.id.toString() == value,
                  );

              if (selectedCurrency != null) {
                print("Selected Currency ID: ${selectedCurrency.id}");
                print("Selected Currency Name: ${selectedCurrency.name}");
                print("Selected Currency Code: ${selectedCurrency.code}");
                print("Selected Currency Symbol: ${selectedCurrency.symbol}");
                print(
                  "Selected Exchange Rate: "
                  "${selectedCurrency.exchangeRatePerUsd}",
                );
              }
            },
          ),
        );
      }),
    );
  }

  String _currencyName(Currency currency) {
    final String name = (currency.name ?? '').trim();
    final String code = (currency.code ?? '').trim();
    final String symbol = (currency.symbol ?? '').trim();

    if (name.isNotEmpty && code.isNotEmpty) {
      return "$name ($code)";
    }

    if (code.isNotEmpty && symbol.isNotEmpty) {
      return "$code ($symbol)";
    }

    if (code.isNotEmpty) {
      return code;
    }

    if (symbol.isNotEmpty) {
      return symbol;
    }

    return name;
  }

  // =========================================================
  // COUNTRY
  // =========================================================

  Widget _countryDropdown() {
    return _dropdownWrapper(
      prefixIcon: Icons.public_outlined,
      child: Obx(() {
        final countries =
            countryListController.allcountryListData.value.data?.countries ??
            <dynamic>[];

        final String? selectedId = signUpController.countryId.value.isEmpty
            ? null
            : signUpController.countryId.value;

        final selectedExists =
            selectedId != null &&
            countries.any(
              (country) => ((country?.id) ?? '').toString() == selectedId,
            );

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedExists ? selectedId : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: _dropdownIcon(),
            hint: Align(
              alignment: fieldAlignment,
              child: Text(
                languagesController.tr("COUNTRY_OF_RESIDENCE"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: dropdownHintStyle,
              ),
            ),
            selectedItemBuilder: (_) {
              return countries.map<Widget>((country) {
                final name = ((country?.countryName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                );
              }).toList();
            },
            items: countries.map<DropdownMenuItem<String>>((country) {
              final id = ((country?.id) ?? '').toString();

              final name = ((country?.countryName) ?? '').toString();

              final flagUrl = ((country?.countryFlagImageUrl) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,
                child: Row(
                  children: [
                    if (flagUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          flagUrl,
                          height: 23,
                          width: 34,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                    if (flagUrl.isNotEmpty) const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: dropdownStyle,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              signUpController.countryId.value = value;
            },
          ),
        );
      }),
    );
  }

  // =========================================================
  // PROVINCE
  // =========================================================

  Widget _provinceDropdown() {
    return _dropdownWrapper(
      prefixIcon: Icons.location_city_outlined,
      child: Obx(() {
        final provinces =
            provinceController.allprovincelist.value.data?.provinces ??
            <dynamic>[];

        final String? selectedId = signUpController.provinceId.value.isEmpty
            ? null
            : signUpController.provinceId.value;

        final selectedExists =
            selectedId != null &&
            provinces.any(
              (province) => ((province?.id) ?? '').toString() == selectedId,
            );

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedExists ? selectedId : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: _dropdownIcon(),
            hint: Align(
              alignment: fieldAlignment,
              child: Text(
                languagesController.tr("PROVINCE"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: dropdownHintStyle,
              ),
            ),
            selectedItemBuilder: (_) {
              return provinces.map<Widget>((province) {
                final name = ((province?.provinceName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                );
              }).toList();
            },
            items: provinces.map<DropdownMenuItem<String>>((province) {
              final id = ((province?.id) ?? '').toString();

              final name = ((province?.provinceName) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,
                child: Align(
                  alignment: fieldAlignment,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              signUpController.provinceId.value = value;
            },
          ),
        );
      }),
    );
  }

  // =========================================================
  // DISTRICT
  // =========================================================

  Widget _districtDropdown() {
    return _dropdownWrapper(
      prefixIcon: Icons.place_outlined,
      child: Obx(() {
        final districts =
            districtController.alldistrictList.value.data?.districts ??
            <dynamic>[];

        final String? selectedId = signUpController.districtID.value.isEmpty
            ? null
            : signUpController.districtID.value;

        final selectedExists =
            selectedId != null &&
            districts.any(
              (district) => ((district?.id) ?? '').toString() == selectedId,
            );

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedExists ? selectedId : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: _dropdownIcon(),
            hint: Align(
              alignment: fieldAlignment,
              child: Text(
                languagesController.tr("DISTRICT"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: dropdownHintStyle,
              ),
            ),
            selectedItemBuilder: (_) {
              return districts.map<Widget>((district) {
                final name = ((district?.districtName) ?? '').toString();

                return Align(
                  alignment: fieldAlignment,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                );
              }).toList();
            },
            items: districts.map<DropdownMenuItem<String>>((district) {
              final id = ((district?.id) ?? '').toString();

              final name = ((district?.districtName) ?? '').toString();

              return DropdownMenuItem<String>(
                value: id,
                child: Align(
                  alignment: fieldAlignment,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: dropdownStyle,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              signUpController.districtID.value = value;
            },
          ),
        );
      }),
    );
  }

  // =========================================================
  // UPLOAD BOX
  // =========================================================

  Widget _uploadBox({
    required bool hasImage,
    required String imagePath,
    required String emptyText,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.white.withOpacity(.8),
        strokeWidth: 1.4,
        dashPattern: const [7, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.96),
            borderRadius: BorderRadius.circular(10),
          ),
          child: hasImage
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
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
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 23,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        emptyText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.fontColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // =========================================================
  // REGISTER BUTTON
  // SAME STYLE AS SIGN-IN BUTTON
  // =========================================================

  Widget _registerButton({
    required double screenWidth,
    required String text,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: loading ? .8 : 1,
        child: Container(
          width: screenWidth,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(.30),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: loading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          KText(
                            text: text,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    : KText(
                        text: text,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SOCIAL SECTION
  // =========================================================

  Widget _socialSection() {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              whatsapp();
            },
            child: Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.94),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 7),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                size: 27,
                color: Colors.green,
              ),
            ),
          ),

          const SizedBox(width: 35),

          GestureDetector(
            onTap: () {
              showSocialPopup(context);
            },
            child: Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.94),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 7),
                ],
              ),
              child: Image.asset(
                "assets/icons/social-media.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 35),

          GestureDetector(
            onTap: () {
              _makePhoneCall(phoneNumber);
            },
            child: Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.94),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 7),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.phone,
                size: 21,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
