import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../domains/thired_part_loyalty_repo/thired_part_loyalty_repo.dart';
import '../main.dart';
import '../model/thired_party_card_model.dart';
import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_widgets/custom_progress_dialog.dart';

class ThiredPartyCardController extends GetxController {
  final ThiredPartyAndLoyalityCardRepo _thiredPartyAndLoyalityCardRepo =
      ThiredPartyAndLoyalityCardRepo.instance();

  final RxString _codeNumber = "".obs;
  final RxBool _isThiredPartCard = false.obs;
  final Rx<Color> _color = MyColors.lightBlueColor.obs;
  RxMap<String, GiftAndLoyaltyCard> thiredPartyGiftCardsList =
      <String, GiftAndLoyaltyCard>{}.obs;
  RxMap<String, GiftAndLoyaltyCard> loaylityCardsList =
      <String, GiftAndLoyaltyCard>{}.obs;

  String get codeNumber {
    return _codeNumber.value;
  }

  bool get isThiredPartyCard {
    return _isThiredPartCard.value;
  }

  setCodeNumber(String newCode) {
    _codeNumber.value = newCode;
  }

  setIsThiredarty(bool newValue) {
    _isThiredPartCard.value = newValue;
  }

  Rx<Color> get cardColor {
    return _color;
  }

  setCardColor(Color newColor) {
    _color.value = newColor;
  }

  Future<bool> saveCardToSqlite(
      {required GiftAndLoyaltyCard giftAndLoyaltyCard,
      GiftAndLoyaltyCard? previousGiftAndLoyaltyCard}) async {
    try {
      await _thiredPartyAndLoyalityCardRepo.saveCard(
          giftAndLoyaltyCard: giftAndLoyaltyCard);
      kPrint("card Id is ${giftAndLoyaltyCard.cardId}");

      // if (previousGiftAndLoyaltyCard != null) {
      //   thiredPartyGiftCardsList[previousGiftAndLoyaltyCard.cardId] =
      //       giftAndLoyaltyCard;
      // } else {
      thiredPartyGiftCardsList[giftAndLoyaltyCard.cardId] = giftAndLoyaltyCard;
      // }

      //thiredPartyGiftCardsList.value.add(giftAndLoyaltyCard);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> saveLoyalityCardToSqlite(
      {required GiftAndLoyaltyCard giftAndLoyaltyCard}) async {
    try {
      await _thiredPartyAndLoyalityCardRepo.saveLoyalityCard(
          giftAndLoyaltyCard: giftAndLoyaltyCard);

      loaylityCardsList[giftAndLoyaltyCard.cardId] = giftAndLoyaltyCard;

      //loaylityCardsList.value.add(giftAndLoyaltyCard);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> getLoyalityCardsFromSqlite({required String userId}) async {
    try {
      await _thiredPartyAndLoyalityCardRepo
          .getAllLoyalityCards(userId: userId)
          .then((value) {
        // kPrint("list is ${value.length} $userId");
        // // ignore: avoid_single_cascade_in_expression_statements, invalid_use_of_protected_member
        // loaylityCardsList.value.addAll(value);
        value.forEach((element) {
          loaylityCardsList[element.cardId] = element;
          // kPrint("list is  ${element.cardId}");
        });
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> getThiredPartyCardsFromSqlite({required String userName}) async {
    try {
      await _thiredPartyAndLoyalityCardRepo
          .getAllThiredPartyCards(userId: userName)
          .then((value) {
        // ignore: avoid_single_cascade_in_expression_statements, invalid_use_of_protected_member
        // thiredPartyGiftCardsList.value.addAll(value);
        value.forEach((element) {
          thiredPartyGiftCardsList[element.cardId] = element;
          // kPrint("list is  ${element.cardId}");
        });
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteThiredPartyCard(
      String cardId, BuildContext context) async {
    try {
      await _thiredPartyAndLoyalityCardRepo
          .deleteThiredPartyCard(cardId: cardId)
          .then((value) {
        thiredPartyGiftCardsList.removeWhere((key, value) => key == cardId);
        thiredPartyGiftCardsList.refresh();
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteLoyalityCard(String cardId, BuildContext context) async {
    try {
      await _thiredPartyAndLoyalityCardRepo
          .deleteLoyalityCard(cardId: cardId)
          .then((value) {
        loaylityCardsList.removeWhere((key, value) => key == cardId);
        loaylityCardsList.refresh();
      });
      return true;
    } catch (error) {
      return false;
    }
  }
}
