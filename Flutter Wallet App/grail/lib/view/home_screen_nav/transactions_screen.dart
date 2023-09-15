import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/home_screen_controller.dart';
import '../../model/transaction_model.dart';
import '../helper_function/colors.dart';
import '../helper_function/transaction/transaction_card.dart';
import '../helper_function/transaction/transaction_date_card.dart';
import '../helper_function/transaction/transaction_details.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<void> future;
  HomeScreenController homeController = Get.put(HomeScreenController());
  @override
  void initState() {
    future = fetchTransactions();
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchTransactions({bool shouldClear = true}) async {
    await homeController.getTransactions(shouldClear: shouldClear);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (homeScreenController) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              //toolbarHeight: 80.h,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                "trans_header".tr,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: colorGiftCardDetails,
                  //color: Colors.white,
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.transparent,
              child: FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: MyColors.greenTealColor,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await fetchTransactions(shouldClear: false);
                            },
                            child: SingleChildScrollView(
                              child: Obx(() {
                                return Column(
                                  children: homeScreenController
                                      .groupedTransactions.entries
                                      .map((entry) {
                                        String date = entry.key;
                                        List<TransactionModel> transactions =
                                            entry.value;
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: transactionDateCard(date),
                                            ),
                                            // const Padding(
                                            //   padding: EdgeInsets.only(
                                            //       top: 6, bottom: 6),
                                            //   child: Divider(
                                            //     height: 1,
                                            //     color: gray_1,
                                            //   ),
                                            // ),
                                            Column(
                                              children: transactions
                                                  .map((t) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 18,
                                                                right: 18,
                                                                top: 6,
                                                                bottom: 6),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(
                                                                TransactionDetailsScreen(t));
                                                          },
                                                          child:
                                                              transactionCard(
                                                                  t, context),
                                                        ),
                                                      ))
                                                  .toList()
                                                  .cast<Widget>(),
                                            ),
                                          ],
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>(),
                                  // for(int i = 0; i < homeScreenController.transactionList.length; i++)
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                  //     child: Column(
                                  //       children: [
                                  //         !homeScreenController.seenTransactionDate.contains(homeScreenController.transactionList[i].createdDate)? transactionDateCard(homeScreenController.transactionList[i]) : const SizedBox(height: 1, width: 1,),
                                  //         transactionCard(homeScreenController.transactionList[i],context)
                                  //       ],
                                  //     ),
                                );
                              }),
                            ),
                          );
                  }),
            ),
          );
        });
  }
}
