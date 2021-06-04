import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji cutoff',
      theme: ThemeData.light(),
      home: EmojiCutoff(),
    );
  }
}

class EmojiCutoff extends StatelessWidget {
  const EmojiCutoff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showEmojiPicker(context);
          },
          child: Text('Press me'),
        ),
      ),
    );
  }

  Future<void> _showEmojiPicker(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.all(8),
          child: EmojiPicker(),
        ),
      ),
    );
  }
}

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({Key? key}) : super(key: key);

  @override
  _EmojiPickerState createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker>
    with SingleTickerProviderStateMixin {
  final emojis = const [
    '❤️',
    '😂',
    '🔥',
    '😍',
    '👍',
    '🤔',
    '👽',
    '😊',
    '🥰',
  ];
  static const _scaleDuration = Duration(milliseconds: 450);
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _scaleDuration,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FittedBox(
        child: Row(
          children: emojis.asMap().entries.map(
            (entry) {
              var index = entry.key;
              var emoji = entry.value;

              final animation = Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index / emojis.length),
                    1.0,
                    curve: Curves.linearToEaseOut,
                  ),
                ),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
