import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/dependencies.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final controller = AppDependencies.authController;

    final success = await controller.login(
      email: _emailController.text,
      password: _passwordController.text
    );

    if (!mounted) return;

    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( controller.errorMessage ?? 'Login Failed.')));
      return;
    }

    context.go('/home');
  }

  @override
  Widget build(BuildContext context){
    final controller = AppDependencies.authController;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints( minHeight: constraints.maxHeight ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      const Icon(
                        Icons.fitness_center,
                        color: Colors.blue,
                        size: 100,
                      ),
                      const Text(
                        'Fitess Pulse',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Login to continue',
                        textAlign: TextAlign.center
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon( _obscurePassword ? Icons.visibility : Icons.visibility_off ),
                            onPressed: (){
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          )
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading ? null : _login,
                          child: controller.isLoading ? const CircularProgressIndicator() : const Text ( 'Login', style: TextStyle(fontSize: 16))),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },
                        child: const Text("Don't have an account? Sign up")
                      )
                    ]
                  )
                )
              )
            );
          }
        )
      )
    );
  }
}

