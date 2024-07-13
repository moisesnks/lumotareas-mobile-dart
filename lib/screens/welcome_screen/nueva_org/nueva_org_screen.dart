import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumotareas/models/register_form.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/formulario_widget.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/widgets/checkbox_widget.dart';
import 'package:lumotareas/widgets/header_widget.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/screens/login_screen/login_screen.dart';
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
                  Contenedor(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    height: MediaQuery.of(context).size.height * 0.85,
                    children: [
                      Contenedor(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Contenedor(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              renderTitle(),
                              renderSubtitle(),
                            ],
                          ),
                          Contenedor(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            direction: Axis.vertical,
                            children: [
                              Formulario(
                                dayController: _dayController,
                                monthController: _monthController,
                                yearController: _yearController,
                              ),
                              Contenedor(
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CheckboxWidget(
                                    onChanged: (isChecked) {
                                      setState(() {
                                        _isChecked = isChecked;
                                      });
                                      widget._logger.d(
                                          'Checkbox seleccionado: $isChecked');
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton.icon(
                                onPressed: _canSubmit()
                                    ? () {
                                        widget._logger.d(
                                            'Registrar organización y cuenta presionado');
                                        validateForm(); // Llama al método para validar y mostrar el modal si hay errores
                                      }
                                    : null,
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
                        ],
                      ),
                      TextButton(
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
                    ],
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
