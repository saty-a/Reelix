import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  final String primaryMessage, secondaryMessage, declineMessage, acceptMessage;
  final VoidCallback accept, decline;

  const ExitConfirmationDialog(
      {super.key,
        required this.primaryMessage,
        required this.secondaryMessage,
        required this.accept,
        required this.decline,
        required this.declineMessage,
        required this.acceptMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(primaryMessage),
      content: Text(secondaryMessage),
      actions: <Widget>[
        TextButton(
          onPressed: decline,
          child: Text(declineMessage),
        ),
        TextButton(
          onPressed: accept,
          child: Text(acceptMessage),
        ),
      ],
    );
  }
}
