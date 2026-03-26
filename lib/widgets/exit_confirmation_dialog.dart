import 'package:flutter/material.dart';

/// ExitConfirmationDialog is a widget that shows a confirmation dialog before exiting the app.
/// It displays a primary message, secondary message and two buttons to accept or decline.

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
