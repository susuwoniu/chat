import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

Widget Avatar(
    {String? name,
    String? uri,
    Function? onTap,
    double? size,
    double? elevation,
    Widget? child}) {
  return CircularProfileAvatar(
    uri ??
        '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
    child: child,
    radius: size ?? 24, // sets radius, default 50.0
    backgroundColor: name == null ? Color(0xfff2f2f7) : Colors.lightBlueAccent,

    // BACKGROUND_COLORS[get_random_index(BACKGROUND_COLORS
    //     .length)],
    // sets background color, default Theme.of(context).colorScheme.onPrimary
    borderWidth: 0, // sets border, default 0.0
    initialsText: name != null && name.characters.isNotEmpty
        ? Text(
            name.characters.take(1).join(),
            style: TextStyle(
                fontSize: size != null ? size - 8 : 15, color: Colors.white),
          )
        : const Text(
            ''), // sets initials text, set your own style, default Text('')
    borderColor: Colors
        .transparent, // sets border color, default Theme.of(context).colorScheme.onPrimary
    elevation: elevation ??
        0.0, // sets elevation (shadow of the profile picture), default value is 0.0
    foregroundColor: Colors.brown.withOpacity(
        0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
    cacheImage: true, // allow widget to cache image against provided url
    // imageFit: BoxFit.cover,
    onTap: () {
      if (onTap != null) {
        onTap();
      }
    }, // sets on tap
    showInitialTextAbovePicture:
        false, // setting it true will show initials text above profile picture, default false
    errorWidget: (context, url, error) {
      return SizedBox.shrink();
    },
  );
}
