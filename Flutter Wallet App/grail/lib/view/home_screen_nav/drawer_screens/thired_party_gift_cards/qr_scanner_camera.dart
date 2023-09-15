import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'create_thired_party_card.dart';

class QRCamScanner extends StatefulWidget {
  static const routeName = "/QRCamScanner";

  QRCamScanner({super.key});

  @override
  State<QRCamScanner> createState() => _QRCamScannerState();
}

class _QRCamScannerState extends State<QRCamScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _camState = false;

  _qrCallback(String? code) {
    setState(() {
      _camState = false;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateThiredPartyCard(code!, true)),);
    });
  }
  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _scanCode();
  }
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child:
              _camState ?
              QRBarScannerCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  _qrCallback(code);
                  //Get.to(() => CreateThiredPartyCard(code!, true));
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateThiredPartyCard(code!, true)),);
                },
              ) : const SizedBox(),
            ),
            InkWell(
              onTap: () {
                //controller!.pauseCamera();
                Get.to(() => CreateThiredPartyCard("", false));
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateThiredPartyCard("", false)),);
              },
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 80.h,
                color: const Color.fromARGB(135, 13, 11, 11),
                child: Center(
                  child: Text(
                    "Enter Data Manually",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
