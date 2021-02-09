import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:collageproject/services/requests/uploaded_img_conversion_request.dart';
import 'package:collageproject/services/responses/uploaded_img_conversion_response.dart';
import 'package:image/image.dart' as imglib;
import 'package:collageproject/services/utilities/get_capacity.dart';

UploadedImageConversionResponse convertUploadedImageToData(
    UploadedImageConversionRequest req) {
  imglib.Image editableImage = imglib.decodeImage(req.file.readAsBytesSync());
  Image displayableImage = Image.file(req.file, fit: BoxFit.fitWidth);
  int imageByteSize = getEncoderCapacity(
      Uint16List.fromList(editableImage.getBytes().toList()));
  UploadedImageConversionResponse response = UploadedImageConversionResponse(
      editableImage, displayableImage, imageByteSize);
  return response;
}

Future<UploadedImageConversionResponse> convertUploadedImageToDataaAsync(
    UploadedImageConversionRequest req) async {
  UploadedImageConversionResponse response = await compute<
      UploadedImageConversionRequest,
      UploadedImageConversionResponse>(convertUploadedImageToData, req);
  return response;
}
