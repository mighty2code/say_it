import 'package:say_it/constants/app_colors.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/data/models/firebase_status.dart';
import 'package:say_it/data/models/firebase_user.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:say_it/utils/info_utils.dart';
import 'package:say_it/widgets/input_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
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
                const Text('Register Account',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 15),
                InputTextField(
                  controller: nameController,
                  color: AppColors.appColor.shade50,
                  borderRadius: 10,
                  borderColor: AppColors.appColor,
                  boldStyle: true,
                  style: const TextStyle(fontSize: 12),
                  hintText: 'Type Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  validator: (s) =>
                      s == null || s.isEmpty ? 'Please type name.' : null,
                ),
                const SizedBox(height: 15),
                InputTextField(
                  controller: usernameController,
                  color: AppColors.appColor.shade50,
                  borderRadius: 10,
                  borderColor: AppColors.appColor,
                  boldStyle: true,
                  style: const TextStyle(fontSize: 12),
                  hintText: 'Type Username',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  validator: (s) =>
                      s == null || s.isEmpty ? 'Please type username.' : null,
                ),
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
                    FirebaseAuthStatus status = await FirebaseClient.signUp(
                      user: FirebaseUser(
                        name: nameController.text,
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text
                      )
                    );
                      
                    if(status.isSuccess) {
                      InfoUtils.showSnackbar('SignUp', status.message);
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
                        'SignUp',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
