import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/org_formulario.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/services/user_service.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Logger _logger = Logger();
  final Map<String, String> respuestas;
  final String orgName;

  final UserService _userService = UserService();
  final OrganizationService _organizationService = OrganizationService();

  RegisterScreen({super.key, required this.respuestas, required this.orgName});

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

  void _submitForm(BuildContext context) async {
    if (_canSubmit()) {
      String email = _emailController.text.trim();
      String fullName = _fullNameController.text.trim();
      String day = _dayController.text.trim();
      String month = _monthController.text.trim();
      String year = _yearController.text.trim();
      String birthDate = '$day/$month/$year';

      Map<String, dynamic> formData = {
        'email': email,
        'fullName': fullName,
        'birthDate': birthDate,
        'password': _passwordController.text.trim(),
        'formulario': widget.respuestas,
        'orgName': widget.orgName,
      };

      widget._logger.d('Datos del formulario: $formData');
      final loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);

      // Intenta  registrar al usuario
      var newUser =
          await loginViewModel.registerUserWithEmailAndPassword(formData);
      if (newUser != null) {
        widget._logger.d('Usuario registrado correctamente: ${newUser.email}');
        // Mostrar un mensaje de éxito
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario registrado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Enviar la solicitud de registro a la organización
        var result = await widget._organizationService
            .registerSolicitud(widget.orgName, widget.respuestas, newUser.uid);
        if (result['success']) {
          widget._logger.d('Solicitud registrada correctamente');
          // Mostrar un mensaje de éxito
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Solicitud registrada correctamente en la organización'),
                backgroundColor: Colors.green,
              ),
            );
          }
          // Registrar la referencia de la solicitud en el usuario, para eso
          // el usuario tiene un campo (array) que se llama solicitudes el cual con el servicio
          // de firestore se usará el método addToArray para agregar la referencia de la solicitud
          // a ese array
          var ref = result['ref'];
          bool userUpdate =
              await widget._userService.addSolicitudToUser(newUser.uid, ref);

          if (userUpdate) {
            widget._logger.d('Referencia de solicitud agregada al usuario');
            if (context.mounted) {
              // Redirigir al usuario a la pantalla de inicio
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/main',
                (route) => false,
              );
            }
          } else {
            widget._logger
                .e('Error al agregar referencia de solicitud al usuario');
          }
        } else {
          widget._logger.e('Error al registrar solicitud');
          // Mostrar un mensaje de error
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al registrar solicitud'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        widget._logger.e('Error al registrar usuario');
        // Mostrar un mensaje de error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al registrar usuario'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                                  _submitForm(
                                      context); // Llama al método para enviar el formulario
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
