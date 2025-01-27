import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../logic/providers/providers.dart';

class CustomDialogWidget extends ConsumerWidget {
  /// Custom dialog widget

  final String dialogHeading;
  // Content not limited to text
  final Widget? dialogContent;
  final List<Widget> dialogActions;

  const CustomDialogWidget({
    super.key,
    required this.dialogHeading,
    this.dialogContent,
    required this.dialogActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    return AlertDialog(
      title: Text(
        dialogHeading,
        style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
      ),
      content: dialogContent,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      actions: dialogActions,
    );
  }
}
