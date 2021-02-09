import 'package:flutter/material.dart';
import 'package:collageproject/screens/home/btns/start_decode_btn.dart';
import 'package:collageproject/screens/home/btns/start_encode_btn.dart';
import 'package:collageproject/services/context/app_context.dart';
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';

/// Home Screen
///
/// {@category Screens}
/// {@category Screens: Home}
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppContext>(context, listen: false).initializeContext();
  }

  @override
  initState() {
    super.initState();
    setupAlan();
  }

  setupAlan() {
    AlanVoice.addButton(
        "e0048310a2b5fd84cef7e7752698d5162e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steganography'),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff21254A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/homepage1.png"))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Everything we see,\nmay not be the truth",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HomeScreenStartEncodeBtn(),
                    SizedBox(
                      width: 20,
                      height: 30,
                    ),
                    HomeScreenStartDecodeBtn(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  //     body: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             child: Image(
  //               image: AssetImage("assets/images/homepage.jpg"),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           RichText(
  //             text: TextSpan(
  //               text: "Everything we see is a prespective, not the truth",
  //               style: TextStyle(
  //                   fontSize: 16.0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               HomeScreenStartEncodeBtn(),
  //               SizedBox(
  //                 width: 20,
  //                 height: 30,
  //               ),
  //               HomeScreenStartDecodeBtn(),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
