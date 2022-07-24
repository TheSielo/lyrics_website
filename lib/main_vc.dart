import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyrics_website/html_stub.dart';
import 'translated_text.dart';

class MainViewModel {
  String _japaneseText = '';
  String _translationText = '';
  List<List<String>> _furigana = [];
  TranslatedText? _lastTranslatedText;
  bool _furiganaEnabled = false;

  final _fieldsEditable = StreamController<bool>.broadcast();
  final _japaneseTextController = StreamController<String>.broadcast();
  final _translateTextController = StreamController<String>.broadcast();
  final _resultTextController = StreamController<TranslatedText>.broadcast();

  Sink get inputJapaneseText => _japaneseTextController;

  Sink get inputTranslationText => _translateTextController;

  Stream<bool> get outputFieldsEditable => _fieldsEditable.stream;

  Stream<TranslatedText> get outputResultText => _resultTextController.stream;

  MainViewModel() {
    init();
  }

  void init() {
    //Triggers the initial value, otherwise the streams will not emit
    // the initial test after creation;
    _japaneseTextController.stream.listen((text) {
      _furigana = [];
      _furiganaEnabled = true;
      _japaneseText = text;
      _produceResultText(false);
    });
    _translateTextController.stream.listen((text) {
      _furigana = [];
      _furiganaEnabled = true;
      _translationText = text;
      _produceResultText(false);
    });
  }

  void broadcastLastResult() {
    if (_lastTranslatedText != null) {
      _resultTextController.add(_lastTranslatedText!);
    }
  }

  void _produceResultText(bool isLoading) async {
    final japLines = _japaneseText.trim().split('\n');
    final transLines = _translationText.trim().split('\n');
    final fullTranslation = TranslatedText(
        isLoading, _furiganaEnabled, japLines, transLines, _furigana);
    _lastTranslatedText = fullTranslation;
    _resultTextController.add(fullTranslation);
  }

  void dispose() {
    _japaneseTextController.close();
    _translateTextController.close();
    _resultTextController.close();
  }

  getFuriganaClicked() async {
    _furiganaEnabled = false;
    _fieldsEditable.add(false);
    _produceResultText(true);
    if (_japaneseText.isNotEmpty) {
      var result = await http.get(Uri.parse(
          'https://api.sielotech.com/furigana?text=${_japaneseText.replaceAll('\n', '@@@')}'));
      final List<dynamic> list = jsonDecode(result.body);
      _furigana = list.map((e) => List<String>.from(e)).toList();
      _produceResultText(false);
      _fieldsEditable.add(true);
    }
  }

  downloadClicked() async {
    String output = _lastTranslatedText?.getHTML()??'';
    final List<int> bytes = utf8.encode(output);
    final content = base64Encode(bytes);
    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", "lyrics.html")
      ..click();
  }
}
