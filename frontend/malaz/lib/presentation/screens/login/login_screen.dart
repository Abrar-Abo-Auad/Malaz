// file: lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../../core/config/theme_config.dart';
import '../../global widgets/build_branding.dart';
import '../../global widgets/custom_button.dart';
import '../main wrapper/main_wrapper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(top: 0, left: 0,right: 0, child: _buildRibbon(AppColors.primaryLight)),
            Positioned(top: 350, left: 0,right: 0, child: _buildCard(AppColors.primaryLight)),
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
                    const SizedBox(height: 150),
        
                    // Inputs
                    _buildTextField('Mobile Number', Icons.phone),
                    const SizedBox(height: 16),
                    _buildTextField('Verification Code', Icons.lock_outline),
                    _buildVerficationCodeButton(),
                    const SizedBox(height: 70),
                    CustomButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildRegisterButton(),
                    SizedBox(height: 40,),
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
  Widget _buildCard(Color color) {
    return Container(
      height: 350,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icons/card_box.png'),fit: BoxFit.fill)),
    );
  }

  Widget _buildRibbon(Color color) {
    return Container(
      height: 200,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icons/ribbon.png'),fit: BoxFit.fill)),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(8),bottomLeft: Radius.circular(8),bottomRight: Radius.circular(30)), borderSide: BorderSide(color: AppColors.primary)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(8),bottomLeft: Radius.circular(8),bottomRight: Radius.circular(30)), borderSide: const BorderSide(color: AppColors.primary)),
      ),
    );
  }
}

Widget _buildRegisterButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Don\'t have an account ? ',style: TextStyle(color: AppColors.textSecondary),),
      GestureDetector(
        onTap: (){
          //Navigator.pushNamed(context, RegisterPage.id);
        },
        child: const Text('Register',style: TextStyle(color: AppColors.primary),),
      ),
    ],
  );
}

Widget _buildVerficationCodeButton() {
  return Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.send, color: AppColors.primary),
      label: const Text('Send verification code', style: TextStyle(color: AppColors.primary)),
    ),
  );
}