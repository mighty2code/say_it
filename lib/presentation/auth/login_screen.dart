import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/data/models/firebase_auth_status.dart';
import 'package:chat_app/data/models/firebase_user.dart';
import 'package:chat_app/data/remote/firebase/firebase_client.dart';
import 'package:chat_app/presentation/auth/signup_screen.dart';
import 'package:chat_app/utils/info_utils.dart';
import 'package:chat_app/widgets/input_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppColors.appColor.shade200.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 300),
                const Text('Login Account',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 15),
                InputTextField(
                  controller: emailController,
                  color: AppColors.appColor.shade50,
                  borderRadius: 10,
                  borderColor: AppColors.appColor,
                  boldStyle: true,
                  style: const TextStyle(fontSize: 12),
                  hintText: 'Type Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  validator: (s) =>
                      s == null || s.isEmpty ? 'Please type email.' : null,
                ),
                const SizedBox(height: 10),
                InputTextField(
                  controller: passwordController,
                  color: AppColors.appColor.shade50,
                  borderRadius: 10,
                  borderColor: AppColors.appColor,
                  boldStyle: true,
                  style: const TextStyle(fontSize: 12),
                  hintText: 'Type Password',
                  isObscureText: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  validator: (s) =>
                      s == null || s.isEmpty ? 'Please type password.' : null,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    FirebaseAuthStatus status = await FirebaseClient.signIn(
                      user: FirebaseUser(email: emailController.text, password: passwordController.text)
                    );
                    if(status.isSuccess) {
                      InfoUtils.showSnackbar('Login', status.message);
                      Get.offAndToNamed(AppRoutes.homePage);
                    }
                  },
                  child: Card(
                    color: AppColors.appColor.shade700,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have account ? ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder:(context) => SignUpScreen()));
                      },
                      child: Text('SignUp',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.appColor.shade600,
                              color: AppColors.appColor.shade600)),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
