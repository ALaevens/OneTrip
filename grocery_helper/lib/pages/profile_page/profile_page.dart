import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grocery_helper/api/models/homegroup.dart';
import 'package:grocery_helper/widgets/text_entry_dialog.dart';
import 'package:grocery_helper/pages/profile_page/widgets/homegroup_card_widget.dart';
import 'package:grocery_helper/pages/profile_page/widgets/profile_card_widget.dart';
import 'package:grocery_helper/api/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform, File;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _userInfo;
  late Future<bool> _isLoaded;

  Future<bool> _loadProfile() async {
    User? userInfo = await User.fetchUser();

    if (userInfo != null) {
      _userInfo = userInfo;
      return true;
    }

    return false;
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(text),
        action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.onError,
          label: "Dismiss",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoaded = _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isLoaded,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProfileCard(
                      userInfo: _userInfo,
                      onTapPhoto: () async {
                        if (Platform.isAndroid) {
                          final ImagePicker picker = ImagePicker();
                          final XFile? photo = await picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 70,
                              maxWidth: 400,
                              maxHeight: 400);

                          if (photo == null) {
                            return;
                          }
                          File file = File(photo.path);

                          User? response = await _userInfo.uploadImage(file);
                          if (response != null) {
                            setState(() {
                              _userInfo = response;
                            });
                          }
                        } else {
                          showError(
                              "This feature is only available on Android");
                        }
                      },
                      onLogout: () async {
                        const storage = FlutterSecureStorage();
                        await storage.delete(key: "token");

                        if (mounted) {
                          Navigator.pushReplacementNamed(context, "/login");
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _userInfo.homegroup == null
                        ? CreateJoinHomegroup(
                            invites: _userInfo.homegroupInvites,
                            onJoin: (id) async {
                              User? response =
                                  await _userInfo.patch(homegroup: id);

                              if (response != null) {
                                setState(() {
                                  _userInfo = response;
                                });
                              }
                            },
                            onCreate: () async {
                              String? name = await createHomegroupDialog(
                                context,
                                "Create Homegroup",
                                "Homegroup Name",
                                defaultValue: "${_userInfo.username}'s Kitchen",
                              );
                              if (name == null) {
                                return;
                              }

                              if (name == "") {
                                showError("Homegroup name must not be empty");
                                return;
                              }

                              Homegroup? hg =
                                  await Homegroup.createHomegroup(name);
                              if (hg == null) {
                                return;
                              }

                              User? response =
                                  await _userInfo.patch(homegroup: hg.id);

                              if (response != null) {
                                setState(() {
                                  _userInfo = response;
                                });
                              }
                            },
                          )
                        : EditHomegroup(
                            homegroupID: _userInfo.homegroup!,
                          )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
