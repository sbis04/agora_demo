import 'package:flutter/material.dart';

class AgoraUser {
  final int uid;
  final String? userAccount;
  String? name;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.userAccount,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
  });
}
