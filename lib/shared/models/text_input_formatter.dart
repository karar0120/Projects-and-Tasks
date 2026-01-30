import 'package:flutter/services.dart';

class ReplaceArToEnFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(
          text: newValue.text
              .replaceAll("ا", "a")
              .replaceAll("ب", "b")
              .replaceAll("ت", "t")
              .replaceAll("ث", "th")
              .replaceAll("ج", "j")
              .replaceAll("ح", "h")
              .replaceAll("خ", "kh")
              .replaceAll("د", "d")
              .replaceAll("ذ", "dh")
              .replaceAll("ر", "r")
              .replaceAll("ز", "z")
              .replaceAll("س", "s")
              .replaceAll("ش", "sh")
              .replaceAll("ص", "s")
              .replaceAll("ض", "d")
              .replaceAll("ط", "t")
              .replaceAll("ظ", "dh")
              .replaceAll("ع", "e")
              .replaceAll("غ", "gh")
              .replaceAll("ف", "f")
              .replaceAll("ق", "q")
              .replaceAll("ك", "k")
              .replaceAll("ل", "l")
              .replaceAll("م", "m")
              .replaceAll("ن", "n")
              .replaceAll("ه", "h")
              .replaceAll("و", "w")
              .replaceAll("ي", "y")
              .replaceAll("ى", "y")
              .replaceAll("لإ", "l")
              .replaceAll("إ", "a")
              .replaceAll("أ", "a")
              .replaceAll("ؤ", "w")
              .replaceAll("ئ", "y")
              .replaceAll("ة", "h")
              .replaceAll("ء", "")
              .replaceAll(" ", "-"),
          selection:TextSelection.fromPosition(
            TextPosition(offset: newValue.text.length),
          ),
          composing: TextRange.empty
      );
}