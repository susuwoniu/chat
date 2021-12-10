import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

Widget Avatar({required String name, String? uri}) {
  return CircularProfileAvatar(
      uri ??
          '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
      radius: 24, // sets radius, default 50.0
      backgroundColor:
          Colors.transparent, // sets background color, default Colors.white
      borderWidth: 0, // sets border, default 0.0
      initialsText: Text(
        name.substring(0, 2),
        style: TextStyle(fontSize: 20, color: Colors.white),
      ), // sets initials text, set your own style, default Text('')
      borderColor: Colors.brown, // sets border color, default Colors.white
      elevation:
          5.0, // sets elevation (shadow of the profile picture), default value is 0.0
      foregroundColor: Colors.brown.withOpacity(
          0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
      cacheImage: true, // allow widget to cache image against provided url
      imageFit: BoxFit.cover,
      onTap: () {
        print('adil');
      }, // sets on tap
      showInitialTextAbovePicture:
          false, // setting it true will show initials text above profile picture, default false
      errorWidget: (context, url, error) {
        return SizedBox.shrink();
      });
}
