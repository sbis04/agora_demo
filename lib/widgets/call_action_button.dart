import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  const CallActionButton({
    super.key,
    this.onTap,
    required this.icon,
    this.callEnd = false,
    this.isEnabled = true,
  });

  final Function()? onTap;
  final IconData icon;
  final bool callEnd;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: callEnd
            ? Colors.redAccent
            : isEnabled
                ? Colors.grey.shade800
                : Colors.white,
        radius: callEnd ? 28 : 24,
        child: Icon(
          icon,
          size: callEnd ? 26 : 22,
          color: callEnd
              ? Colors.white
              : isEnabled
                  ? Colors.white
                  : Colors.grey.shade600,
        ),
      ),
    );
  }
}
