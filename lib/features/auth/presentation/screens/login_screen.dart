import 'package:cdattg_sena_mobile/config/routes/router_app.dart';
import 'package:flutter/material.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/services/auth_service.dart';
import 'package:cdattg_sena_mobile/features/auth/domain/datasource/auth_datasource.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AuhtDataSource _loginLogic;

  @override
  void initState() {
    super.initState();
    _loginLogic = AuhtDataSource(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      authService: AuthService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Iniciar Sesión',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              routerApp.go('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                        50), // 50% width and height of 50
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Add horizontal padding
                  ),
                  onPressed: () => _loginLogic.login(context),
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
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
