import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class AddTopicSecttion extends StatefulWidget {
  final int index;
  final int focusIndex;
  final void Function(int index) handleFocusChange;
  final dynamic termVal;
  final void Function(int index, String? term, String? definition) handleChange;
  const AddTopicSecttion({super.key, required this.index, required this.focusIndex, required this.handleFocusChange ,required this.termVal,required this.handleChange});

  @override
  AddTopicSecttionState createState() => AddTopicSecttionState();
}

class AddTopicSecttionState extends State<AddTopicSecttion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusTerm = FocusNode();
  final FocusNode _focusDef = FocusNode();
  late TextEditingController _controller1;
  late TextEditingController _controller2;

  @override
  void initState(){
    super.initState();
    _controller1 = TextEditingController(text: widget.termVal["term"]);
    _controller2 = TextEditingController(text: widget.termVal["definition"]);
    if(widget.index * 2 == widget.focusIndex){
      _focusTerm.requestFocus();
    }
    if(widget.index * 2 + 1 == widget.focusIndex){
      _focusDef.requestFocus();
    }
  }

  @override
  void didUpdateWidget(AddTopicSecttion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller1.text = widget.termVal["term"];
    _controller2.text = widget.termVal["definition"];
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

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
              controller: _controller1,
              focusNode: _focusTerm,
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
              },
              onTap: () {
                widget.handleFocusChange(widget.index * 2);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              focusNode: _focusDef,
              controller: _controller2,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
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
              onTap: () {
                widget.handleFocusChange(widget.index * 2 + 1);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
