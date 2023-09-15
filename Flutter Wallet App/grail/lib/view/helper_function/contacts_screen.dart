import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controller/home_screen_controller.dart';
import '../../controller/transfer_giftcard_controller.dart';
import 'colors.dart';
import 'contact_card_view.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen(bool getVoucherTransferContacts, {Key? key}) : super(key: key) {
    voucherTransfer = getVoucherTransferContacts;
  }
  bool? voucherTransfer;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {


  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  TransferGiftCardController transferGiftCardController = Get.put(TransferGiftCardController());
  bool isLoading = true;
  String searchQuery = '';
  // List<Contact> contacts = [];


  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
    });

    if (await Permission.contacts.request().isGranted) {
      // Permission granted, fetch contacts
      await homeScreenController.getContactsFromServer();
      setState(() {
        isLoading = false;
      });
    } else {
      // Permission denied, display a message
      PermissionStatus permissionStatus = await Permission.contacts.request();
      if(permissionStatus.isGranted){
        await homeScreenController.getContactsFromServer();
        setState(() {
          isLoading = false;
        });
      }
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text('Please grant permission to access contacts.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //homeScreenController.refreshHash();
    // homeScreenController.getContactsFromServer();
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
          title: Text("contact_header".tr,
            style: const TextStyle(
                fontSize: 24,
                color: MyColors.newAppPrimaryColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        body:
        Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rest of your code...
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'shop_search'.tr,
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            //SizedBox(width: 16.0),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      // Wrap the loop with a Visibility widget
                      Visibility(
                        visible: !isLoading, // Show the contact list when loading contacts is completed
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: homeScreenController.contactsList.length,
                          itemBuilder: (context, index) {
                            final contact = homeScreenController.contactsList[index];
                            final contactName = contact.username ?? '';

                            if (contactName.toLowerCase().contains(searchQuery.toLowerCase())) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16, left: 6, right: 6),
                                child: InkWell(
                                  onTap: () {
                                    if (widget.voucherTransfer == true) {
                                      transferGiftCardController
                                          .voucherOwnershipTransferTextController
                                          .text = contactName;
                                      Get.back();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                    child: contactCard(contact, context),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Add the loader container
            Visibility(
              visible: isLoading,
              child: Container(
                height: Get.height,
                width: Get.width,
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
        // GetBuilder<HomeScreenController>(
        //     init: HomeScreenController(),
        //     builder: (controller) {
        //       return Stack(
        //         children: [
        //           Container(
        //             width: Get.width,
        //             height: Get.height,
        //             color: Colors.white,
        //             child: SingleChildScrollView(
        //               child: Center(
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                   Padding(
        //                     padding: EdgeInsets.only(left: 16.w, right: 16.w),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Expanded(
        //                           child: TextField(
        //                             decoration: InputDecoration(
        //                               hintText: 'shop_search'.tr,
        //                               border: InputBorder.none,
        //                             ),
        //                           ),
        //                         ),
        //                       //SizedBox(width: 16.0),
        //                         IconButton(
        //                           icon: const Icon(Icons.search),
        //                           onPressed: () {},
        //                       ),
        //                     ],
        //                 ),
        //                   ),
        //                     for (int i = 0;
        //                     i < controller.contactsList.length;
        //                     i++)
        //                       Padding(
        //                         padding: const EdgeInsets.only(
        //                             top: 16, left: 6, right: 6),
        //                         child: InkWell(
        //                           onTap: () {
        //                             if (widget.voucherTransfer==true) {
        //                               transferGiftCardController
        //                                   .voucherOwnershipTransferTextController
        //                                   .text =
        //                               controller
        //                                   .contactsList[i].username!;
        //                               Get.back();
        //                             }
        //                           },
        //                           child: contactCard(
        //                               controller.contactsList[i], context),
        //                         ),
        //                       ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           if (isLoading)
        //             Container(
        //               height: Get.height,
        //               width: Get.width,
        //               color: Colors.transparent,
        //               child: const Center(
        //                 child: CircularProgressIndicator(),
        //               ),
        //             ),
        //         ],
        //       );
        //     }

    );
  }
}

