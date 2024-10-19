import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class TestResultItem extends StatelessWidget {
  final bool isRight;
  final String question;
  final dynamic answer;
  const TestResultItem(
      {super.key,
      required this.isRight,
      required this.question,
      required this.answer});

  @override
  Widget build(BuildContext context) {
    Color color = isRight ? Colors.green : Colors.red;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Text("${getTranslated(context, "answer")}:",
                  style: const TextStyle(fontSize: 18, color: Colors.green)),
            ),
            answer["ans"].runtimeType != String ? Card(
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 18),
                      decoration: BoxDecoration(
                        color: answer["ans"]["labelColor"],
                      ),
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(answer["ans"]["label"],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                    ),
                    Text(answer["ans"]["content"],
                        style: const TextStyle(fontSize: 18))
                  ],
                )) : Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(answer["ans"],
                        style: const TextStyle(fontSize: 18))),
            answer["choose"] != null ? Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Text("${getTranslated(context, "your_answer")}:",
                  style: const TextStyle(fontSize: 18, color: Colors.red)),
            ) : const SizedBox.shrink(),
            answer["choose"] != null && answer["choose"].runtimeType != String
                ? Card(
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        answer["choose"].runtimeType != String ? Container(
                          margin: const EdgeInsets.only(right: 18),
                          decoration: BoxDecoration(
                            color: answer["choose"]["labelColor"],
                          ),
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          child: Text(answer["choose"]["label"],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                        ) : const SizedBox.shrink(),
                        Text(answer["choose"]["content"],
                            style: const TextStyle(fontSize: 18))
                      ],
                    ))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(answer["choose"] ?? "",
                        style: const TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}
