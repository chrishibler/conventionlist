import 'package:convention_list/theme/mocha.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// PayPal donate button
class PayPalButton extends StatelessWidget {
  final String donateUrl = "https://www.paypal.com/donate?hosted_button_id=66WBP4C255GL8";

  const PayPalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text('Donate'),
      icon: const Icon(Icons.paypal),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: CatppuccinMocha.sapphire, width: 1),
        maximumSize: const Size(200, 200),
      ),
      onPressed: () async {
        try {
          await launchUrlString(donateUrl);
        } catch (e) {
          debugPrint("Error: $e");
        }
      },
    );
  }
}
