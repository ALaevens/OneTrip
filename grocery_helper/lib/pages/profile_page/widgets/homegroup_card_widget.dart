import 'package:flutter/material.dart';
import 'package:grocery_helper/api/models/homegroup.dart';
import 'package:grocery_helper/api/models/homegroupinvite.dart';
import 'package:grocery_helper/api/models/simpleuser.dart';
import 'package:grocery_helper/pages/profile_page/widgets/invite_homegroup_dialog.dart';
import 'package:grocery_helper/pages/profile_page/widgets/user_chip.dart';
import 'package:grocery_helper/theme.dart';

class CreateJoinHomegroup extends StatefulWidget {
  final List<int> invites;
  final Function(int id) onJoin;
  final Function() onCreate;

  const CreateJoinHomegroup({
    super.key,
    required this.invites,
    required this.onJoin,
    required this.onCreate,
  });

  @override
  State<CreateJoinHomegroup> createState() => _CreateJoinHomegroupState();
}

class _CreateJoinHomegroupState extends State<CreateJoinHomegroup> {
  late Future<bool> _isLoaded;
  final List<Homegroup> _invitedGroups = [];

  Future<bool> _loadInvites() async {
    for (int id in widget.invites) {
      Homegroup? hg = await Homegroup.get(id);

      if (hg != null) {
        _invitedGroups.add(hg);
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _isLoaded = _loadInvites();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 10,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10), bottom: Radius.zero),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create or Join a Homegroup",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                widget.invites.isEmpty
                    ? const Text(
                        "You have not been invited to join any homegroups")
                    : Center(
                        child: FutureBuilder(
                          future: _isLoaded,
                          builder: ((context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              return ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return JoinRow(
                                      hg: _invitedGroups[index],
                                      onJoin: (id) => widget.onJoin(id),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: _invitedGroups.length);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                        ),
                      ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: bottomButtonStyle,
          onPressed: () => widget.onCreate(),
          child: const Text("Create Homegroup"),
        )
      ],
    );
  }
}

class JoinRow extends StatelessWidget {
  final Homegroup hg;
  final Function(int id) onJoin;
  const JoinRow({super.key, required this.hg, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(hg.name),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary),
              foregroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.onSecondary)),
          onPressed: () => onJoin(hg.id),
          child: Row(
            children: const [
              Text("Join"),
              SizedBox(width: 4),
              Icon(Icons.check)
            ],
          ),
        )
      ],
    );
  }
}

class EditHomegroup extends StatefulWidget {
  final int homegroupID;

  const EditHomegroup({super.key, required this.homegroupID});

  @override
  State<EditHomegroup> createState() => _EditHomegroupState();
}

class _EditHomegroupState extends State<EditHomegroup> {
  late Future<bool> _isLoaded;
  Homegroup? _homegroup;
  List<SimpleUser> _groupUsers = [];
  List<HomegroupInvite> _groupInvites = [];
  Map<HomegroupInvite, SimpleUser> _groupInviteUsers = {};

  Future<bool> _loadHomegroup() async {
    Homegroup? hg = await Homegroup.get(widget.homegroupID);
    if (hg == null) {
      return false;
    }

    _homegroup = hg;
    _groupUsers = [];
    _groupInvites = [];
    _groupInviteUsers = {};

    for (int id in hg.users) {
      SimpleUser? u = await SimpleUser.get(id: id);

      if (u != null) {
        _groupUsers.add(u);
      }
    }

    for (int id in hg.inviteIDs) {
      HomegroupInvite? invite = await HomegroupInvite.get(id);
      if (invite == null || hg.users.contains(invite.userID)) {
        continue;
      }

      SimpleUser? u = await SimpleUser.get(id: invite.userID);

      if (u != null) {
        _groupInvites.add(invite);
        _groupInviteUsers[invite] = u;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _isLoaded = _loadHomegroup();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textstylebase = Theme.of(context).textTheme.titleSmall!;

    final TextStyle textstyle = TextStyle(
        fontSize: textstylebase.fontSize,
        fontWeight: textstylebase.fontWeight,
        color: textstylebase.color,
        decorationColor: textstylebase.color,
        decorationStyle: TextDecorationStyle.solid,
        decoration: TextDecoration.underline);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 10,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10), bottom: Radius.zero),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _isLoaded,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _homegroup!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      Text(
                        "Users",
                        style: textstyle,
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _groupUsers.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return UserRow(
                            user: _groupUsers[index],
                            onButton: (id) {},
                            buttonText: "Kick",
                          );
                        },
                      ),
                      const Divider(),
                      Text(
                        "Pending Invites",
                        style: textstyle,
                      ),
                      const SizedBox(height: 8),
                      _groupInvites.isEmpty
                          ? const Text("None")
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return UserRow(
                                  user:
                                      _groupInviteUsers[_groupInvites[index]]!,
                                  onButton: (id) async {
                                    bool success =
                                        await _groupInvites[index].delete();
                                    if (success) {
                                      setState(() {
                                        _isLoaded = _loadHomegroup();
                                      });
                                    }
                                  },
                                  buttonText: "Cancel",
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: _groupInvites.length)
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        ElevatedButton(
          style: bottomButtonStyle,
          onPressed: () async {
            List<int>? selectedIDs = await inviteHomegroupDialog(context);

            if (selectedIDs == null) {
              return;
            }

            for (int id in selectedIDs) {
              await HomegroupInvite.create(_homegroup!.id, id);
            }

            setState(() {
              _isLoaded = _loadHomegroup();
            });
          },
          child: const Text("Invite"),
        )
      ],
    );
  }
}

class UserRow extends StatelessWidget {
  final SimpleUser user;
  final Function(int id) onButton;
  final String buttonText;
  const UserRow(
      {super.key,
      required this.user,
      required this.onButton,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ButtonStyle(
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(vertical: 8, horizontal: 4)),
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
        foregroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.onSecondary));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SmallUserChip(user: user),
        ElevatedButton(
          style: buttonStyle,
          onPressed: () => onButton(user.id),
          child: Row(
            children: [
              Text(buttonText),
              const SizedBox(width: 4),
              const Icon(Icons.close)
            ],
          ),
        )
      ],
    );
  }
}
