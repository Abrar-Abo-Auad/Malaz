import 'package:flutter/material.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen1.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen2.dart';
import 'package:malaz/presentation/screens/auth/register/register_screen3.dart';
import 'package:malaz/presentation/screens/auth/register/welcome_and_add_profilephoto.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';

class HomeRegisterScreen extends StatelessWidget {
  final _controller = PageController();
  HomeRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ListView(
        children: [
          SizedBox(
            height: 800,
            width: 450,
            child: PageView(
              controller: _controller,
              children: const [
                RegisterScreen1(),
                RegisterScreen2(),
                RegisterScreen3(),
                WelcomeAndAddProfilephoto(),
              ],
            ),
          ),
          const SizedBox(height: 8,),
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.yellow,
                    dotHeight: 25,
                    dotWidth: 25,
                    spacing: 15
                ),
              ),
            ),
          ),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }
}
