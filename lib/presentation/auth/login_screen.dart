import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:say_it/app_router.dart';
import 'package:say_it/bussiness_logic/auth/bloc/login_bloc.dart';
import 'package:say_it/constants/app_colors.dart';
import 'package:say_it/constants/app_routes.dart';
import 'package:say_it/data/models/firebase_status.dart';
import 'package:say_it/data/models/firebase_user.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:say_it/presentation/auth/signup_screen.dart';
import 'package:say_it/utils/info_utils.dart';
import 'package:say_it/widgets/input_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:say_it/widgets/text_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..init(),
      child: Scaffold(
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
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return AppTextButton(
                        title: 'Login',
                        onTap: () async {
                          bloc.add(FirebaseLoginEvent(email: emailController.text, password: passwordController.text));
                          context.read<LoginBloc>().stream.listen((state) {
                            if (state is LoginSuccess) {
                              InfoUtils.showSnackbar(title: 'Login', message: state.message);
                              AppRouter.pushReplacementNamed(AppRoutes.homePage);
                            } else if (state is LoginFailure) {
                              InfoUtils.showSnackbar(title: 'Login', message: state.error);
                            }
                          });
                        },
                        textColor: AppColors.white,
                        loading: state is LoginLoading,
                        fontWeight: FontWeight.bold
                      );
                    },
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
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
          )
        ),
      ),
    );
  }
}
