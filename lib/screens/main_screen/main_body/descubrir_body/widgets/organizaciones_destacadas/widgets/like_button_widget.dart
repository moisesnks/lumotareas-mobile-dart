import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/logic/descubrir_logic.dart';

class LikeButton extends StatefulWidget {
  final Organization? organization;
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
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    // Initialize isLiked based on whether the current user has already liked this organization
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    isLiked =
        widget.organization?.likes.contains(loginViewModel.currentUser?.uid) ??
            false;
  }

  void _onLikePressed(bool isLiked) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final currentUserUid = loginViewModel.currentUser?.uid ?? '';

    setState(() {
      this.isLiked = isLiked;
    });

    final result = await DescubrirLogic.likeOrganization(
      widget.organization?.nombre ?? '',
      currentUserUid,
      isLiked,
    );

    if (result['success']) {
      setState(() {
        this.isLiked = isLiked;
      });

      widget
          .onCallback(isLiked); // Llamar al callback con el estado actualizado

      _logger.i(
        '$currentUserUid ${isLiked ? "ha dado like a" : "ha quitado el like de"} la organización ${widget.organization?.nombre}',
      );
    } else {
      _logger.e('Error: ${result['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.thumb_up),
      onPressed: () {
        _onLikePressed(!isLiked);
      },
      color: isLiked ? Colors.blue : Colors.grey,
    );
  }
}
