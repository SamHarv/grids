import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/providers/providers.dart';

class BottomNavBarMenuWidget extends ConsumerStatefulWidget {
  final IconData icon;
  final Function onTap;

  const BottomNavBarMenuWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavBarMenuWidgetState();
}

class _BottomNavBarMenuWidgetState
    extends ConsumerState<BottomNavBarMenuWidget> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkMode);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5 - 48,
        child: Column(
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
