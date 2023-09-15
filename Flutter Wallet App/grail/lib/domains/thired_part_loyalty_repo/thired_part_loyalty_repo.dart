import 'package:grail/domains/thired_part_loyalty_repo/thired_part_loyalty_repo_impl.dart';
import '../../model/thired_party_card_model.dart';

mixin ThiredPartyAndLoyalityCardRepo {
  static final ThiredPartyAndLoyalityCardRepo _instance =
      ThiredPartyAndLoyalityCardRepoImpl();

  static ThiredPartyAndLoyalityCardRepo instance() {
    return _instance;
  }

  Future saveCard({required GiftAndLoyaltyCard giftAndLoyaltyCard});
  Future<List<GiftAndLoyaltyCard>> getAllThiredPartyCards(
      {required String userId});

  Future saveLoyalityCard({required GiftAndLoyaltyCard giftAndLoyaltyCard});
  Future deleteThiredPartyCard({required String cardId});
  Future deleteLoyalityCard({required String cardId});

  Future<List<GiftAndLoyaltyCard>> getAllLoyalityCards(
      {required String userId});
}
