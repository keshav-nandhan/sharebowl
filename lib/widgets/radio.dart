import 'package:flutter/material.dart';

class VegNonVegToggle extends StatefulWidget {
  const VegNonVegToggle({super.key});

  @override
  _VegNonVegToggleState createState() => _VegNonVegToggleState();
}

class _VegNonVegToggleState extends State<VegNonVegToggle> {
  int _selection = 1; // 1: Veg, 2: Non-Veg (default)

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RadioListTile<int>(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Veg'),
              value: 1,
              groupValue: _selection,
              onChanged: (value) => setState(() => _selection = value!),
              activeColor: Colors.green,
            ),
          ),
          Expanded(
            child: RadioListTile<int>(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Non-Veg'),
              value: 2,
              groupValue: _selection,
              onChanged: (value) => setState(() => _selection = value!),
              activeColor: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
