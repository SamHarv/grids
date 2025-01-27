import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/providers/providers.dart';

class ToolbarItemWidget extends ConsumerStatefulWidget {
  /// Widget to sit in bottom toolbar on grid page

  final IconData icon;
  final Function onTap;

  const ToolbarItemWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ToolbarItemWidgetState();
}

class _ToolbarItemWidgetState extends ConsumerState<ToolbarItemWidget> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkMode);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        // 1/5 of screen width - 48 padding
        width: MediaQuery.sizeOf(context).width / 5 - 48,
        child: Column(
          // Centre vertically in toolbar
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 40,
              color: isDarkMode ? Colors.grey[100] : Colors.grey[900],
            ),
          ],
        ),
      ),
      onTap: () => widget.onTap(),
    );
  }
}
