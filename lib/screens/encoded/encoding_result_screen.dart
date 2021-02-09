import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collageproject/components/btn_logo/btn_logo_with_loading_error.dart';
import 'package:collageproject/services/encoder.dart';
import 'package:collageproject/services/requests/encode_request.dart';
import 'package:collageproject/services/requests/encode_result_screen_render_request.dart';
import 'package:collageproject/services/responses/encode_response.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:collageproject/services/states/encode_result_states.dart';
import 'package:collageproject/services/states/loading_states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Encode Result Screen
///
/// {@category Screens}
/// {@category Screens: Encode Result}
class EncodingResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EncodingResultScreen();
  }
}

class _EncodingResultScreen extends State<EncodingResultScreen> {
  Future<DecodeResultScreenRenderRequest> renderRequest;
  LoadingState savingState;

  @override
  void initState() {
    super.initState();
    this.savingState = LoadingState.PENDING;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context).settings.arguments != null) {
      EncodeRequest encodeReq = ModalRoute.of(context).settings.arguments;
      renderRequest = requestEncodeImage(encodeReq);
    }
  }

  Future<DecodeResultScreenRenderRequest> requestEncodeImage(
      EncodeRequest req) async {
    EncodeResponse response =
        await encodeMessageIntoImageAsync(req, context: context);
    return DecodeResultScreenRenderRequest(
        DecodeResultState.SUCCESS, response.data, response.displayableImage);
  }

  Future<void> saveImage(Uint8List imageData) async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStorage = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permissionStorage != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissionStatus =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        permissionStorage = permissionStatus[PermissionGroup.storage] ??
            PermissionStatus.unknown;

        if (permissionStorage != PermissionStatus.granted) {
          print('no storage permission to save image');
          return;
        }
      }
    }
    setState(() {
      this.savingState = LoadingState.LOADING;
    });
    dynamic response = await ImageGallerySaver.saveImage(imageData);
    print(response);
    if (response.toString().toLowerCase().contains('not found')) {
      setState(() {
        this.savingState = LoadingState.ERROR;
      });
      throw FlutterError('save_image_to_gallert_failed');
    }
    setState(() {
      this.savingState = LoadingState.SUCCESS;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ENCODE'),
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<DecodeResultScreenRenderRequest>(
          future: this.renderRequest,
          builder: (BuildContext context,
              AsyncSnapshot<DecodeResultScreenRenderRequest> snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: snapshot.data.encodedImage,
                    )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          this.saveImage(snapshot.data.encodedByteImage);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonLogoWithLoadingAndError(
                                this.savingState, Icons.save),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text('Save'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
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
                        'Alert!',
                        style: TextStyle(fontSize: 30.0),
                      )),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      child: Center(child: Text(snapshot.error.toString())),
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
              // return Container(
              //   child: ListView(
              //     children: <Widget>[
              //       Container(
              //           padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(8.0),
              //           )),
              //       Container(
              //         padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
              //         child: Text(
              //             'Please wait, The message is being encoded......'),
              //       ),
              //     ],
              //   ),
              // );
              return Container(
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Colors.black,
                    size: 80,
                  ),
                ),
              );
            }
          }),
    );
  }
}
