import 'package:flutter/material.dart';
import 'package:one_trip/api/models/user.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:one_trip/theme.dart';

class ProfileCard extends StatelessWidget {
  final User userInfo;
  final Function() onTapPhoto;
  final Function() onLogout;
  const ProfileCard(
      {super.key,
      required this.userInfo,
      required this.onTapPhoto,
      required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 42,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: userInfo.imageUrl != null
                        ? NetworkImage(userInfo.imageUrl!)
                        : Image(
                            image: Svg('assets/images/person.svg',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ).image,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    // https://github.com/flutter/flutter/issues/42901#issuecomment-708050484
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onTapPhoto(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userInfo.firstName} ${userInfo.lastName}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text("@${userInfo.username}",
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: bottomButtonStyle,
          onPressed: () => onLogout(),
          child: const Text("Log out"),
        )
      ],
    );
  }
}
