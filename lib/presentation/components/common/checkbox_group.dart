import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modelo para cada fragmento de texto dentro de un checkbox
class TextFragment {
  final String text;
  final String? url; // si tiene url es un link
  TextFragment({required this.text, this.url});
}

/// Modelo para cada checkbox
class CustomCheckbox {
  final List<TextFragment> fragments;
  bool value;

  CustomCheckbox({required this.fragments, this.value = false});
}

/// Widget reutilizable de grupo de checkboxes
class CheckboxGroup extends StatefulWidget {
  final List<CustomCheckbox> checkboxes;
  final Function(List<CustomCheckbox>)? onChanged;

  const CheckboxGroup({super.key, required this.checkboxes, this.onChanged});

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  late List<CustomCheckbox> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.checkboxes;
  }

  void _handleChange(int index, bool? value) {
    setState(() {
      _items[index].value = value ?? false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: _items.asMap().entries.map((entry) {
        int index = entry.key;
        CustomCheckbox item = entry.value;

        return CheckboxListTile(
          value: item.value,
          onChanged: (v) => _handleChange(index, v),
          title: RichText(
            text: TextSpan(
              children: item.fragments.map((fragment) {
                if (fragment.url != null) {
                  return TextSpan(
                    text: fragment.text,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse(fragment.url!));
                      },
                  );
                } else {
                  return TextSpan(
                    text: fragment.text,
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
