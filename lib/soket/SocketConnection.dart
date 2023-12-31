import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketConnection {
  io.Socket? socket;

  // Other methods and properties...

  Future<void> initializeApp() async {
    print('Connecting to the server...');
    socket = io.io('https://handlerequests.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    print(socket!.connected);
    print('Connected to the server.');
    print('Emitting a chat message...');


  }


}
