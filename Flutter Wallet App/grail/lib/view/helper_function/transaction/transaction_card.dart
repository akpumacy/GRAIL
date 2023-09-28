import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../model/transaction_model.dart';
import '../colors.dart';

Widget transactionCard(TransactionModel t, BuildContext context){
  String giftCardText = "";
  String imageAssetPath = "";
  if(t.orderStatus == "redeem"){
    giftCardText = "prog_Redeemed".tr;
    imageAssetPath = "assets/redeem_new.png";
  }
  if(t.orderStatus == "outgoingComplete"){
    giftCardText = "prog_OwnershipTransferred".tr;
    imageAssetPath = "assets/ownershipSend_new.png";
  }
  if(t.orderStatus == "incomingComplete"){
    giftCardText = "prog_OwnershipReceived".tr;
    imageAssetPath = "assets/ownership_new.png";
  }
  if(t.orderStatus == "outgoingTransfer"){
    giftCardText = "prog_AmountTransferred".tr;
    imageAssetPath = "assets/amount_send.png";
  }
  if(t.orderStatus == "incomingTransfer"){
    giftCardText = "prog_AmountReceived".tr;
    imageAssetPath = "assets/transactionCome.png";
  }
  if(t.orderStatus == "purchase"){
    giftCardText = "prog_purchased".tr;
    imageAssetPath = "assets/purchase_new.png";
  }
  if(t.orderStatus == "convertRewards"){
    giftCardText = "convert_rewards".tr;
    imageAssetPath = "assets/purchase_new.png";
  }

  String giftCardAmountSign = "";
  if(t.orderStatus == "redeem" || t.orderStatus == "outgoingTransfer"){
    giftCardAmountSign = "-" + t.amount;
  }
  if(t.orderStatus == "incomingTransfer" || t.orderStatus == "purchase" || t.orderStatus == "convertRewards"){
    giftCardAmountSign = "+" + t.amount;
  }

  return Container(
    height: 70,
    width: 420.w,
    //color: line_gray,
    decoration: const BoxDecoration(
      borderRadius : BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      boxShadow : [BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          offset: Offset(0,4),
          blurRadius: 4
      )],
      color : Color.fromRGBO(255, 255, 255, 1),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Container(
            //   width: 12,
            //   color: t.orderStatus=="redeem" || t.orderStatus=="outgoingComplete" || t.orderStatus=="outgoingTransfer"? Colors.red : Colors.green,
            // ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 36,
              color: Colors.transparent,
              child: Image.asset(imageAssetPath, height: 36,width: 36,),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              width: 150,
              color: Colors.transparent,
              child: Text(giftCardText, style: TextStyle(fontSize: 18.sp, color: MyColors.newAppPrimaryColor, fontWeight: FontWeight.w600),),
            ),
          ],
        ),
        // const SizedBox(
        //   width: 8,
        // ),
        // Container(
        //   width: 36,
        //   color: Colors.transparent,
        //   child: Image.asset(t.actionName=="redeem"? "assets/voucherRedeemed.png" : t.actionName == "transferOwnership" ? "assets/ownership_logo.png" : "assets/voucher.png", height: 36,width: 36,),
        // ),
        // const SizedBox(
        //   width: 8,
        // ),
        // Container(
        //   width: 150,
        //   color: Colors.transparent,
        //   child: Text(t.actionName=="redeem"? "prog_Redeemed".tr : t.actionName == "transferOwnership" ? "prog_OwnershipTransferred".tr : "prog_purchased".tr),
        // ),
        // SizedBox(
        //   width: 54.w,
        // ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: 65.w,
              color: Colors.transparent,
              child: Text(giftCardAmountSign, textAlign: TextAlign.right, style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 20.sp, color: t.orderStatus=="redeem" || t.orderStatus=="outgoingComplete" || t.orderStatus=="outgoingTransfer"? Colors.red : Colors.green,
              ),),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ],
    ),
  );
}