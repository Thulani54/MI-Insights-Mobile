import 'dart:ui' as ui;
import 'package:d_chart/commons/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mi_insights/constants/Constants.dart' as constants;
import 'package:http_parser/http_parser.dart';

Future<void> uploadDigitalSignature({
  required int onololeadid,
  required Uint8List signatureBytes,
}) async {
  try {
    // Define the endpoint and headers
    final url = Uri.parse(
        '${constants.Constants.InsightsReportsbaseUrl}/upload_digital_signature/$onololeadid/');
    final headers = {'Content-Type': 'multipart/form-data'};

    // Prepare the file as a multipart request
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile.fromBytes(
          'digital_signature',
          signatureBytes,
          filename: 'signature.png',
          contentType: MediaType('image', 'png'),
        ),
      );

    // Send the request
    final response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      print(
          'Digital signature uploaded successfully: ${responseJson['message']}');
    } else {
      throw Exception(
          'Failed to upload digital signature. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading digital signature: $e');
  }
}

Future<Uint8List?> getDigitalSignature({
  required int onololeadid,
  required int cecClientId,
}) async {
  try {
    // Define the endpoint and query parameters
    final url = Uri.parse(
      '${constants.Constants.InsightsReportsbaseUrl}/api/get_digital_signature/?onololeadid=$onololeadid&cec_client_id=$cecClientId',
    );

    // Send the GET request
    final response = await http.get(url);

    // Handle the response
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Retrieve the signature URL
      final signatureUrl = responseBody['signature_url'];

      // Fetch the image bytes from the signature URL
      final signatureResponse = await http.get(
          Uri.parse(constants.Constants.InsightsReportsbaseUrl + signatureUrl));
      if (signatureResponse.statusCode == 200) {
        return signatureResponse.bodyBytes; // Return the image bytes
      } else {
        throw Exception('Failed to fetch the digital signature image.');
      }
    } else if (response.statusCode == 404) {
      print('No digital signature found for this OTP.');
      return null;
    } else {
      throw Exception(
          'Failed to retrieve digital signature. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error retrieving digital signature: $e');
    return null;
  }
}

class FieldClientSignature extends StatefulWidget {
  FieldClientSignature({Key? key}) : super(key: key);

  @override
  _FieldClientSignatureState createState() => _FieldClientSignatureState();
}

class _FieldClientSignatureState extends State<FieldClientSignature> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveAndUploadButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    if (bytes != null) {
      await uploadDigitalSignature(
        onololeadid: constants.Constants.currentleadAvailable!.leadObject
            .onololeadid, // Replace with the actual lead ID
        signatureBytes: bytes.buffer.asUint8List(),
      );
    }
  }

  void _handleRetrieveSignature() async {
    final signatureBytes = await getDigitalSignature(
      onololeadid:
          constants.Constants.currentleadAvailable!.leadObject.onololeadid,
      cecClientId: constants
          .Constants.cec_client_id, // Replace with the actual client ID
    );

    if (signatureBytes != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(title: Text('Retrieved Signature')),
              body: Center(
                child: Image.memory(signatureBytes),
              ),
            );
          },
        ),
      );
    } else {
      print('No signature found for the given lead ID and client ID.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: SfSignaturePad(
              key: signatureGlobalKey,
              backgroundColor: Colors.white,
              strokeColor: Colors.black,
              minimumStrokeWidth: 1.0,
              maximumStrokeWidth: 4.0,
            ),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            TextButton(
              child: Text('Save & Upload',
                  style: TextStyle(color: constants.Constants.ctaColorLight)),
              onPressed: _handleSaveAndUploadButtonPressed,
            ),
            TextButton(
              child: Text('Retrieve',
                  style: TextStyle(color: constants.Constants.ctaColorLight)),
              onPressed: _handleRetrieveSignature,
            ),
            TextButton(
              child: Text('Clear',
                  style: TextStyle(color: constants.Constants.ctaColorLight)),
              onPressed: _handleClearButtonPressed,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
