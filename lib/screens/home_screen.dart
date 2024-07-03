import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/widgets/arrow_circle.dart';
import 'package:lumotareas/widgets/welcome_title.dart';
import 'package:lumotareas/widgets/input_field.dart';
import 'package:lumotareas/viewmodels/home_viewmodel.dart';
import 'package:lumotareas/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ImageProvider _welcomeImage =
      const AssetImage('assets/images/welcome.png');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_welcomeImage, context);
  }

  Widget renderBody(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return GestureDetector(
      onTap: () {
        // Handle tap anywhere on the screen
        FocusScope.of(context).unfocus(); // Close keyboard if open
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Para comenzar,',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                height: .5,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              key: const Key('orgField'),
              controller: viewModel.orgController,
              labelText: 'Ingresa el nombre de tu organización',
              hintText: 'Escribe el nombre aquí',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                child: const Text(
                  'Ya tengo cuenta en Lumotareas',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo de bienvenida estático
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _welcomeImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido principal
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
                child: renderTitle(),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 200),
                  child: SafeArea(
                    child: renderBody(context),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                return ArrowCircleWidget(
                  onTap: () => viewModel.handleArrowTap(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
