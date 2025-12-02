// file: lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/config/theme_config.dart';
import '../../../global widgets/build_branding.dart';
import '../../../global widgets/custom_button.dart';
import '../../main wrapper/main_wrapper.dart';
import '../shared widgets/shared_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(top: 0, left: 0,right: 0, child: BuildRibbon()),
            Positioned(top: 350, left: 0,right: 0, child: BuildCard()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 95),
                    // Logo Area
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black12)]),
                      child: Image.asset('assets/icons/key_logo.png'),
                    ),
                    const SizedBox(height: 24),
                    const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    const Text('Login to continue your search', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 135),
        
                    // Inputs & verificationCodeButton
                    BuildTextfield(label: 'Mobile Number', icon: Icons.phone),
                    BuildVerficationCodeButton(),
                    const SizedBox(height: 8),
                    BuildPincodeTextfield(),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
                      },
                    ),
                    const SizedBox(height: 12),
                    // To swap => Register page
                    BuildRegisterRow(),
                    SizedBox(height: 40,),
                    // Branding FROM MALAZ
                    BuildBranding()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}