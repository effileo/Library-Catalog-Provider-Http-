import 'package:flutter/material.dart';

class AppConstants {
  static const String apiBaseUrl = 'https://openlibrary.org';
  static const String appName = 'Digital Library Catalog';
  static const int searchLimit = 20;
  static const String defaultCoverPlaceholder = 'https://via.placeholder.com/150x200?text=No+Cover';
}

class AppColors {
  static const Color primary = Color(0xFF1B3A5C);
  static const Color secondary = Color(0xFFF5A623);
  static const Color background = Color(0xFFF9F6F0);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
}

class AppTextStyles {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle captionText = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}
