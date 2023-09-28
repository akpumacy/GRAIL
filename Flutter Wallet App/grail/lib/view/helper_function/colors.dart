import 'package:flutter/material.dart';

const Color COLOR_THEME = Color(0xFFF2BC05);
const Color purple_200 = Color(0xFFBB86FC);
const Color purple_500 = Color(0xFF6200EE);
const Color purple_700 = Color(0xFF3700B3);
const Color red = Color(0xFFFF0000);
const Color darkGray = Color(0xFF1e1a1a);
const Color teal_200 = Color(0xFF03DAC5);
const Color teal_700 = Color(0xFF018786);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color orange = Color(0xFFFF9e30);
const Color greenProcessing = Color(0xFF099314);
const Color hint_foreground_material_light = Color(0xFFe05386);

// <!-- USER DEFINED-->
const Color colorPrimary = Color(0xFF188289);
const Color colorPrimaryLighter = Color(0xFFFFFF);
const Color colorPrimaryDark = Color(0xFF363EAD);
const Color colorPrimaryLight = Color(0xFF73AFB4);
const Color colorPrimaryBlack = Color(0xFF000000);
const Color colorAccent = Color(0xFF8E0438);
const Color colorAccentLight = Color(0xFFba275d);
const Color line_gray = Color(0xFFe8e3e5);
const Color gray_1 = Color(0xFF9e9a9a);

const Color customBlue = Color(0xFF3184b5);

const Color toggleButtonFill = Color(0xFFE7FFFF);

const Color colorPumacyGreen = Color(0xFF368058);
const Color colorGiftCardDetails = Color(0xFF3E3E70);

//<color name="pumacyGreen">#368058</color> Color.fromRGBO(54, 128, 88, 0);
//
// <color name="customBlue">#ff3184b5</color>

class MyColors {
  MyColors._();

  static const Color giftCardDetailColor = Color(0xff7F85D7);
  static const Color purpleAppBarColor = Color(0xFF3700B3);
  static const Color greenTealColor = Color(0xFF018786);
  static const Color lightBlueColor = Color(0xFF87CEFA);
  static const Color darkBlueColor = Color(0xFF363EAD);
  static const Color newAppPrimaryColor = Color(0xFF3E3E70);
  static const Color transferGiftCardBtnColor = Color(0xFF363EAD);
  static const Color giftCardDetailsClr = Color(0xFFF2F7FA);
  static const Color transferPartialAmountBtnClr = Color(0xFF3E3E70);
  static const Color redeemGiftCardBtnClr = Color(0xFF7DC22B);
  static const Color textGrayColor = Color(0xFF989898);
  static const Color appAmberColor = Color(0xFFFDB914);
}


bool containsDecimal(String input) {
  final regex = RegExp(r'[.,]');
  return regex.hasMatch(input);
}
