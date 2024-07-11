import 'package:flutter/material.dart';
import 'package:lumotareas/screens/welcome_screen/nueva_org/creando_org_screen.dart';
import 'package:lumotareas/widgets/org_formulario.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/login_screen.dart';
import 'package:lumotareas/extensions/text_styles.dart';
import 'package:lumotareas/screens/welcome_screen/nueva_org/loading_creando.dart';
import 'package:lumotareas/models/user.dart';

class NuevaOrgScreen extends StatefulWidget {
  final Logger _logger = Logger();
  final String orgName;

  NuevaOrgScreen({super.key, required this.orgName});

  @override
  NuevaOrgScreenState createState() => NuevaOrgScreenState();
}

class NuevaOrgScreenState extends State<NuevaOrgScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _canSubmit() {
    return _emailController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _dayController.text.isNotEmpty &&
        _monthController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isChecked;
  }

  bool _isChecked = false;

  final List<String> _errors = [];

  bool _validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      _errors.add('El email es requerido');
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      _errors.add('El formato del email es inválido');
      return false;
    } else {
      return true;
    }
  }

  bool _validateFullName(String fullName) {
    if (fullName.isEmpty) {
      _errors.add('El nombre completo es requerido');
      return false;
    } else if (fullName
        .contains(RegExp(r'[0-9!@#<>?":_`~;[\]\\|=+)(*&^%$£/{}-]'))) {
      _errors.add(
          'El nombre completo no puede contener caracteres especiales o números');
      return false;
    } else {
      return true;
    }
  }

  bool _validateBirthDate(String day, String month, String year) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      _errors.add('La fecha de nacimiento es requerida');
      return false;
    } else {
      return true;
    }
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      _errors.add('La contraseña es requerida');
      return false;
    } else if (password.length < 8) {
      _errors.add('La contraseña debe tener al menos 8 caracteres');
      return false;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      _errors.add('La contraseña debe contener al menos un número');
      return false;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      _errors.add('La contraseña debe contener al menos una letra mayúscula');
      return false;
    } else {
      return true;
    }
  }

  bool _validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      _errors.add('Las contraseñas no coinciden');
      return false;
    } else {
      return true;
    }
  }

  void validateForm() {
    _errors.clear();

    _validateEmail(_emailController.text.trim());
    _validateFullName(_fullNameController.text.trim());
    _validateBirthDate(
      _dayController.text.trim(),
      _monthController.text.trim(),
      _yearController.text.trim(),
    );
    _validatePassword(_passwordController.text.trim());
    _validateConfirmPassword(
      _passwordController.text.trim(),
      _confirmPasswordController.text.trim(),
    );

    if (_errors.isNotEmpty) {
      widget._logger.d('Errores en el formulario: $_errors');
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Corrige los siguientes errores:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _errors.map((error) {
                    return Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      );
    } else {
      widget._logger.d('Formulario validado correctamente');
      submitForm(context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget renderTitle() {
    return Text(
      '${widget.orgName}, qué buen nombre',
      style: const TextStyle(
        fontFamily: 'Lexend',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  Widget renderSubtitle() {
    return const Text(
      'Es primera vez que inicias sesión? Únete',
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
      ),
    );
  }

  void submitForm(BuildContext context) async {
    Map<String, dynamic> formData = {
      'email': _emailController.text.trim(),
      'fullName': _fullNameController.text.trim(),
      'birthDate':
          '${_dayController.text.trim()}/${_monthController.text.trim()}/${_yearController.text.trim()}',
      'password': _passwordController.text.trim(),
      'orgName': widget.orgName,
      'isOwner': true,
    };

    widget._logger.d('Formulario enviado: $formData');

    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    // Mostrar pantalla de carga
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(),
      ),
    );

// Registrar usuario y organización
    Usuario? newUser = await loginViewModel.registerUserWithEmailAndPassword(
        context, formData);

    if (newUser != null) {
      widget._logger.d('Usuario registrado correctamente: ${newUser.uid}');
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return CreandoOrgScreen(
                orgName: widget.orgName, ownerUID: newUser.uid);
          },
        ));
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }
      widget._logger.e('Error al registrar usuario');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Hubo un error al registrar tu cuenta. Por favor, intenta de nuevo.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/new_org.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    onTap: () {
                      widget._logger.d('Logo de Lumotareas clickeado');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        renderTitle(),
                        renderSubtitle(),
                        OrgFormulario(
                          emailController: _emailController,
                          fullNameController: _fullNameController,
                          dayController: _dayController,
                          monthController: _monthController,
                          yearController: _yearController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                        CheckboxWidget(
                          onChanged: (isChecked) {
                            setState(() {
                              _isChecked = isChecked;
                            });
                            widget._logger
                                .d('Checkbox seleccionado: $isChecked');
                          },
                        ),
                        ElevatedButton(
                          onPressed: _canSubmit()
                              ? () {
                                  widget._logger.d(
                                      'Registrar organización y cuenta presionado');
                                  validateForm(); // Llama al método para validar y mostrar el modal si hay errores
                                }
                              : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            elevation: MaterialStateProperty.all<double>(4.0),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.all(10.0),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 0),
                            ),
                          ),
                          child: const Text(
                              'Registrar mi organización y mi cuenta'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        widget._logger
                            .d('Botón "Ya tengo cuenta..." presionado');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Ya tengo cuenta en Lumotareas pero quiero crear una nueva organización',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ).underlined(
                          distance:
                              2, // Distancia entre el texto y el subrayado
                          thickness: 1, // Grosor del subrayado
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
