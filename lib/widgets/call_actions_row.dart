import 'package:flutter/material.dart';
import 'package:flutter_agora_demo/widgets/call_action_button.dart';

class CallActionsRow extends StatelessWidget {
  const CallActionsRow({
    super.key,
    required this.isMicEnabled,
    required this.isVideoEnabled,
    required this.onCallEnd,
    required this.onToggleAudio,
    required this.onToggleCamera,
    required this.onSwitchCamera,
  });

  final bool isMicEnabled;
  final bool isVideoEnabled;
  final Function()? onCallEnd;
  final Function()? onToggleAudio;
  final Function()? onToggleCamera;
  final Function()? onSwitchCamera;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CallActionButton(
            callEnd: true,
            icon: Icons.call_end,
            onTap: onCallEnd,
          ),
          CallActionButton(
            icon: isMicEnabled ? Icons.mic : Icons.mic_off,
            isEnabled: isMicEnabled,
            onTap: onToggleAudio,
          ),
          CallActionButton(
            icon: isVideoEnabled
                ? Icons.videocam_rounded
                : Icons.videocam_off_rounded,
            isEnabled: isVideoEnabled,
            onTap: onToggleCamera,
          ),
          CallActionButton(
            icon: Icons.cameraswitch_rounded,
            onTap: onSwitchCamera,
          ),
        ],
      ),
    );
  }
}
