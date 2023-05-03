import 'package:flutter/material.dart';

class AgoraUser {
  final int uid;
  final String? userAccount;
  String? name;
  // int? videoWidth;
  // int? videoHeight;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.userAccount,
    this.name,
    // this.videoWidth,
    // this.videoHeight,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
  });
}
