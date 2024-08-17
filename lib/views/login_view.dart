import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'home_view.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            //return login_view 
            if (state is HomeState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } 
              //show message error
              else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Container(
              color: const Color.fromARGB(255, 22, 23, 43),
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hello!', 
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white
                      ),),
                    const Text('Wellcome back', 
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white
                      ),),
                    const SizedBox(height: 40),

                    //Field email
                    TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration( 
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          hintText: 'Example@gmail.com',
                          hintStyle: TextStyle(color: Color.fromARGB(120, 158, 158, 158), fontWeight: FontWeight.w100),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Check if email is valid and ends with @gmail.com
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                            return 'Please enter a valid Gmail address';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 20),

                    //field password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration( 
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Color.fromARGB(120, 158, 158, 158), fontWeight: FontWeight.w100),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    const Center(
                      child: Text('Forgot your Password ?'),
                    ),
                    const SizedBox(height: 50),

                    //button login
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                LoggedIn(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(149, 61, 0, 67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16) 
                            )
                          ),
                          child: const Text('Sign in',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
