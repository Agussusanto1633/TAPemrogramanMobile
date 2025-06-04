import 'package:flutter/material.dart';
import 'package:servista/core/theme/app_style.dart';

PreferredSize transparentAppBarWidget({bool isDarkStyle = true}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(0),
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle:
          isDarkStyle ? systemUiOverlayDarkStyle : systemUiOverlayLightStyle,
    ),
  );
}
