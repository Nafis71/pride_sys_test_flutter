import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/presentation/home/view_models/home_vm.dart';

class HomeHelper {
  static void showRestoreAllDialog({required BuildContext context}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Restore all characters?'),
        content: const Text(
          'This clears every saved edit. Home, Favourites, and character details will show cached API data again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Get.find<HomeVM>().restoreAllLocalEdits();
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

}