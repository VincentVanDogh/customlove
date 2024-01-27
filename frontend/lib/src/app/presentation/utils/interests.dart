import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class Interests {
  static const CustomLoveTheme customLoveTheme = CustomLoveTheme();
  static Color themeColor = customLoveTheme.primaryColor;
  static Map<String, Icon> interests = {
    "sports": Icon(Icons.sports_soccer, color: themeColor),
    "movies": Icon(Icons.movie, color: themeColor),
    "travel": Icon(Icons.flight_takeoff, color: themeColor),
    "science": Icon(Icons.science_outlined, color: themeColor),
    "books": Icon(Icons.book, color: themeColor),
    "music": Icon(Icons.music_note, color: themeColor),
    "art": Icon(Icons.palette, color: themeColor),
    "food": Icon(Icons.fastfood_outlined, color: themeColor),
    "technology": Icon(Icons.android_outlined, color: themeColor),
    "fashion": Icon(Icons.shopping_bag_outlined, color: themeColor),
    "photography": Icon(Icons.photo_camera_outlined, color: themeColor),
    "gaming": Icon(Icons.videogame_asset_outlined, color: themeColor),
    "nature": Icon(Icons.forest, color: themeColor),
    "history": Icon(Icons.account_balance_outlined, color: themeColor),
    "fitness": Icon(Icons.fitness_center_outlined, color: themeColor),
    "crafts": Icon(Icons.content_cut_outlined, color: themeColor),
    "writing": Icon(Icons.create_outlined, color: themeColor),
    "gardening": Icon(Icons.agriculture, color: themeColor),
    "philosophy": Icon(Icons.lightbulb, color: themeColor),
    "coding": Icon(Icons.laptop_chromebook, color: themeColor),
    "default": Icon(Icons.favorite, color: themeColor)
  };

  static Icon getIcon(String interest) {
    if (interests.containsKey(interest)) {
      return interests[interest]!;
    } else {
      return interests["default"]!;
    }
  }

  static IconData getIconData(String interest) {
    return getIcon(interest).icon!;
  }
}
