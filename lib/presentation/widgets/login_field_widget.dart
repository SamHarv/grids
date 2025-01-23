import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '/controller/constants/constants.dart';
import '/controller/state_management/providers.dart';

class LoginFieldWidget extends ConsumerWidget {
  final TextEditingController textController;
  final bool obscurePassword;
  final String hintText;
  final double mediaWidth;

  const LoginFieldWidget({
    super.key,
    required this.textController,
    required this.obscurePassword,
    required this.hintText,
    required this.mediaWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    return SizedBox(
      width: mediaWidth * 0.8,
      height: 60,
      child: TextField(
        style: isDarkMode ? darkFont : lightFont,
        controller: textController,
        textInputAction: TextInputAction.next,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white : Colors.grey.shade500,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(64),
            ),
          ),
          enabledBorder: isDarkMode
              ? null
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.grey.shade500,
                  ),
                ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white : Colors.grey.shade500,
            ),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontFamily: "Open Sans",
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
