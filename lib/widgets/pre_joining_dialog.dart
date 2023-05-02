import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PreJoiningDialog extends StatefulWidget {
  const PreJoiningDialog({super.key});

  @override
  State<PreJoiningDialog> createState() => _PreJoiningDialogState();
}

class _PreJoiningDialogState extends State<PreJoiningDialog> {
  bool _isMicEnabled = false;
  bool _isCameraEnabled = false;

  _getMicPermissions() async {
    if (!kIsWeb) {
      final micPermission = await Permission.microphone.request();
      if (micPermission == PermissionStatus.granted) {
        setState(() => _isMicEnabled = true);
      }
    }
  }

  _getCameraPermissions() async {
    if (!kIsWeb) {
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission == PermissionStatus.granted) {
        setState(() => _isCameraEnabled = true);
      }
    }
  }

  _getPermissions() async {
    await _getMicPermissions();
    await _getCameraPermissions();
  }

  @override
  void initState() {
    _getPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Joining Call',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'You are about to join a video call. Please set you mic and camera preferences.',
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () {
                        if (_isMicEnabled) {
                          setState(() => _isMicEnabled = false);
                        } else {
                          _getMicPermissions();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 32.0,
                        child: Icon(
                          _isMicEnabled
                              ? Icons.mic_rounded
                              : Icons.mic_off_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Mic: ${_isMicEnabled ? 'On' : 'Off'}'),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () {
                        if (_isCameraEnabled) {
                          setState(() => _isCameraEnabled = false);
                        } else {
                          _getCameraPermissions();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 32.0,
                        child: Icon(
                          _isCameraEnabled
                              ? Icons.videocam_rounded
                              : Icons.videocam_off_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Camera: ${_isCameraEnabled ? 'On' : 'Off'}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120.0,
                  child: ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   splashFactory: InkRipple.splashFactory,
                    //   // backgroundColor: lightBlue,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12.0),
                    //   ),
                    // ),
                    onPressed: () async {},
                    child: const Text('Join'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
