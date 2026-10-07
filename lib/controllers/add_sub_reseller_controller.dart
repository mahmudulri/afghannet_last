import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../global_controller/languages_controller.dart';
import '../utils/api_endpoints.dart';
import 'sub_reseller_controller.dart';

final SubresellerController subresellerController = Get.put(
  SubresellerController(),
);

final LanguagesController languagesController = Get.put(LanguagesController());

class AddSubResellerController extends GetxController {
  // ---------- Images ----------
  var selectedImagePath = ''.obs;
  File? imageFile;

  var selectedIdentityPath = ''.obs;
  var selectedExtraProofPath = ''.obs;

  // ---------- IDs / dropdown ----------
  var groupId = ''.obs;
  var countryId = ''.obs;
  var provinceId = ''.obs;
  var districtID = ''.obs;
  var currencyID = ''.obs;

  // ---------- Text inputs ----------
  TextEditingController resellerNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Optional PIN & Password
  TextEditingController pinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final box = GetStorage();

  RxBool isLoading = false.obs;

  // =========================================================
  // IMAGE PICKERS
  // =========================================================

  Future<void> uploadImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImageFile != null) {
      selectedImagePath.value = pickedImageFile.path;
      imageFile = File(pickedImageFile.path);

      print("before image tag   $imageFile");
    } else {
      print("No image selected");
    }
  }

  Future<void> uploadIdentityAttachment() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedIdentityPath.value = picked.path;

      print("identity selected: ${selectedIdentityPath.value}");
    } else {
      print("No identity image selected");
    }
  }

  Future<void> uploadExtraOptionalProof() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedExtraProofPath.value = picked.path;

      print("extra proof selected: ${selectedExtraProofPath.value}");
    } else {
      print("No extra proof image selected");
    }
  }

  // =========================================================
  // SUCCESS DIALOG
  // =========================================================

  void showCreatedSuccessDialog({
    required String phone,
    required String pin,
    required String password,
  }) {
    final String displayPin = pin.trim().isNotEmpty ? pin.trim() : "Not Set";

    final String displayPassword = password.trim().isNotEmpty
        ? password
        : "Not Set";

    final String shareText =
        '''
Sub Reseller Account Created Successfully

Phone Number: $phone
PIN: $displayPin
Password: $displayPassword
''';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------- SUCCESS ICON ----------------
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 48,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 16),

              // ---------------- TITLE ----------------
              const Text(
                "Account Created",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E2833),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                "Sub reseller account has been created successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: Color(0xFF8F8895),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- CREDENTIAL BOX ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7F9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEDE8F0)),
                ),
                child: Column(
                  children: [
                    _credentialRow(
                      icon: Icons.phone_android_rounded,
                      title: "Phone Number",
                      value: phone,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE9E5EB)),
                    ),

                    _credentialRow(
                      icon: Icons.pin_rounded,
                      title: "PIN",
                      value: displayPin,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE9E5EB)),
                    ),

                    _credentialRow(
                      icon: Icons.lock_outline_rounded,
                      title: "Password",
                      value: displayPassword,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ---------------- COPY + SHARE ----------------
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: shareText.trim()),
                          );

                          Fluttertoast.showToast(
                            msg: "Account information copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 14,
                          );
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F2F7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE9E3EC)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                size: 18,
                                color: Color(0xFF625A68),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Copy All",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF625A68),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          await Share.share(
                            shareText.trim(),
                            subject: "Sub Reseller Account Information",
                          );
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E2833),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Share",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ---------------- CLOSE ----------------
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8F8895),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _credentialRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEAF1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF625A68)),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9C959F),
                ),
              ),

              const SizedBox(height: 3),

              SelectableText(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF38323D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  Future<void> addNow() async {
    try {
      isLoading.value = true;

      final headers = {'Authorization': 'Bearer ${box.read("userToken")}'};

      // IMPORTANT:
      // Keep values before clearing controllers,
      // because we need them inside the success dialog.

      final String createdPhone = phoneController.text.trim();

      final String createdPin = pinController.text.trim();

      final String createdPassword = passwordController.text;

      final Map<String, String> fields = {
        'reseller_name': resellerNameController.text.trim(),

        'contact_name': contactNameController.text.trim(),

        'email': emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : '${phoneController.text.trim()}@gmail.com',

        'phone': phoneController.text.trim(),

        'sub_reseller_comission_group_id': groupId.value,

        'country_id': countryId.value,

        'province_id': provinceId.value,

        'districts_id': districtID.value,

        'currency_preference_id': box.read("currencypreferenceID").toString(),
      };

      // PIN optional
      if (createdPin.isNotEmpty) {
        fields['pin'] = createdPin;
      }

      // Password optional
      if (createdPassword.isNotEmpty) {
        fields['password'] = createdPassword;
      }

      final url = Uri.parse("${ApiEndPoints.baseUrl}sub-resellers");

      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(headers);

      request.fields.addAll(fields);

      // =====================================================
      // PROFILE IMAGE
      // =====================================================

      if (selectedImagePath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image_url',
            selectedImagePath.value,
            filename: "profile.jpg",
          ),
        );
      }

      // =====================================================
      // IDENTITY IMAGE
      // =====================================================

      if (selectedIdentityPath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'reseller_identity_attachment',
            selectedIdentityPath.value,
            filename: "identity.jpg",
          ),
        );
      }

      // =====================================================
      // EXTRA PROOF
      // =====================================================

      if (selectedExtraProofPath.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'extra_optional_proof',
            selectedExtraProofPath.value,
            filename: "extra_proof.jpg",
          ),
        );
      }

      // =====================================================
      // SEND
      // =====================================================

      final streamed = await request.send();

      final httpResponse = await http.Response.fromStream(streamed);

      print("STATUS CODE: ${streamed.statusCode}");

      print("RESPONSE BODY: ${httpResponse.body}");

      dynamic res;

      try {
        res = jsonDecode(httpResponse.body);
      } catch (_) {
        res = null;
      }

      // =====================================================
      // SUCCESS
      // =====================================================

      if (streamed.statusCode == 201) {
        // refresh list
        subresellerController.fetchSubReseller();

        // Clear text fields
        resellerNameController.clear();
        contactNameController.clear();
        emailController.clear();
        phoneController.clear();
        pinController.clear();
        passwordController.clear();

        // Clear dropdown values
        currencyID.value = '';
        countryId.value = '';
        provinceId.value = '';
        districtID.value = '';
        groupId.value = '';

        // Clear images
        selectedImagePath.value = '';
        selectedIdentityPath.value = '';
        selectedExtraProofPath.value = '';

        imageFile = null;

        // ===================================================
        // SHOW SUCCESS DIALOG
        // ===================================================

        showCreatedSuccessDialog(
          phone: createdPhone,
          pin: createdPin,
          password: createdPassword,
        );
      }
      // =====================================================
      // ERROR
      // =====================================================
      else {
        final msg = (res is Map && res['message'] != null)
            ? res['message'].toString()
            : "Something error";

        Get.snackbar(
          "Wrong",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("ADD SUB RESELLER ERROR: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
