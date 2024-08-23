import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/show_snack_bar.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignupPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }else if(state is AuthSuccess){
               Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route)=> false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign In.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AuthGradientButton(
                    buttonText: 'Sign In',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSignIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                          TextSpan(
                            text: ' Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: AppPalette.gradient2,
                                    fontWeight: FontWeight.bold),
                          )
                        ])),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
