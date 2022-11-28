import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:one_trip/api/models/simpleuser.dart';

class SmallUserChip extends StatelessWidget {
  final SimpleUser user;
  final double? radius;
  final Color? textColor;
  const SmallUserChip(
      {super.key, required this.user, this.radius, this.textColor});

  @override
  Widget build(BuildContext context) {
    double baseRadius = radius ?? 30;
    return Row(
      children: [
        CircleAvatar(
          radius: baseRadius,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: baseRadius - 2,
            backgroundColor: Colors.white,
            backgroundImage: user.imageUrl != null
                ? NetworkImage(user.imageUrl!)
                : const Image(
                    image: Svg('assets/images/person.svg', color: Colors.black),
                  ).image,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.onSurface),
            ),
            Text(
              "@${user.username}",
              style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.onSurface),
            ),
          ],
        )
      ],
    );
  }
}
