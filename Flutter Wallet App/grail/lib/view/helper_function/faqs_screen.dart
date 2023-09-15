import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'colors.dart';

class FAQsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Text(
          "faqs_text".tr,
          style: TextStyle(
              fontSize: 32.sp,
              color: MyColors.newAppPrimaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          // Center(
          //   child: Text(
          //     'FAQs',
          //     style: TextStyle(
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.blue,
          //     ),
          //   ),
          // ),
          //Divider(),
          // const MaterialSearchBar(
          //   placeholder: 'Search'
          // ),
          SizedBox(height: 8.h),
          QuestionAnswerWidget(
            question: 'question_1'.tr,
            answer: 'answer_1'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_2'.tr,
            answer: 'answer_2'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_3'.tr,
            answer: 'answer_3'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_4'.tr,
            answer: 'answer_4'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_5'.tr,
            answer: 'answer_5'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_6'.tr,
            answer: 'answer_6'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_7'.tr,
            answer: 'answer_7'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_8'.tr,
            answer: 'answer_8'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_9'.tr,
            answer: 'answer_9'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_10'.tr,
            answer: 'answer_10'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_11'.tr,
            answer: 'answer_11'.tr,
          ),
          QuestionAnswerWidget(
            question: 'question_12'.tr,
            answer: 'answer_12'.tr,
          ),
          // Add more QuestionAnswerWidget widgets for remaining questions
        ],
      ),
    );
  }
}

class QuestionAnswerWidget extends StatefulWidget {
  final String question;
  final String answer;

  const QuestionAnswerWidget({
    required this.question,
    required this.answer,
  });

  @override
  _QuestionAnswerWidgetState createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0.sp,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.answer,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        initiallyExpanded: isExpanded,
      ),
    );
  }
}

class MaterialSearchBar extends StatelessWidget {
  final String placeholder;

  const MaterialSearchBar({required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
    );
  }
}