import 'package:lyrics_website/html_stub.dart';

class TranslatedText {
  final bool isLoading;
  late final bool canGetFurigana;
  late final bool hasFurigana;
  late final bool hasTranslations;
  late final bool translationsError;
  late final List<FuriganaLine> furiganaLines;
  final List<String> japaneseLines;
  final List<String> translatedLines;

  TranslatedText(this.isLoading, furiganaEnabled, this.japaneseLines,
      this.translatedLines, List<List<String>> furigana) {
    bool transError = false;
    hasFurigana = furigana.isNotEmpty;
    if (translatedLines.length > 1 || translatedLines[0].isNotEmpty) {
      //print('lines' + translatedLines.length.toString());
      hasTranslations = true;
      transError = translatedLines.length != japaneseLines.length;
    } else {
      hasTranslations = false;
    }
    if (furigana.isNotEmpty) {
      final furiganaResult =
          splitLines(hasTranslations, furigana, translatedLines);
      if (furiganaResult.error) {
        transError = true;
        furiganaLines = [];
      } else {
        furiganaLines = furiganaResult.furiganaLines;
      }
    } else {
      furiganaLines = [];
    }

    translationsError = transError;
    canGetFurigana = furiganaEnabled &&
        !transError &&
        japaneseLines.isNotEmpty &&
        japaneseLines[0].isNotEmpty;
  }

  FuriganaResult splitLines(
      bool translate, List<List<String>> fullText, List<String> translated) {
    bool error = false;
    List<FuriganaLine> split = [];
    List<Furigana> line = [];
    int linesCounter = 0;
    for (List<String> furigana in fullText) {
      if (furigana[0].contains("@@@")) {
        if (translate) {
          if (translated.length >= linesCounter) {
            split.add(FuriganaLine(line, translated[linesCounter]));
          } else {
            error = true;
            break;
          }
          do {
            linesCounter++;
          } while (translated[linesCounter].isEmpty);
        } else {
          split.add(FuriganaLine(line, ''));
        }
        line = [];
      } else {
        final base = furigana[0];
        final reading = furigana.length == 2 ? furigana[1] : '';
        line.add(Furigana(base, reading));
      }
    }
    split.add(FuriganaLine(line, translated[linesCounter]));

    final List<FuriganaLine> spacedSplit = [];
    int counter = 0;
    for (String l in japaneseLines) {
      if (l.isNotEmpty && split.length > counter) {
        spacedSplit.add(split[counter]);
        counter++;
      } else {
        spacedSplit.add(FuriganaLine([], ''));
      }
    }

    return FuriganaResult(error, spacedSplit);
  }

  String getHTML() {
    String text = '';
    for(int i = 0; i < japaneseLines.length; i++) {
      String jl = '';
      if(!hasFurigana) {
        jl = japaneseLines[i];
      } else {
        jl = furiganaLines[i].toHTMLString();
      }
      text += '$jl</br>';
      if(hasTranslations && !translationsError) {
        text += '${translatedLines[i]}</br>';
      }
      text += '</br>';
    }

    return '$htmlStart $text $htmlEnd';
  }
}

class FuriganaResult {
  bool error;
  List<FuriganaLine> furiganaLines;

  FuriganaResult(this.error, this.furiganaLines);
}

class FuriganaLine {
  List<Furigana> furiganaList;
  String translatedLine;

  FuriganaLine(this.furiganaList, this.translatedLine);

  @override
  String toString() {
    String text = '';
    for (Furigana furigana in furiganaList) {
      text += furigana.base;
      if (furigana.reading.isNotEmpty) {
        text += '(${furigana.reading}) ';
      } else {
        text += " ";
      }
    }
    return text;
  }

  String toHTMLString() {
    String text = '';
    for(Furigana furigana in furiganaList) {
      text += '<ruby>${furigana.base}';
      if(furigana.reading.isNotEmpty) {
        text += '<rt>${furigana.reading}</rt>';
      }
      text += '</ruby>';
    }
    return text;
  }
}

class Furigana {
  String base;
  String reading;

  Furigana(this.base, this.reading);
}
