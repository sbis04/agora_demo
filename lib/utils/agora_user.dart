import 'package:flutter/material.dart';

class AgoraUser {
  final int uid;
  String? name;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
  });
}
