import 'package:flutter/material.dart';
import 'package:linkingpal/res/common_button.dart';

Future<dynamic> displayDialogBoX({
  required BuildContext context,
  required String headTitle,
  required Widget child1,
  required VoidCallback ontap1,
  required Widget child2,
  required VoidCallback ontap2,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          CustomButton(
            ontap: ontap1,
            child: child1,
          ),
          const SizedBox(height: 8),
          CustomButton(
            ontap: ontap2,
            child: child2,
          ),
        ],
        title: Text(
          "Confirmation",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              headTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    },
  );
}
