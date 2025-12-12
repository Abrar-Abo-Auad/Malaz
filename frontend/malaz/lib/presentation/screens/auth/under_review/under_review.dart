import 'package:flutter/material.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';

class UnderReview extends StatelessWidget {
  const UnderReview({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Logo
          ShaderMask(
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(blurRadius: 20, color: Colors.black12)
                  ]
              ),
              child: Image.asset('assets/icons/key_logo.png'),
            ),
          ),
          const SizedBox(
            height: 24,
          ),

          // news
          ShaderMask(
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
            child: Text(
              'Your account is requested successfully..',
              style: TextStyle(
                fontSize: 24,
                color: Colors.yellow,
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
            child: Text(
              'And your request is under review..',
              style: TextStyle(
                fontSize: 24,

              ),
            ),
          ),
          Text(
            'Please wait',
            style: TextStyle(
              fontSize: 24,

            ),
          ),
        ],
      ),
    );
  }
}
