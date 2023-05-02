import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_agora_demo/res/palette.dart';
import 'package:flutter_agora_demo/widgets/pre_joining_dialog.dart';

class CreateChannelPage extends StatefulWidget {
  const CreateChannelPage({super.key});

  @override
  State<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  late final FocusNode _unfocusNode;
  late final TextEditingController _channelNameController;

  bool _isCreatingChannel = false;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _unfocusNode = FocusNode();
    _channelNameController = TextEditingController();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    0.0,
                    30.0,
                    0.0,
                    8.0,
                  ),
                  child: Text(
                    'Create channel',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    0.0,
                    8.0,
                    0.0,
                    24.0,
                  ),
                  child: Text(
                    'Enter a channel name to generate token. The token will be valid for 1 hour.',
                    style: TextStyle(
                      color: Color(0xFF797979),
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _channelNameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Channel Name',
                    labelStyle: const TextStyle(
                      color: lightBlue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    hintText: 'Enter your channel name...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF57636C),
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: lightBlue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: lightBlue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24.0),
                _isCreatingChannel
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()],
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => PreJoiningDialog(),
                            );

                            // setState(() => _isCreatingChannel = true);
                            // final input = <String, dynamic>{
                            //   'channelName': _channelNameController.text,
                            // };
                            // try {
                            //   final response = await FirebaseFunctions.instance
                            //       .httpsCallable(
                            //         'generateToken',
                            //         options: HttpsCallableOptions(),
                            //       )
                            //       .call(input);
                            //   final token = response.data as String?;
                            //   if (token != null) {
                            //     // ignore: use_build_context_synchronously
                            //     showSnackBar(
                            //       context,
                            //       'Token generated successfully!',
                            //     );
                            //   }
                            // } catch (e) {
                            //   showSnackBar(
                            //     context,
                            //     'Error generating token: $e',
                            //   );
                            // } finally {
                            //   setState(() => _isCreatingChannel = false);
                            // }
                          },
                          child: const Text('Generate Token'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
