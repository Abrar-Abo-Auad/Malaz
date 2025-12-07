
import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryDark = Color(0xFFD4AF37); // Might be better (0xFFC5A059) Do not touch this comment
  static const Color primaryLight = Color(0xFFC5A059); // Was (0xFFB59502) Do not touch this comment
  /// new added
    static const Color goldBorderColor = Color(0xFFFFC000); /// For textField borders
    static const Color pinActive = Color(0xFFFFD240);
    static const Color pinInactive = Color(0xFFB8860B);
    static const Color pinSelected = Color(0xFFFFE680);
  ///

  static const Color secondaryLight = Color(0xFF817F7B);
  static const Color secondaryDark = Color(0xFF817F7B);

  static const Color accent = Color(0xA5615834);

  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF1C2A3A);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1C2A3A); // Was (0xFF081523) Do not touch this comment

  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  static const Color error = Color(0xFFEF4444);

  // static const LinearGradient primaryGradientLight = LinearGradient(
  //   colors: [primaryLight, secondaryLight],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
  //
  // static const LinearGradient primaryGradientDark = LinearGradient(
  //   colors: [primaryDark, secondaryDark],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
  // static const LinearGradient ultraGoldGradient = LinearGradient(
  //   colors: [
  //     Color(0xFFf6e27a),
  //     Color(0xFFf7d774),
  //     Color(0xFFf6c65b),
  //     Color(0xFFe5ac38),
  //     Color(0xFFb6862e),
  //     Color(0xFFe5ac38),
  //     Color(0xFFf6c65b),
  //     Color(0xFFf7d774),
  //     Color(0xFFf6e27a),
  //   ],
  //   stops: [
  //     0.0,
  //     0.15,
  //     0.3,
  //     0.45,
  //     0.6,
  //     0.75,
  //     0.85,
  //     0.95,
  //     1.0,
  //   ],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
static LinearGradient goldGradientbut = LinearGradient(// Nice
    colors: [
      Color(0xFFFFD700), // Vivid Gold
      Color(0xFFFFC700), // Warm Gold
      Color(0xFFFFB300), // Rich Gold
      Color(0xFFFFD700), // Highlight again for metallic shine
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient realGoldGradient = LinearGradient(
    colors: [
      Color(0xFFFFF8D0), // bright highlight
      Color(0xFFFFE680),
      Color(0xFFFFD240),
      Color(0xFFFFC000),
      Color(0xFFB8860B),//
      // Color(0xFFFFB300), // deep gold shadow
      Color(0xFFFFC000),
      Color(0xFFFFD240),
      Color(0xFFFFE680),
      Color(0xFFFFF8D0), // bright reflective
    ],
    stops: [
      0.0, 0.10, 0.22, 0.35, 0.50, 0.65, 0.78, 0.90, 1.0,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


/// How to use LinearGradient....
///
/// for gold color for icon
/// example:
// ShaderMask(
/// shaderCallback: (bounds) => realGoldGradient.createShader(bounds),
//    child: const Icon(
//        Icons.person,
//        color: Colors.white, // مهم! لأنه يُستبدل بال gradient
//    ),
// )
}
