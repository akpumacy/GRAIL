import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/localization_controller.dart';

class LanguageSelectionDialog extends StatefulWidget {
  const LanguageSelectionDialog({Key? key}) : super(key: key);

  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Language/Sprache ändern'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                LocalizationController().changeLocale('English');
                Get.back();
              },
              title: const Text('English'),
            ),
            ListTile(
              onTap: () {
                LocalizationController().changeLocale('Deutsch');
                Get.back();
              },
              title: const Text('Deutsch'),
            ),
          ],
        ),
      ),
    );
  }
}
