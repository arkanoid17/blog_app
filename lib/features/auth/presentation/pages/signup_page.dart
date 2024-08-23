import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => LoginPage());

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state is AuthFailure){
      showSnackBar(context, state.message);
    }
  },
  builder: (context, state) {

    if(state is AuthLoading){
      return const Loader();
    }

    return Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign Up.",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold)),
              SizedBox(height: 30,),
              AuthField( hintText: 'Name',controller: nameController,obscureText: false,),
              SizedBox(height: 15,),
              AuthField( hintText: 'Email',controller: emailController,obscureText: false,),
              SizedBox(height: 15,),
              AuthField( hintText: 'Password',controller: passwordController,obscureText: true,),
              SizedBox(height: 20,),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onPressed: (){
                  if(formKey.currentState!.validate()){
                    context.read<AuthBloc>().add(
                        AuthSignup(name: nameController.text.trim(), email: emailController.text.trim().toLowerCase(), password: passwordController.text.trim())
                    );
                  }
                }),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, SignupPage.route());
                },
                child: RichText(
                    text:  TextSpan(
                        text: "Already have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: ' Sign In',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppPalette.gradient2,fontWeight: FontWeight.bold),
                        )
                      ]
                    )
                ),
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
