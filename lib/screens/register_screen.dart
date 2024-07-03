import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/org_formulario.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:logger/logger.dart';

class RegisterScreen extends StatefulWidget {
  final Logger _logger = Logger();

  RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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
        _isChecked;
  }

  bool _isChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Widget renderTitle() {
    return const Text(
      'Registro de Usuario',
      style: TextStyle(
        fontFamily: 'Lexend',
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color(0xFFFFFFFF),
      ),
    );
  }

  Widget renderSubtitle() {
    return const Text(
      'Por favor, complete el formulario',
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
      ),
    );
  }

  void _submitForm() {
    if (_canSubmit()) {
      String email = _emailController.text.trim();
      String fullName = _fullNameController.text.trim();
      String day = _dayController.text.trim();
      String month = _monthController.text.trim();
      String year = _yearController.text.trim();
      String birthDate = '$day/$month/$year';

      // Aquí puedes realizar la lógica para enviar el formulario
      widget._logger.d(
          'Formulario de registro enviado: { email: $email, fullName: $fullName, birthDate: $birthDate }');

      // Por ejemplo, llamar al servicio para enviar los datos
      // apiService.sendRegistrationForm({
      //   'email': email,
      //   'fullName': fullName,
      //   'birthDate': birthDate,
      // });

      // Puedes realizar otras acciones necesarias después de enviar el formulario
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
                        const SizedBox(height: 20),
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
                            // Aquí puedes manejar el estado del checkbox
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _canSubmit()
                              ? () {
                                  widget._logger
                                      .d('Registrar cuenta presionado');
                                  _submitForm(); // Llama al método para enviar el formulario
                                }
                              : null, // Deshabilita el botón si no se pueden enviar los datos
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
                          child: const Text('Registrar mi cuenta'),
                        ),
                      ],
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
