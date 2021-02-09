import 'package:flutter/material.dart';
import 'package:collageproject/screens/home/home_screen.dart';
import 'package:collageproject/screens/send/send_screen.dart';
import 'package:collageproject/screens/receive/receive_screen.dart';
import 'package:collageproject/screens/encoded/encoding_result_screen.dart';
import 'package:collageproject/screens/decoded/decoding_result_screen.dart';

class CollageProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steganography',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        canvasColor: Colors.white, //Color.fromRGBO(255, 254, 229, 1),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/send': (context) => SendScreen(),
        '/receive': (context) => ReceiveScreen(),
        '/encoded': (context) => EncodingResultScreen(),
        '/decoded': (context) => DecodingResultScreen(),
      },
    );
  }
}
