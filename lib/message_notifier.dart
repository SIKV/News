import 'dart:async';

MessageNotifier messageNotifier = MessageNotifier.internal();

class MessageNotifier {
  static MessageNotifier _instance = MessageNotifier.internal();
  MessageNotifier.internal();
  factory MessageNotifier() => _instance;

  final StreamController<String> _streamController = StreamController.broadcast();

  void post(String value) {
    _streamController.add(value);
  }

  void listen(onMessage(String message)) {
    _streamController.stream.listen(onMessage);
  }

  void dispose() {
    _streamController.close();
  }
}