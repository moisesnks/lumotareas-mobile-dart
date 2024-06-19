import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final Function(List<String>) setList;
  final String hint;
  final List<String> parentEmails;

  const EmailInput({
    super.key,
    required this.setList,
    required this.hint,
    required this.parentEmails,
  });

  @override
  EmailInputState createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  late TextEditingController _emailController;
  String lastValue = '';
  List<String> emails = [];
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();

    focus.addListener(() {
      if (!focus.hasFocus) {
        updateEmails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minWidth: 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: emails.map((email) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text(
                        email.substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    labelPadding: const EdgeInsets.all(4),
                    backgroundColor: const Color.fromARGB(255, 39, 182, 192),
                    label: Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onDeleted: () {
                      setState(() {
                        emails.remove(email);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration.collapsed(hintText: widget.hint),
            controller: _emailController,
            focusNode: focus,
            onChanged: (String val) {
              setState(() {
                if (val != lastValue) {
                  lastValue = val;
                  if (val.endsWith(' ') && validateEmail(val.trim())) {
                    if (!emails.contains(val.trim())) {
                      emails.add(val.trim());
                      widget.setList(emails);
                    }
                    _emailController.clear();
                  } else if (val.endsWith(' ') && !validateEmail(val.trim())) {
                    _emailController.clear();
                  }
                }
              });
            },
            onEditingComplete: updateEmails,
          ),
        ],
      ),
    );
  }

  void updateEmails() {
    setState(() {
      if (validateEmail(_emailController.text)) {
        if (!emails.contains(_emailController.text.trim())) {
          emails.add(_emailController.text.trim());
          widget.setList(emails);
        }
        _emailController.clear();
      } else {
        _emailController.clear();
      }
    });
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  return regex.hasMatch(value);
}
