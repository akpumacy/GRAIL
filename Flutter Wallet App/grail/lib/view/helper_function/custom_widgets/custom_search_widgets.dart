import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class SearchField extends StatelessWidget {
  GestureTapCallback onTap;
  TextEditingController searchController;
  FocusNode searchFocusNode;
  SearchField(
      {required this.onTap,
      required this.searchController,
      required this.searchFocusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[400]!))),
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => onTap(),
          //   child: const Icon(
          //     Icons.arrow_back,
          //     size: 25,
          //   ),
          // ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                //autofocus: true,
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontSize: 20.sp,
                  ),

                  contentPadding: const EdgeInsets.all(0),

                  border: InputBorder.none,
                  //suffixIcon: Icon(Icons.cancel_sharp,)
                ),
              ),
            ),
          ),
          // const Icon(
          //   Icons.cancel,
          //   size: 25,
          // ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  GestureTapCallback onTap;
  SearchWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        // height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: MyColors.giftCardDetailsClr,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Search here",
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
            const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
