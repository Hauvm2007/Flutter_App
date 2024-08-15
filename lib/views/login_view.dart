import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'home_view.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black12,
      //   // title: const Text('Login Page'),
      // ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is HomeState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            color: const Color.fromARGB(255, 22, 23, 43),
            padding: const EdgeInsets.all(50.0),
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
                SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
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
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),
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
                ),
                SizedBox(height: 25),
                Center(
                  child: const Text('Forgot your Password ?'),
                ),
                SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          LoggedIn(
                            _emailController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(149, 61, 0, 67),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16) 
                        )
                      ),
                      child: Text('Sign in',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w100),),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
