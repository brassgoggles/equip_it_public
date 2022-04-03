import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/entities/employee.dart';

class Constants {

  //
  static bool prodMode = false;

  // Temp user to mock login.
  static Employee user = Employee.update(
    1,
    "Admin",
    "Admin",
    "",
    "0412345678",
    "info@turtleshellsoftware.com",
    DateTime.now(),
    "",
    "manager",
    "employed",
    "admin",
    DateTime.now(),
    DateTime.now(),
    1,
  );

  //#region colors
  static Map<int, Color> color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor equipItPink = MaterialColor(0xFFff9191, color);

  //#endregion

  //#region ResponsiveSizing
  static double formWidgetWidth = 300;
  static double formFieldSpacer = 20;

  static double headingFontSize = 30;
  static double formMarginHorizontal = 50;
  static double imageSize = 400;
  static double textAreaWidth = 625;

  static bool smallInfoWrap = false;
  static bool scrollableHome = false;

  static ScreenWidth currentScreenWidth = ScreenWidth.large;

  // This function allows a query to size certain widgets for multiple device
  // sizes. It provides a number of default arguments so you have the option of
  // full customization if required.
  static void setResponsiveSettings(BuildContext context,
      [int maximumSmallScreenWidth = 610,
      int minimumLargeScreenWidth = 850,
      int maximumSmallScreenHeight = 500,
      int minimumLargeScreenHeight = 875,
      double largeHeadingFontSize = 30,
      double largeFormMarginHorizontal = 50,
      double largeImageSize = 400,
      double largeTextAreaWidth = 625,
      double mediumHeadingFontSize = 20,
      double mediumFormMarginHorizontal = 20,
      double mediumImageSize = 250,
      double mediumTextAreaWidth = 300,      double smallHeadingFontSize = 20,
      double smallFormMarginHorizontal = 20,
      double smallImageSize = 250,
      double smallTextAreaWidth = 300,]) {
    MediaQueryData queryData = MediaQuery.of(context);

    headingFontSize = largeHeadingFontSize;
    formMarginHorizontal = largeFormMarginHorizontal;
    imageSize = largeImageSize;

    if (queryData.size.width > minimumLargeScreenWidth) {
      // The screen is large width.
      smallInfoWrap = false;
      currentScreenWidth = ScreenWidth.large;

      headingFontSize = largeHeadingFontSize;
      formMarginHorizontal = largeFormMarginHorizontal;
      imageSize = largeImageSize;
    } else if (queryData.size.width > maximumSmallScreenWidth) {
      // The screen is medium width.
      smallInfoWrap = false;
      currentScreenWidth = ScreenWidth.small;

      headingFontSize = mediumHeadingFontSize;
      formMarginHorizontal = mediumFormMarginHorizontal;
      imageSize = mediumImageSize;
    } else {
      // The screen is small width.
      smallInfoWrap = true;
      currentScreenWidth = ScreenWidth.small;

      headingFontSize = smallHeadingFontSize;
      formMarginHorizontal = smallFormMarginHorizontal;
      imageSize = smallImageSize;
    }

    if (queryData.size.width < 610 || queryData.size.height < 875) {
      scrollableHome = true;
    }
  }
//#endregion
}

enum ScreenWidth { small, medium, large }
