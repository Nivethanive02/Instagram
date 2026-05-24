import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/dashboard.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:provider/provider.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget buildTextFormField(TextEditingController controller, String name) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(name),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.brown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.green),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter valid $name";
        }
        if (name == "Email" &&
            (!value.contains("@") || !value.contains(".com"))) {
          return "Email is badly formatted";
        }
        if (name == "Password" && value.length < 8) {
          return "Password must be at least 8 characters";
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // email, password, name, dob, mobile, gender, city,profileImageUrl, id
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login Screen",
              style: TextStyle(
                fontSize: 30,
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            buildTextFormField(emailController, "Email"),
            SizedBox(height: 20),
            buildTextFormField(passwordController, "Password"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var uid =
                      await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).loginUserInBackend(
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                  if (uid.isNotEmpty) {
                    emailController.clear();
                    passwordController.clear();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>Dashboard()),
                    );
                  } else {
                    // ScaffoldMessenger.of(
                    //   context,
                    // ).showSnackBar(SnackBar(content: Text("Login Failed")));
                  }
                }
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) =>SingupScreen()));
              },
              child: Text("Don't have an account? SignUp"),
            ),
          ],
        ),
      ),
    );
  }
}