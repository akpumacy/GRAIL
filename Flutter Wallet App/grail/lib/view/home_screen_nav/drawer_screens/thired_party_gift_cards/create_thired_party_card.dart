import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../controller/home_screen_controller.dart';
import '../../../../controller/thired_party_card_controller.dart';
import '../../../../main.dart';
import '../../../../model/thired_party_card_model.dart';
import '../../../helper_function/colors.dart';
import '../../../helper_function/custom_widgets/custom_field.dart';
import '../../../helper_function/custom_widgets/custom_progress_dialog.dart';
import '../../../helper_function/custom_widgets/custom_text_button.dart';
import '../../../helper_function/enums.dart';
import '3rd_party_card_cell.dart';
import 'card_picker_animation.dart';

class CreateThiredPartyCard extends StatefulWidget {
  static const routeName = "/CreateThiredPartyCard";
  GiftAndLoyaltyCard? giftAndLoyaltyCard;

  bool isReadAble;
  CreateThiredPartyCard( this.qrBarCodeText, this.creatingByScanning,
      {this.giftAndLoyaltyCard, this.isReadAble = false, super.key});

  String qrBarCodeText;
  bool creatingByScanning;
  @override
  State<CreateThiredPartyCard> createState() => _CreateThiredPartyCardState();
}

class _CreateThiredPartyCardState extends State<CreateThiredPartyCard> {
  late TextEditingController codeController;
  FocusNode codeFocusNode = FocusNode();
  late TextEditingController cardNameController;
  FocusNode cardNameFocusNode = FocusNode();
  DateTime pickedDate = DateTime.now();
  String formattedDate = '';
  String previousCardColor = "";
  Uuid uuid = Uuid();
  bool _showQR = true;

  ThiredPartyCardController thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  HomeScreenController homeController = Get.put(HomeScreenController());

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    cardNameController.dispose();
    codeController.dispose();
    codeFocusNode.dispose();
    cardNameFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    codeController = TextEditingController(
        text: widget.giftAndLoyaltyCard != null
            ? widget.giftAndLoyaltyCard!.cardCode
            : '');
    thiredPartyCardController.setCodeNumber(codeController.text);

    cardNameController = TextEditingController(
        text: widget.giftAndLoyaltyCard != null
            ? widget.giftAndLoyaltyCard!.cardName
            : '');
    formattedDate = widget.giftAndLoyaltyCard != null
        ? widget.giftAndLoyaltyCard!.date
        : DateFormat(DateType.yearMonthDay).format(pickedDate);
    if (widget.giftAndLoyaltyCard != null) {
      previousCardColor = widget.giftAndLoyaltyCard!.color;
    }

    kPrint("isrEadable ${widget.isReadAble}");

    super.initState();
  }

  String colorToHex(Color color) {
    return "0x" + color.value.toRadixString(16).padLeft(8, '0');
  }

  createCard() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState!.save();
    CustomProgressDialog.instance.showHideProgressDialog(
      context,
      'Creating...',
      colorPrimary,
    );
    String newUserId =
        homeController.userModel.clientHash!.replaceAll('\$', '');
    GiftAndLoyaltyCard? giftAndLoyaltyCard;

    giftAndLoyaltyCard = GiftAndLoyaltyCard(
        cardCode: codeController.text,
        cardId: widget.giftAndLoyaltyCard != null
            ? widget.giftAndLoyaltyCard!.cardId
            : uuid.v4(),
        cardName: cardNameController.text,
        color: widget.giftAndLoyaltyCard != null
            ? thiredPartyCardController.cardColor.value ==
                    Color(int.parse(widget.giftAndLoyaltyCard!.color))
                ? colorToHex(Color(int.parse(widget.giftAndLoyaltyCard!.color)))
                : colorToHex(thiredPartyCardController.cardColor.value)
            : colorToHex(thiredPartyCardController.cardColor.value),
        date: formattedDate,
        userId: homeController.userModel.username!);

    kPrint(newUserId);
    // bool hasData = false;

    // hasData =
    thiredPartyCardController.isThiredPartyCard
        ? await thiredPartyCardController.saveCardToSqlite(
            giftAndLoyaltyCard: giftAndLoyaltyCard,
            previousGiftAndLoyaltyCard: widget.giftAndLoyaltyCard)
        : await thiredPartyCardController.saveLoyalityCardToSqlite(
            giftAndLoyaltyCard: giftAndLoyaltyCard);

    CustomProgressDialog.instance.hideProgressDialog((val) {});
    //widget.isReadAble = true;
    if (widget.giftAndLoyaltyCard == null) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }

    // return hasData;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.creatingByScanning){
      codeController.text = widget.qrBarCodeText;
    }
    return GetBuilder<ThiredPartyCardController>(
        init: ThiredPartyCardController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                "information".tr,
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: MyColors.newAppPrimaryColor),
              ),
              toolbarHeight: 50.h,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.h, horizontal: 40.w),
                          child: Column(
                            children: [
                              if (widget.giftAndLoyaltyCard != null)
                                SizedBox(
                                  height: 25.h,
                                ),
                              //if (widget.giftAndLoyaltyCard == null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "card_code".tr,
                                    style: TextStyle(
                                        color: MyColors.newAppPrimaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  CustomTextField(
                                      title: "enter_code".tr,
                                      controller: codeController,
                                      suffixIcon: const SizedBox(),
                                      focusNode: codeFocusNode,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      isReadOnly: widget.isReadAble,
                                      nextFocusNode: cardNameFocusNode,
                                      onChange: (newVal) {
                                        // if (newVal.characters.first == " ") {
                                        //   codeController.clear();
                                        // }
                                        if (newVal.isEmpty) {
                                          thiredPartyCardController
                                              .setCodeNumber("");
                                        } else {
                                          thiredPartyCardController
                                              .setCodeNumber(newVal);
                                        }
                                      },
                                      onSaved: () {},
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Please Enter Code";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "card_name".tr,
                                    style: TextStyle(
                                        color: MyColors.newAppPrimaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  CustomTextField(
                                      title: "enter_card_name".tr,
                                      controller: cardNameController,
                                      isReadOnly: widget.isReadAble,
                                      suffixIcon: const SizedBox(),
                                      onChange: (newVal) {},
                                      focusNode: cardNameFocusNode,
                                      keyboardType: TextInputType.text,
                                      maxLines: 5,
                                      nextFocusNode: null,
                                      onSaved: () {},
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Please Enter Card Name";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  Text(
                                    "validity".tr,
                                    style: TextStyle(
                                        color: MyColors.newAppPrimaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 15.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: MyColors.giftCardDetailsClr,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: MyColors.newAppPrimaryColor,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _showDatePicker();
                                                },
                                                child: Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.sp),
                                                ),
                                              )),
                                          Container()
                                        ],
                                      )),
                                  SizedBox(
                                    height: 27.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "select_color".tr,
                                        style: TextStyle(
                                            color: MyColors.newAppPrimaryColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      widget.giftAndLoyaltyCard != null
                                          ?
                                          //Obx(() =>
                                          Expanded(
                                              child: Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 25.w),
                                                child: InkWell(
                                                    onTap: () {
                                                      //onClickChangeColor();
                                                      onChangeColorDialog();
                                                    },
                                                    child: Container(
                                                      height: 25.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Color(int.parse(
                                                              previousCardColor))),
                                                    )),
                                              ),
                                            ))
                                          : Obx(() => Expanded(
                                                child: Center(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.w),
                                                      child: InkWell(
                                                        onTap: () {
                                                          onClickChangeColor();
                                                        },
                                                        child: Container(
                                                          height: 25.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                thiredPartyCardController
                                                                    .cardColor
                                                                    .value,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60.h,
                              ),
                              Obx(() => thiredPartyCardController
                                      .codeNumber.isNotEmpty
                                  ? InkWell(
                                    onTap: () {
                                      if (_showQR) {
                                        _showQR = false;
                                      } else {
                                        _showQR = true;
                                      }
                                      setState(() {});
                                    },
                                    child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (_showQR) {
                                                _showQR = false;
                                              } else {
                                                _showQR = true;
                                              }
                                              setState(() {});
                                            },
                                            child: Text("tap_image".tr,
                                                style: TextStyle(
                                                    color: MyColors
                                                        .newAppPrimaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.sp)),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          // _showQR
                                          // ? QrImageView(
                                          //     data: codeController.text,
                                          //     version: QrVersions.auto,
                                          //     size: 220.0.h,
                                          //   )
                                          // :
                                          BarcodeWidget(
                                            barcode: _showQR
                                                ? Barcode.qrCode(
                                                    errorCorrectLevel:
                                                        BarcodeQRCorrectionLevel
                                                            .high,
                                                  )
                                                : Barcode.gs128(),
                                            data: codeController.text,
                                            width: 240.w,
                                            height: 240.h,
                                          ),
                                        ],
                                      ),
                                  )
                                  : Container())
                            ],
                          ),
                        ),
                      ],
                    ),
                    widget.giftAndLoyaltyCard == null
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: CustomTextButton(
                                buttonColor: MyColors.redeemGiftCardBtnClr,
                                butttonTitle: "save".tr,
                                OnTap: () async {
                                  await createCard();
                                }),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                bottom: 20.h, left: 20.w, right: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextButton(
                                    buttonColor: MyColors.redeemGiftCardBtnClr,
                                    butttonTitle: "delete".tr,
                                    buttonWidth: 120,
                                    OnTap: () {
                                      if (controller.isThiredPartyCard) {
                                        controller
                                            .deleteThiredPartyCard(
                                                widget
                                                    .giftAndLoyaltyCard!.cardId,
                                                context)
                                            .then((value) {
                                          if (value) {
                                            CustomProgressDialog.instance
                                                .showSnackBar(context,
                                                    "Card has been deleted Successfuly");
                                          }
                                        });
                                      } else {
                                        controller
                                            .deleteLoyalityCard(
                                                widget
                                                    .giftAndLoyaltyCard!.cardId,
                                                context)
                                            .then((value) {
                                          if (value) {
                                            CustomProgressDialog.instance
                                                .showSnackBar(context,
                                                    "Card has been deleted Successfuly");
                                          }
                                        });
                                      }

                                      Navigator.of(context).pop();
                                    }),
                                CustomTextButton(
                                    buttonColor: MyColors.redeemGiftCardBtnClr,
                                    butttonTitle: widget.isReadAble
                                        ? "edit".tr
                                        : "save".tr,
                                    buttonWidth: 120,
                                    OnTap: () async {
                                      if (widget.isReadAble) {
                                        setState(() {
                                          widget.isReadAble = false;
                                        });
                                      } else {
                                        await createCard();
                                      }
                                    })
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showDatePicker() async {
    pickedDate = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100)))!;
    formattedDate = DateFormat(DateType.yearMonthDay).format(pickedDate);
    setState(() {});
  }

  void onChangeColorDialog() {
    thiredPartyCardController.setCardColor(Color(int.parse(previousCardColor)));
    showDialog(
        context: context,
        builder: (_) {
          kPrint('previousCardColor $previousCardColor');
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return NewChatItemLongPressDialog(
              onItemPressed: () {},
              firstChild: colorPicker(),
              secondChild: Builder(builder: (context) {
                return Obx(() {
                  return GiftCardCell(
                    giftAndLoyaltyCard: widget.giftAndLoyaltyCard!,
                    onChangeColor:
                        colorToHex(thiredPartyCardController.cardColor.value),
                  );
                });
              }),
            );
          });
        });
  }

  Widget colorPicker() {
    return AlertDialog(
      //alignment: Alignment.center,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorPicker(
              pickerAreaHeightPercent: 0.5,
              paletteType: PaletteType.hslWithLightness,
              pickerColor: widget.giftAndLoyaltyCard != null
                  ? Color(int.parse(widget.giftAndLoyaltyCard!.color))
                  : MyColors.lightBlueColor,
              onColorChanged: (color) {
                thiredPartyCardController.setCardColor(color);
                if (widget.giftAndLoyaltyCard != null) {
                  previousCardColor = colorToHex(color);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void onClickChangeColor() {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorPicker(
                    pickerAreaHeightPercent: 0.5,
                    paletteType: PaletteType.hslWithLightness,
                    pickerColor: widget.giftAndLoyaltyCard != null
                        ? Color(int.parse(widget.giftAndLoyaltyCard!.color))
                        : MyColors.lightBlueColor,
                    onColorChanged: (color) {
                      thiredPartyCardController.setCardColor(color);
                      if (widget.giftAndLoyaltyCard != null) {
                        widget.giftAndLoyaltyCard!.color = colorToHex(color);
                        setState(() {});
                      }
                      // notifier.setChatBgColor(color: color);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      //print(e);
    }
  }

  Widget _customActionButton(
      {required IconData icon,
      required Color color,
      required GestureTapCallback onTap,
      required Color iconColor}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 60.h,
        width: 60.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1))
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 25,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
