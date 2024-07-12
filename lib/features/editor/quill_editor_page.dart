import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillEditorPage extends StatefulWidget {
  const QuillEditorPage({super.key});

  @override
  QuillEditorPageState createState() => QuillEditorPageState();
}

class QuillEditorPageState extends State<QuillEditorPage> {
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quill Editor'),
      ),
      body: Column(
        children: [
          quill.QuillToolbar.simple(
            configurations: quill.QuillSimpleToolbarConfigurations(
              controller: _controller,
              sharedConfigurations: const quill.QuillSharedConfigurations(
                locale: Locale('de'),
              ),
            ),
          ),
          Expanded(
            child: quill.QuillEditor.basic(
              configurations: quill.QuillEditorConfigurations(
                controller: _controller,
                //readOnly: true,
                sharedConfigurations: const quill.QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
