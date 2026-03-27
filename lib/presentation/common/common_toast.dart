import 'package:flutter/material.dart';

class CommonToast {
  /// Displays a toast message to the user.
  ///
  /// Shows a snackbar-style toast with the provided message.
  /// The toast uses the primary color background and white text.
  ///
  /// Parameters:
  /// - [context]: Build context for accessing ScaffoldMessenger
  /// - [title]: Message text to display
  ///
  /// Example:
  /// ```dart
  /// CommonToast.show(
  ///   context: context,
  ///   title: "Operation completed",
  /// );
  /// ```
  static void show({required BuildContext? context, required String title}) {
    if(context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
