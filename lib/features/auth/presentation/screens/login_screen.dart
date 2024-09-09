import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/datasource/auth_datasource.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_servive.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _useremailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  late AuhtDataSource _loginLogic;

  @override
  void initState() {
    super.initState();
    _loginLogic = AuhtDataSource(
      formKey: _formKey,
      usernameController: _useremailController,
      passwordController: _passwordController,
      authService: _authService,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorApp = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ingresar credenciales',
          style: TextStyle(color: Colors.teal, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.home, color: colorApp.primary),
          onPressed: () {
            routerApp.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10), // Add some space at the top
                TextFormField(
                  controller: _useremailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'campo requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'campo requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FilledButton(
                    onPressed: () => _loginLogic.login(context),
                    child: const Icon(Icons.login_sharp))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginLogic.dispose();
    super.dispose();
  }
}
