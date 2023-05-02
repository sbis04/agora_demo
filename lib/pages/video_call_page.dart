import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter_agora_demo/res/palette.dart';
import 'package:flutter_agora_demo/utils/remote_user.dart';
import 'package:flutter_agora_demo/widgets/call_actions_row.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.isMicEnabled,
    required this.isVideoEnabled,
  });

  final String appId;
  final String token;
  final String channelName;
  final bool isMicEnabled;
  final bool isVideoEnabled;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _agoraEngine;
  late final VideoDimensions _videoDimensions;

  final _users = <AgoraUser>{};
  int? _currentUid;

  bool _isMicEnabled = false;
  bool _isVideoEnabled = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _users.clear();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _agoraEngine.leaveChannel();
    await _agoraEngine.destroy();
  }

  Future<void> _initialize() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _videoDimensions = const VideoDimensions(width: 1080, height: 1980);
    } else {
      _videoDimensions = const VideoDimensions(width: 1920, height: 1080);
    }
    setState(() {
      _isMicEnabled = widget.isMicEnabled;
      _isVideoEnabled = widget.isVideoEnabled;
    });
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    final options = ChannelMediaOptions(
      publishLocalAudio: _isMicEnabled,
      publishLocalVideo: _isVideoEnabled,
    );
    await _agoraEngine.joinChannel(
      widget.token,
      widget.channelName,
      null,
      0,
      options,
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    _agoraEngine = await RtcEngine.create(widget.appId);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = _videoDimensions;
    configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await _agoraEngine.setVideoEncoderConfiguration(configuration);
    await _agoraEngine.enableAudio();
    await _agoraEngine.enableVideo();
    await _agoraEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _agoraEngine.setClientRole(ClientRole.Broadcaster);
    await _agoraEngine.muteLocalAudioStream(!widget.isMicEnabled);
    await _agoraEngine.muteLocalVideoStream(!widget.isVideoEnabled);
  }

  void _addAgoraEventHandlers() {
    _agoraEngine.setEventHandler(
      RtcEngineEventHandler(
        error: (code) {
          final info = 'LOG::onError: $code';
          print(info);
        },
        // localUserRegistered: (uid, userAccount) {
        //   final info =
        //       'LOG::localUserRegistered: $uid, userAccount: $userAccount';
        //   print(info);
        //   setState(() {
        //     _currentUid = uid;
        //     _users.add(
        //       AgoraUser(
        //         uid: uid,
        //         userAccount: userAccount,
        //         videoHeight: 1080,
        //         videoWidth: 1920,
        //         isAudioEnabled: _isMicEnabled,
        //         isVideoEnabled: _isVideoEnabled,
        //         view: const rtc_local_view.SurfaceView(),
        //       ),
        //     );
        //   });
        // },
        joinChannelSuccess: (channel, uid, elapsed) {
          final info = 'LOG::onJoinChannel: $channel, uid: $uid';
          print(info);
          setState(() {
            _currentUid = uid;
            _users.add(
              AgoraUser(
                uid: uid,
                // userAccount: userAccount,
                videoWidth: _videoDimensions.width,
                videoHeight: _videoDimensions.height,
                isAudioEnabled: _isMicEnabled,
                isVideoEnabled: _isVideoEnabled,
                view: const rtc_local_view.SurfaceView(),
              ),
            );
          });
        },
        firstLocalAudioFrame: (elapsed) {
          final info = 'LOG::firstLocalAudio: $elapsed';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == _currentUid) {
              setState(() => user.isAudioEnabled = _isMicEnabled);
            }
          }
        },
        firstLocalVideoFrame: (width, height, elapsed) {
          final info = 'LOG::firstLocalVideo: $width x $height';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == _currentUid) {
              setState(
                () => user
                  ..videoWidth = width
                  ..videoHeight = height
                  ..isVideoEnabled = _isVideoEnabled
                  ..view = const rtc_local_view.SurfaceView(),
              );
            }
          }
        },
        localVideoStateChanged: (localVideoState, error) {
          final info = 'LOG::localVideoStateChanged: $localVideoState, $error';
          // for (AgoraUser user in _users) {
          //   if (user.uid == _currentUid) {
          //     setState(() => user.isVideoEnabled =
          //         localVideoState != LocalVideoStreamState.Stopped);
          //   }
          // }
          print(info);
        },
        localAudioStateChanged: (state, error) {
          final info = 'LOG::localAudioStateChanged: $state, $error';
          // for (AgoraUser user in _users) {
          //   if (user.uid == _currentUid) {
          //     setState(
          //         () => user.isAudioEnabled = state != AudioLocalState.Stopped);
          //   }
          // }
          print(info);
        },
        leaveChannel: (stats) {
          print('LOG::onLeaveChannel');
          setState(() => _users.clear());
        },
        userInfoUpdated: (uid, userInfo) {
          final info = 'LOG::userInfoUpdated: $uid, ${userInfo.userAccount}';
          print(info);
        },
        userJoined: (uid, elapsed) {
          final info = 'LOG::userJoined: $uid';
          print(info);
          setState(
            () => _users.add(
              AgoraUser(
                uid: uid,
                videoWidth: _videoDimensions.width,
                videoHeight: _videoDimensions.height,
                view: rtc_remote_view.SurfaceView(
                  channelId: widget.channelName,
                  uid: uid,
                ),
              ),
            ),
          );
        },
        userOffline: (uid, elapsed) {
          final info = 'LOG::userOffline: $uid';
          print(info);
          AgoraUser? userToRemove;
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              userToRemove = user;
            }
          }
          setState(() => _users.remove(userToRemove));
        },
        firstRemoteAudioFrame: (uid, elapsed) {
          final info = 'LOG::firstRemoteAudio: $uid';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() => user.isAudioEnabled = true);
            }
          }
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
          final info = 'LOG::firstRemoteVideo: $uid ${width}x $height';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(
                () => user
                  ..videoWidth = width
                  ..videoHeight = height
                  ..isVideoEnabled = true
                  ..view = rtc_remote_view.SurfaceView(
                    channelId: widget.channelName,
                    uid: uid,
                  ),
              );
            }
          }
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          final info = 'LOG::remoteVideoStateChanged: $uid $state $reason';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() =>
                  user.isVideoEnabled = state != VideoRemoteState.Stopped);
            }
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          final info = 'LOG::remoteAudioStateChanged: $uid $state $reason';
          print(info);
          for (AgoraUser user in _users) {
            if (user.uid == uid) {
              setState(() =>
                  user.isAudioEnabled = state != AudioRemoteState.Stopped);
            }
          }
        },
      ),
    );
  }

  Future<void> _onCallEnd(BuildContext context) async {
    await _agoraEngine.leaveChannel();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onToggleAudio() {
    setState(() {
      _isMicEnabled = !_isMicEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          user.isAudioEnabled = _isMicEnabled;
        }
      }
    });
    _agoraEngine.muteLocalAudioStream(!_isMicEnabled);
  }

  void _onToggleCamera() {
    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
      for (AgoraUser user in _users) {
        if (user.uid == _currentUid) {
          setState(() => user.isVideoEnabled = _isVideoEnabled);
        }
      }
    });
    _agoraEngine.muteLocalVideoStream(!_isVideoEnabled);
  }

  void _onSwitchCamera() => _agoraEngine.switchCamera();

  /// Video layout wrapper
  Widget _viewRows() {
    switch (_users.length) {
      case 1:
        return Column(
          children: [
            _videoView(_users.first),
          ],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow({_users.elementAt(0)}),
            _expandedVideoRow({_users.elementAt(1)}),
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            _expandedVideoRow({_users.elementAt(0), _users.elementAt(1)}),
            _expandedVideoRow({_users.elementAt(2)}),
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            _expandedVideoRow({_users.elementAt(0), _users.elementAt(1)}),
            _expandedVideoRow({_users.elementAt(2), _users.elementAt(3)}),
          ],
        );
      default:
    }
    return Container();
  }

  Widget _videoView(AgoraUser user) => Expanded(
        child: user.videoHeight == null || user.videoWidth == null
            ? const SizedBox.expand()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: user.videoHeight! / user.videoWidth!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: user.isAudioEnabled ?? false
                            ? lightBlue
                            : Colors.red,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            maxRadius: 36,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 40.0,
                            ),
                          ),
                        ),
                        if (user.isVideoEnabled ?? false)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: user.view,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
      );

  /// Video view row wrapper
  Widget _expandedVideoRow(Set<AgoraUser> users) {
    final wrappedViews = users.map<Widget>(_videoView).toList();
    return Expanded(child: Row(children: wrappedViews));
  }

  @override
  Widget build(BuildContext context) {
    // print('CURRENT USER: ${_currentUid}, ${_currentUser.uid}}');
    // print('USERS: ${_users.map((e) => '${e.uid}: ${e.userAccount}')}');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(
              Icons.meeting_room_rounded,
              color: Colors.white54,
            ),
            const SizedBox(width: 6.0),
            const Text(
              'Channel name: ',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            Text(
              widget.channelName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white54,
                ),
                const SizedBox(width: 6.0),
                Text(
                  _users.length.toString(),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _viewRows()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CallActionsRow(
                isMicEnabled: _isMicEnabled,
                isVideoEnabled: _isVideoEnabled,
                onCallEnd: () => _onCallEnd(context),
                onToggleAudio: _onToggleAudio,
                onToggleCamera: _onToggleCamera,
                onSwitchCamera: _onSwitchCamera,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
