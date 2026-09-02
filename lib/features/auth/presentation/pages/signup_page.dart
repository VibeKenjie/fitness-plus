import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/dependencies.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _birthdate;

  bool _obscurePassword = true;

  @override
  void dispose(){
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final controller = AppDependencies.authController;

    final success = await controller.signup(
      firstName: _firstNameController.text, 
      lastName: _lastNameController.text, 
      birthdate: _birthdate, 
      email: _emailController.text, 
      password: _passwordController.text, 
      confirmPassword: _confirmPasswordController.text
    );

    if(!mounted) return;

    if(!success){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text (controller.errorMessage ?? 'Sign up failed.')));
      return;
    }

    context.go('/home');
  }

  @override
  Widget build(BuildContext context){
    final controller = AppDependencies.authController;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text (
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 8),
              const Text (
                'Sign up to get started',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()
                )
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()
                )
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(color: Colors.grey)
                ),
                leading: const Icon(Icons.calendar_today),
                title: Text ( _birthdate == null ? 'Select Birthdate' : '${_birthdate!.month}/${_birthdate!.day}/${_birthdate!.year}' ),
                onTap: () async {
                  final pickedDate = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (pickedDate != null) {
                    setState(() {
                      _birthdate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
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
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }
                  )
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : _signup,
                  child: controller.isLoading ? const CircularProgressIndicator() : const Text('Create Accout', style: TextStyle(fontSize: 16))
                )
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () { 
                  context.go('/login');
                },
                child: const Text(
                  'Already have an account? Login'
                )
              )
            ]
          )
        )
      )
    );
  }
}

