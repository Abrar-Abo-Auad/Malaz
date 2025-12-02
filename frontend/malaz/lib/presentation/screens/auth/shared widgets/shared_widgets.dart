import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/config/theme_config.dart';

class BuildCard extends StatelessWidget {
  const BuildCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/icons/card_box.png'),fit: BoxFit.fill)),
    );
  }
}

class BuildPincodeTextfield extends StatelessWidget {
  const BuildPincodeTextfield({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.center,
      appContext: context,
      textStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      length: 5,
      onChanged: (value) {},
      onCompleted: (value) {},
      pinTheme: PinTheme(
        selectedBorderWidth: 2,
        inactiveBorderWidth: 2,
        activeBorderWidth: 2,
        borderWidth: 2,
        shape: PinCodeFieldShape.box,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.circular(16),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: AppColors.primary,
        inactiveColor: AppColors.primary,
        selectedColor: AppColors.secondary,
        selectedFillColor: AppColors.primary,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class BuildRegisterRow extends StatelessWidget {
  const BuildRegisterRow({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class BuildRibbon extends StatelessWidget {
  const BuildRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            'assets/icons/ribbon.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class BuildTextfield extends StatelessWidget {
  final String label;
  IconData icon;
  BuildTextfield({super.key,required this.label ,required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(30),
          ),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(30),
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class BuildVerficationCodeButton extends StatelessWidget {
  const BuildVerficationCodeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.send, color: AppColors.primary),
        label: const Text('Send verification code', style: TextStyle(color: AppColors.primary)),
      ),
    );
  }
}