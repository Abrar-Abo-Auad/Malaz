import 'package:flutter/material.dart';
import 'package:malaz/core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../global_widgets/build_branding.dart';
import '../shared_widgets/shared_widgets.dart';

class RegisterScreen1 extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<BuildPincodeTextfieldState> pinKey; // إضافة المفتاح
  const RegisterScreen1({super.key, required this.formKey, required this.pinKey});

  @override
  State<RegisterScreen1> createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Form(
              key: widget.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(blurRadius: 20, color: Colors.black12)
                        ]),
                    child: Image.asset('assets/icons/key_logo.png'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Create Account - Header Text 1
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.realGoldGradient.createShader(bounds),
                    child: Text(tr.create_account, // Using getter
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // Join To Find - Header Text 2
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.realGoldGradient.createShader(bounds),
                    child: Text(
                      tr.join_to_find, // Using getter
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),

                  // Mobile Field
                  BuildTextfield(
                    label: tr.mobile_number,
                    icon: Icons.phone,
                    obscure: false,
                    haveSuffixEyeIcon: false,
                    formKey: widget.formKey,
                  ),
                  const SizedBox(
                      height: 16
                  ),

                  // Send Verification Code Button
                  const BuildVerficationCodeButton(),
                  const SizedBox(
                    height: 4,
                  ),

                  // Pin Code TextField
                  BuildPincodeTextfield(key: widget.pinKey),
                  const SizedBox(
                    height: 100,
                  ),

                  // Navigator.push to Login Page
                  const BuildLoginRow(),
                  const SizedBox(
                    height: 80,
                  ),

                  // Branding
                  BuildBranding()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
