import 'dart:io';

import 'package:collageproject/services/states/filterOptions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;

import 'package:collageproject/components/token_input_field/token_input_field.dart';
import 'package:collageproject/screens/receive/gallery_image_btn.dart';
import 'package:collageproject/screens/receive/submit_decode_btn.dart';
import 'package:collageproject/services/context/app_context.dart';
import 'package:collageproject/services/converters/uploaded_img_to_data.dart';
import 'package:collageproject/services/requests/decode_request.dart';
import 'package:collageproject/services/requests/uploaded_img_conversion_request.dart';
import 'package:collageproject/services/responses/uploaded_img_conversion_response.dart';
import 'package:collageproject/services/states/app_running_states.dart';
import 'package:collageproject/services/states/loading_states.dart';
import 'package:provider/provider.dart';

/// Receive Screen
///
/// {@category Screens}
/// {@category Screens: Receive}
class ReceiveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReceiveScreen();
  }
}

class _ReceiveScreen extends State<ReceiveScreen> {
  Image image;
  imglib.Image editableImage;
  File imageFile;
  LoadingState uploadingState;
  TextEditingController tokenCtrl;
  bool decrypt;

  @override
  void initState() {
    super.initState();
    this.image =
        Image.asset('assets/photo_placeholder.png', fit: BoxFit.fitWidth);
    this.tokenCtrl = TextEditingController();
    this.decrypt = false;
  }

  Future<void> pickImageFromGallery() async {
    setState(() {
      uploadingState = LoadingState.LOADING;
    });
    AppRunningState appRunningState =
        Provider.of<AppContext>(context, listen: false).getAppRunningState();
    if (appRunningState == AppRunningState.INTEGRATION_TEST) {
      setState(() {
        this.image =
            Image.asset('assets/test_images/corgi.png', fit: BoxFit.fitWidth);
      });
    } else {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        print('got image');
        UploadedImageConversionResponse response =
            await convertUploadedImageToDataaAsync(
                UploadedImageConversionRequest(imageFile));
        editableImage = response.editableImage;
        setState(() {
          this.image = response.displayableImage;
        });
      }
    }
    setState(() {
      uploadingState = LoadingState.SUCCESS;
    });
  }

  void sendToDecode() {
    DecodeRequest req =
        DecodeRequest(this.editableImage, token: this.tokenCtrl.text);
    Navigator.pushNamed(context, '/decoded', arguments: req);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DECODE'),
        leading: IconButton(
            key: Key('receive_screen_back_btn'),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (filterOptions selectedValue) {
                if (selectedValue == filterOptions.withDecryption) {
                  setState(() {
                    this.decrypt = true;
                  });
                } else {
                  setState(() {
                    this.decrypt = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('with decryption'),
                      value: filterOptions.withDecryption,
                    ),
                    PopupMenuItem(
                      child: Text('without decryption'),
                      value: filterOptions.withoutDecryption,
                    )
                  ])
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: ListView(
          key: Key('decode_screen_scrollable_list'),
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: 600,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: this.image,
                )),
            SizedBox(
              height: 5.0,
            ),
            ReceiveScreenGallertyImageBtn(
              onUploadHandler: this.pickImageFromGallery,
              loadingState: this.uploadingState,
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: TokenInputField(
                this.decrypt,
                this.tokenCtrl,
                keyVal: 'decode_screen_token_input',
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            ReceiveScreenSubmitDecodeBtn(
              onSubmitDecodeHandler: this.sendToDecode,
            ),
          ],
        ),
      ),
    );
  }
}
