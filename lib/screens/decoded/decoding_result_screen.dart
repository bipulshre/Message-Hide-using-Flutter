import 'package:flutter/material.dart';
import 'package:collageproject/services/decoder.dart';
import 'package:collageproject/services/requests/decode_request.dart';
import 'package:collageproject/services/responses/decode_response.dart';

/// Decode Result Screen
///
/// {@category Screens}
/// {@category Screens: Decode Result}
class DecodingResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DecodingResultScreen();
  }
}

class _DecodingResultScreen extends State<DecodingResultScreen> {
  Future<String> decodedMsg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context).settings.arguments != null) {
      DecodeRequest req = ModalRoute.of(context).settings.arguments;
      decodedMsg = this.decodeMsg(req);
    }
  }

  Future<String> decodeMsg(DecodeRequest req) async {
    DecodeResponse response =
        await decodeMessageFromImageAsync(req, context: context);
    String msg = response.decodedMsg;
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DECODED'),
        leading: IconButton(
            key: Key('decoded_screen_back_btn'),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<String>(
          future: this.decodedMsg,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Text(
                        'Decoded Message: ',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          snapshot.data,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        'Whoops >_<',
                        style: TextStyle(fontSize: 30.0),
                      )),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child:
                          Center(child: Text('It seems something went wrong')),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                  ],
                ),
              );
            } else {
              return Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                      child: Text('Please wait, message is being decoded...'),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
