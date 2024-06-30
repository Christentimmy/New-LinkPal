import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  final String url;
  late WebSocketChannel _channel;
  final controller = StreamController<Map<String, dynamic>>();

  WebsocketService(this.url) {
    connect();
  }

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel.stream.listen(
      (message) {
        final decodedResponse = json.decode(message);
        print(decodedResponse);
      },
      onError: (e){
        print(e);
      }
    );
  }
}
