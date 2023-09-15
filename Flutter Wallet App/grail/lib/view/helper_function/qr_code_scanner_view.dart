import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/transfer_giftcard_controller.dart';
import 'colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerView extends StatefulWidget {
  bool? voucherOwnerShipTransfer;
  QRCodeScannerView(bool vTransfer, {Key? key}) : super(key: key) {
    voucherOwnerShipTransfer = vTransfer;
  }

  @override
  State<QRCodeScannerView> createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  //HomeScreenController homeScreenController = Get.put(HomeScreenController());
  TransferGiftCardController transferGiftCardController = Get.put(TransferGiftCardController());
  bool isScanCompleted = false;


  void qrCode(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        if (result != null) {
          transferGiftCardController.voucherOwnershipTransferTextController.text = result!.code!;
          if(isScanCompleted == false){
            Navigator.pop(context);
          }
          isScanCompleted = true;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "QR Code Scanner",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [colorPrimaryDark, colorPrimary],
            ),
          ),
        ),
      ),
      body: GetBuilder<TransferGiftCardController>(
        init: TransferGiftCardController(),
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 500,
                  width: 500,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: qrCode,
                  ),
                ),
              ],
            ),
          );
        }
      ),
      // body: MobileScanner(
      //   fit: BoxFit.contain,
      //   controller: cameraController,
      //   onDetect: (capture) {
      //     final List<Barcode> barcodes = capture.barcodes;
      //     final Uint8List? image = capture.image;
      //     for (final barcode in barcodes) {
      //       debugPrint('Barcode found! ${barcode.rawValue}');
      //     }
      //     transferGiftCardController.voucherOwnershipTransferTextController.text = cameraController
      //   },
      // ),
    );
  }
}





class QRCodeScannerViewVoucher extends StatefulWidget {

  const QRCodeScannerViewVoucher({Key? key}) : super(key: key);

  @override
  _QRCodeScannerViewVoucherState createState() => _QRCodeScannerViewVoucherState();
}

class _QRCodeScannerViewVoucherState extends State<QRCodeScannerViewVoucher> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  //HomeScreenController homeScreenController = Get.put(HomeScreenController());
  TransferGiftCardController transferGiftCardController = Get.put(TransferGiftCardController());
  bool isScanCompleted = false;


  void qrCode(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        if (result != null) {
          transferGiftCardController.voucherRecipientCode.text = result!.code!;
          if(isScanCompleted == false){
            Navigator.pop(context);
          }
          isScanCompleted = true;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "QR Code Scanner",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [colorPrimaryDark, colorPrimary],
            ),
          ),
        ),
      ),
      body: GetBuilder<TransferGiftCardController>(
          init: TransferGiftCardController(),
          builder: (controller) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 500,
                    width: 500,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: qrCode,
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
