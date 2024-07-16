import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';

class CommentInputWidget extends StatefulWidget {
  final TextEditingController commentController;
  final Function(String) onSendComment;
  final Usuario currentUser;

  const CommentInputWidget({
    super.key,
    required this.commentController,
    required this.onSendComment,
    required this.currentUser,
  });

  @override
  CommentInputWidgetState createState() => CommentInputWidgetState();
}

class CommentInputWidgetState extends State<CommentInputWidget> {
  bool isEmojiVisible = false;
  final FocusNode focusNode = FocusNode();

  void toggleEmojiKeyboard() {
    setState(() {
      isEmojiVisible = !isEmojiVisible;
      if (isEmojiVisible) {
        focusNode.unfocus();
      } else {
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon:
                  Icon(isEmojiVisible ? Icons.keyboard : Icons.emoji_emotions),
              onPressed: toggleEmojiKeyboard,
            ),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: widget.commentController,
                decoration: InputDecoration(
                  hintText: "Escribe un comentario...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF07081D),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (widget.commentController.text.isNotEmpty) {
                  widget.onSendComment(widget.commentController.text.trim());
                  widget.commentController.clear();
                }
              },
            ),
          ],
        ),
        Offstage(
          offstage: !isEmojiVisible,
          child: SizedBox(
            height: 250,
            child: EmojiPicker(
              textEditingController: widget.commentController,
              config: const Config(
                height: 250,
                emojiViewConfig: EmojiViewConfig(
                  columns: 7,
                  emojiSizeMax: 24.0,
                ),
                skinToneConfig: SkinToneConfig(
                  enabled: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
