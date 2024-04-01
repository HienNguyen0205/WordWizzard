import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class AddTopicSecttion extends StatefulWidget {
  final int index;
  final void Function(int index, String? term, String? definition) handleChange;
  const AddTopicSecttion({super.key, required this.index, required this.handleChange});

  @override
  AddTopicSecttionState createState() => AddTopicSecttionState();
}

class AddTopicSecttionState extends State<AddTopicSecttion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                labelText: getTranslated(context, "term"),
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                errorBorder: const UnderlineInputBorder(),
              ),
              validator: (val) {
                if(val == null || val.isEmpty){
                  return getTranslated(context, "require_input");
                }else{
                  return null;
                }
              },
              onChanged: (val) {
                widget.handleChange(widget.index, val, null);
                _formKey.currentState?.validate();
              } ,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(),
                errorBorder: const UnderlineInputBorder(),
                labelText: getTranslated(context, "definition"),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return getTranslated(context, "require_input");
                } else {
                  return null;
                }
              },
              onChanged: (val) {
                widget.handleChange(widget.index, null, val);
                _formKey.currentState?.validate();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
