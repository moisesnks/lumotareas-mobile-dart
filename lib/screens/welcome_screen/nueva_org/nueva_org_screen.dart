import 'package:flutter/material.dart';
import 'package:lumotareas/models/register_form.dart';
import 'package:lumotareas/widgets/org_formulario.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/login_screen.dart';
import 'package:lumotareas/extensions/text_styles.dart';

class NuevaOrgScreen extends StatefulWidget {
  final Logger _logger = Logger();
  final String orgName;

  NuevaOrgScreen({super.key, required this.orgName});

  @override
  NuevaOrgScreenState createState() => NuevaOrgScreenState();
}

class NuevaOrgScreenState extends State<NuevaOrgScreen> {
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

  final List<String> _errors = [];

  bool _validateBirthDate(String day, String month, String year) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      _errors.add('La fecha de nacimiento es requerida');
      return false;
    } else {
      return true;
    }
  }

  void validateForm() {
    _errors.clear();

    _validateBirthDate(
      _dayController.text.trim(),
      _monthController.text.trim(),
      _yearController.text.trim(),
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
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
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
    RegisterForm formData = RegisterForm(
      birthDate:
          '${_dayController.text.trim()}/${_monthController.text.trim()}/${_yearController.text.trim()}',
      orgName: widget.orgName,
    );

    widget._logger.d('Formulario enviado: $formData');

    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    await loginViewModel.signUpWithGoogle(context, formData);
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
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            elevation: WidgetStateProperty.all<double>(4.0),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.all(10.0),
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(
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
