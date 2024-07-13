import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/formulario_widget.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/models/register_form.dart';
import 'package:lumotareas/services/preferences_service.dart';

class RegisterFormWidget extends StatefulWidget {
  final Logger _logger = Logger();
  final Map<String, dynamic>? respuestas;
  final String orgName;

  RegisterFormWidget({super.key, this.respuestas, this.orgName = ''});

  @override
  RegisterFormWidgetState createState() => RegisterFormWidgetState();
}

class RegisterFormWidgetState extends State<RegisterFormWidget> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  bool _canSubmit() {
    return _dayController.text.isNotEmpty &&
        _monthController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _isChecked;
  }

  bool _isChecked = false;

  @override
  void dispose() {
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
      String day = _dayController.text.trim();
      String month = _monthController.text.trim();
      String year = _yearController.text.trim();
      String birthDate = '$day/$month/$year';

      RegisterForm formData = RegisterForm(
        birthDate: birthDate,
        orgName: widget.orgName,
        respuestas: widget.respuestas,
      );

      widget._logger.d('Datos del formulario: $formData');
      final loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);
      await loginViewModel.signUpWithGoogle(context, formData);
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
              child: Contenedor(
                height: MediaQuery.of(context).size.height * 0.85,
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    onTap: () {
                      widget._logger.d('Logo de Lumotareas clickeado');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        renderTitle(),
                        renderSubtitle(),
                        const SizedBox(height: 20),
                        Formulario(
                          dayController: _dayController,
                          monthController: _monthController,
                          yearController: _yearController,
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
                        ElevatedButton.icon(
                          onPressed: _canSubmit()
                              ? () {
                                  widget._logger
                                      .d('Registrar cuenta presionado');
                                  _submitForm(
                                      context); // Llama al método para enviar el formulario
                                }
                              : null, // Deshabilita el botón si no se pueden enviar los datos
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 207, 207, 207),
                          ),
                          icon: SvgPicture.asset(
                            'assets/images/google-svgrepo.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text('Continuar con Google',
                              style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Usar el servicio de preferencias para setear
                      // el redirectToLogin en false
                      // y navegar a '/'
                      PreferenceService.setRedirectToLogin(false);
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      'Haz clic aquí para buscar tu organización',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        color: Colors.white,
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
