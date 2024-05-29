import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const PaymentMethodCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Image.asset(imagePath, width: 35.0),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

final paymentMethods = [
  {
    'imagePath': 'assets/gopay.png',
    'title': 'Gopay',
    'value': 'gopay',
  },
  {
    'imagePath': 'assets/ovo.png',
    'title': 'OVO',
    'value': 'ovo',
  },
  {
    'imagePath': 'assets/dana.png',
    'title': 'Dana',
    'value': 'dana',
  },
  {
    'imagePath': 'assets/sopay.png',
    'title': 'Shopeepay',
    'value': 'shopeepay',
  },
];
