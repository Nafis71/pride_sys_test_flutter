/// Helper utility for executing tasks after the current frame is built.
///
/// This class provides a convenient way to schedule tasks that should run
/// after the widget tree is built. Useful for operations that require
/// the widget tree to be fully initialized, such as:
/// - Accessing BuildContext after widget initialization
/// - Triggering API calls after UI is ready
/// - Performing operations that depend on widget dimensions
///
/// The task is executed once after the current frame is rendered.
///
/// Example:
/// ```dart
/// PostFrame.executeTask(
///   task: () {
///     // This runs after the frame is built
///     viewModel.loadData();
///   },
/// );
/// ```
import 'package:flutter/cupertino.dart';

class PostFrame {
  /// Executes a task after the current frame is built.
  ///
  /// Schedules the provided task to run after the widget tree is fully
  /// rendered. This ensures that any context-dependent operations can
  /// safely access the widget tree.
  ///
  /// Parameters:
  /// - [task]: The function to execute after frame build
  ///
  /// Use cases:
  /// - Loading data after widget initialization
  /// - Accessing MediaQuery or Theme after build
  /// - Triggering navigation after UI is ready
  ///
  /// Example:
  /// ```dart
  /// PostFrame.executeTask(
  ///   task: () => viewModel.initialize(),
  /// );
  /// ```
  static void executeTask({required Function task}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      task();
    });
  }
}
