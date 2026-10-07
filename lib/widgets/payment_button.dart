import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';
import 'custom_text.dart';

class PaymentButton extends StatelessWidget {
  PaymentButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
    this.imagelink,
  });

  LanguagesController languagesController = Get.put(LanguagesController());

  String? buttonName;
  String? imagelink;
  Color? mycolor;
  VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: mycolor?.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Icon bubble
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagelink.toString(), color: mycolor),
            ),
            const SizedBox(width: 14),

            // Label
            Expanded(
              child: KText(
                text: buttonName.toString(),
                color: mycolor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Arrow pill
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: mycolor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
