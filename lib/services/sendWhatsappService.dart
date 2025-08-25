import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '../constants/Constants.dart';

Future<void> sendWhatsAppMessage(Map<String, dynamic> payload) async {
  final String fbToken = Constants.fbToken.trim();

  // Debugging statements
  print("Token Length: ${fbToken.length}");
  print("Token Characters:");
  fbToken.runes.forEach((int rune) {
    var character = new String.fromCharCode(rune);
    print('$rune: $character');
  }); // Ensure token is sanitized
  final String url =
      "https://graph.facebook.com/v${Constants.whatsapApiVersion}/${Constants.fromWhatsAppNumberId}/messages";
  print(url);

  // Validate the token
  if (fbToken.isEmpty) {
    print("Error: Facebook token is empty. Please provide a valid token.");
    return;
  }

  final headers = {
    "Accept": "application/json",
    "Authorization":
        "Bearer EAANikCZC1uY0BO0GAM2207Ps8DBqJaMGKkW5gOjwYusRiT0ZBnJouqDr9WiNBVW4BXeRduAB8OY11V6PRrVlLk74ZCBcjgzLhXh0bmlFxetqQSLyQz91E8dcxOTZBvNM2IsKqPEsjSuJAlS5TkEOCoJgILdP0A0ExVirojEWQx0i6FP147H7VHQaExtugPA5mSO951NmG6W4eXgH",
    "Content-Type": "application/json",
  };

  // Log headers and payload
  print("Headers: ${jsonEncode(headers)}");
  print("Payload: ${jsonEncode(payload)}");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(payload),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Success! Response received: ${jsonEncode(responseData)}");
    } else {
      print("Error! Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }
  } on http.ClientException catch (e) {
    print("ClientException: $e");
  } catch (e) {
    print("An unexpected error occurred: $e");
  }
}

Future<void> saveUserData(
    String phoneNumber, Map<String, dynamic> userData) async {
  // Mock implementation for saving user data
  print("Saving user data for $phoneNumber: ${jsonEncode(userData)}");
}

Future<void> saveIncomingMessage(
    String phoneNumber, Map<String, dynamic> messageData) async {
  try {
    // Reference to the Firebase Realtime Database
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref();

    // Use the message's unique ID as the key, or generate one if not provided
    String messageId = messageData['id'] ?? _databaseReference.push().key;

    // Path to store the message: incoming_messages/{phoneNumber}/{messageId}
    await _databaseReference
        .child('michats')
        .child('incoming_messages')
        .child(phoneNumber)
        .child(messageId)
        .set(messageData);

    print("Message saved successfully for $phoneNumber.");
  } catch (e) {
    print("Error saving message for $phoneNumber: $e");
  }
}
