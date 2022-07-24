import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_website/utils.dart';
import 'package:ruby_text/ruby_text.dart';
import 'translated_text.dart';

import 'content_strings.dart';
import 'main_vc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _modelView = MainViewModel();
  final japaneseController = TextEditingController();
  final translationController = TextEditingController();

  @override
  initState() {
    super.initState();
    japaneseController.text = defaultJapanese;
    translationController.text = defaultTranslation;
    _modelView.inputJapaneseText.add(japaneseController.value.text);
    _modelView.inputTranslationText.add(translationController.value.text);
  }

  @override
  dispose() {
    super.dispose();
    _modelView.dispose();
    japaneseController.dispose();
    translationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (isMobile() || width < 800) {
      return _tabbedView();
    } else {
      return _defaultView();
    }
  }

  Widget _defaultView() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: SizedBox(
            width: double.infinity,
            child: _title(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _japaneseColumn()),
              const SizedBox(
                width: 30,
              ),
              Expanded(child: _resultColumn()),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: _translationColumn(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabbedView() {
    return DefaultTabController(
      initialIndex: 2,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _title(),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Japanese',
              ),
              Tab(
                text: 'Translation',
              ),
              Tab(
                text: 'Result',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: _japaneseColumn(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _translationColumn(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _resultColumn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return const RubyText(
      [
        RubyTextData('日本語', ruby: 'にほんご'),
        RubyTextData('　の　リリック　の　メーカ！'),
      ],
    );
  }

  Widget _centralText() {
    return Expanded(
      child: StreamBuilder<TranslatedText>(
        stream: _modelView.outputResultText,
        builder: (context, snapshot) {
          if (kDebugMode) {
            print('Snapshot:${snapshot.data ?? 'null'}');
          }
          final data = snapshot.data;
          if (data != null) {
            if (data.isLoading) {
              return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            } else if (data.japaneseLines.isEmpty) {
              return const Text('Type some text in the Japanese column.');
            } else {
              if (!data.hasFurigana) {
                return _noFuriganaCentral(data);
              } else if (data.furiganaLines.isNotEmpty &&
                  data.furiganaLines[0].furiganaList.isNotEmpty) {
                return _furiganaCentral(data);
              } else {
                return const Text('An error occurred');
              }
            }
          } else {
            _modelView.broadcastLastResult();
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _noFuriganaCentral(TranslatedText data) {
    return SingleChildScrollView(
      child: Column(
          children: data.japaneseLines.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(value),
            ),
            if (data.hasTranslations && !data.translationsError)
              SizedBox(
                width: double.infinity,
                child: Text(data.translatedLines[index]),
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }).toList()),
    );
  }

  Widget _furiganaCentral(TranslatedText data) {
    return SingleChildScrollView(
      child: Column(
        children: data.furiganaLines.map((line) {
          return Column(
            children: [
              _furiganaLine(line),
              if (!data.translationsError && line.translatedLine.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Text(line.translatedLine),
                ),
              const SizedBox(
                height: 17,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _resultColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreamBuilder<TranslatedText>(
            stream: _modelView.outputResultText,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data!.translationsError) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xfffcda53),
                          border: Border.all(
                            width: 1,
                            // assign the color to the border color
                            color: Colors.grey,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'The translation has a different number '
                          'of lines than the japanese text. Fix the problem to show it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        _centralText(),
        const SizedBox(
          height: 15,
        ),
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: StreamBuilder<TranslatedText>(
                stream: _modelView.outputResultText,
                builder: (context, snapshot) {
                  final isClickable =
                      snapshot.data == null || snapshot.data!.canGetFurigana;
                  return ElevatedButton(
                    onPressed:
                        isClickable ? _modelView.getFuriganaClicked : null,
                    child: const RubyText(
                      [
                        RubyTextData('振り仮名', ruby: 'ふりがな'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: StreamBuilder<TranslatedText>(
                stream: _modelView.outputResultText,
                builder: (context, snapshot) {
                  final isClickable = snapshot.data == null ||
                      !snapshot.data!.translationsError;
                  return ElevatedButton(
                    onPressed: isClickable ? _modelView.downloadClicked : null,
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _japaneseColumn() {
    return SizedBox(
      height: double.infinity,
      child: StreamBuilder<bool>(
        stream: _modelView.outputFieldsEditable,
        builder: (context, snapshot) {
          return TextField(
            enabled: snapshot.data ?? true,
            onChanged: (text) {
              _modelView.inputJapaneseText.add(text);
            },
            controller: japaneseController,
            minLines: 1000,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          );
        },
      ),
    );
  }

  _translationColumn() {
    return SizedBox(
      height: double.infinity,
      child: StreamBuilder<bool>(
        stream: _modelView.outputFieldsEditable,
        builder: (context, snapshot) {
          return TextField(
            enabled: snapshot.data ?? true,
            onChanged: (text) {
              _modelView.inputTranslationText.add(text);
            },
            controller: translationController,
            minLines: 1000,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          );
        },
      ),
    );
  }

  Widget _furiganaLine(FuriganaLine line) {
    return SizedBox(
      width: double.infinity,
      child: Text(line.toString()),
    );
  }
}
