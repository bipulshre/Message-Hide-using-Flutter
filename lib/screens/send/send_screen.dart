import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collageproject/components/token_input_field/token_input_field.dart';
import 'package:collageproject/screens/send/gallery_img_btn.dart';
import 'package:collageproject/screens/send/image_preview.dart';
import 'package:collageproject/services/context/app_context.dart';
import 'package:collageproject/services/converters/uploaded_img_to_data.dart';
import 'package:collageproject/services/requests/capacity_usage_request.dart';
import 'package:collageproject/services/requests/encode_request.dart';
import 'package:image/image.dart' as imglib;
import 'package:collageproject/services/requests/uploaded_img_conversion_request.dart';
import 'package:collageproject/services/responses/uploaded_img_conversion_response.dart';
import 'package:collageproject/services/states/app_running_states.dart';
import 'package:collageproject/services/states/loading_states.dart';
import 'package:collageproject/services/utilities/capacity_usage.dart';
import 'package:provider/provider.dart';
import 'package:collageproject/services/states/filterOptions.dart';

/// Send Screen
///
/// {@category Screens}
/// {@category Screens: Send}
class SendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SendScreen();
  }
}

class _SendScreen extends State<SendScreen> {
  File imageFile;
  imglib.Image editableImage;
  Image image;
  int imageByteSize;
  TextEditingController msgCtrl;
  TextEditingController tokenCtrl;
  bool encrypt;
  bool pickedImg;
  //double capacityUsageStats;
  //String capacityUsage;
  LoadingState uploadingState;

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
        this.pickedImg = true;
        this.imageByteSize = 1000;
      });
    } else {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        UploadedImageConversionResponse response =
            await convertUploadedImageToDataaAsync(
                UploadedImageConversionRequest(imageFile));
        editableImage = response.editableImage;
        setState(() {
          this.image = response.displayableImage;
          this.pickedImg = true;
          this.imageByteSize = response.imageByteSize;
        });
      }
    }
    setState(() {
      uploadingState = LoadingState.SUCCESS;
    });
  }

  Future<void> sendToEncode() async {
    EncodeRequest req = EncodeRequest(this.editableImage, msgCtrl.text,
        token: this.tokenCtrl.text);
    Navigator.pushNamed(context, '/encoded', arguments: req);
  }

  // Future<void> onMessageChange(String msg) async {
  //   if (!this.pickedImg ||
  //       this.editableImage == null ||
  //       this.image == null ||
  //       this.imageByteSize == 0) {
  //     setState(() {
  //       this.capacityUsage = 'Not applicable, no image uploaded';
  //       this.capacityUsageStats = 1.0;
  //     });
  //   } else {
  //     double usage = await calculateCapacityUsageAsync(
  //         CapacityUsageRequest(msg, this.imageByteSize));
  //     usage = min(usage, 0.99);
  //     String strUsage = (usage * 100.0).toString();
  //     if (strUsage.length > 5) {
  //       strUsage = strUsage.substring(1, 6);
  //     }
  //     setState(() {
  //       this.capacityUsageStats = usage;
  //       this.capacityUsage = 'Usage: ' + strUsage + '%';
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    this.image =
        Image.asset('assets/photo_placeholder.png', fit: BoxFit.fitWidth);
    this.msgCtrl = TextEditingController();
    this.tokenCtrl = TextEditingController();
    this.encrypt = false;
    this.uploadingState = LoadingState.PENDING;
    this.pickedImg = false;
    //this.capacityUsage = 'Not applicable, no image uploaded';
    //this.capacityUsageStats = 0.0;
    this.imageByteSize = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ENOCDE"),
        leading: IconButton(
            key: Key('send_screen_back_btn'),
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (filterOptions selectedValue) {
                if (selectedValue == filterOptions.withEncryption) {
                  setState(() {
                    this.encrypt = true;
                  });
                } else {
                  setState(() {
                    this.encrypt = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('with encryption'),
                      value: filterOptions.withEncryption,
                    ),
                    PopupMenuItem(
                      child: Text('without encryption'),
                      value: filterOptions.withoutEncryption,
                    )
                  ])
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: ListView(
          key: Key('encode_screen_scrollable_list'),
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            SendScreenImageReview(this.image),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            SendScreenGalleryImageBtn(
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
              child: TextField(
                key: Key('encode_screen_msg_input'),
                controller: this.msgCtrl,
                //onChanged: this.onMessageChange,
                decoration: InputDecoration(
                  labelText: 'Enter the Message',
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            // Container(
            //   child: Row(
            //     children: <Widget>[
            //       Checkbox(
            //           key: Key('encode_screen_token_checkbox'),
            //           value: this.encrypt,
            //           onChanged: (bool nextVal) {
            //             setState(() {
            //               this.encrypt = nextVal;
            //             });
            //           }),
            //       Text('Encrypt my message!'),
            //     ],
            //   ),
            // ),
            TokenInputField(
              this.encrypt,
              this.tokenCtrl,
              keyVal: 'encode_screen_token_input',
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: RaisedButton(
                key: Key('encode_screen_encode_btn'),
                onPressed: this.sendToEncode,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 15.0,
                      ),
                      Text("Encode"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
