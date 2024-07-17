import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/descubrir_data_provider.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class LikeButton extends StatefulWidget {
  final Organizacion? organization;
  final void Function(bool isLiked) onCallback;

  const LikeButton({
    super.key,
    required this.organization,
    required this.onCallback,
  });

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final Usuario? currentUser = userDataProvider.currentUser;
    if (currentUser == null) {
      isLiked = false;
    } else {
      isLiked = widget.organization!.likes.contains(currentUser.uid);
    }
  }

  void _onLikedPressed(bool isLiked) async {
    final DescubrirDataProvider descubrirDataProvider =
        Provider.of<DescubrirDataProvider>(context, listen: false);
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final Usuario? currentUser = userDataProvider.currentUser;
    if (currentUser == null) {
      return;
    }

    setState(() {
      this.isLiked = isLiked;
    });

    bool response = await descubrirDataProvider.likeOrganizacion(
      widget.organization!,
      currentUser,
      isLiked,
    );

    if (response) {
      setState(() {
        this.isLiked = isLiked;
      });

      widget.onCallback(isLiked);
    } else {
      // Mostrar mensaje de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: () {
        _onLikedPressed(!isLiked);
      },
    );
  }
}
