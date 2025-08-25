import 'package:mi_insights/services/sendWhatsappService.dart';

import '../constants/Constants.dart';

class CallCenterService {
  Future<void> createNewUser({
    required String phoneNumber,
    required String username,
    required String messageBody,
  }) async {
    // Current timestamp
    final now = DateTime.now().toIso8601String();

    // User data
    final userData = {
      'phone_number': phoneNumber,
      'username': username,
      'step': 'introduction',
      'initial_message': messageBody,
      'step_no': 1,
      'prefer_to_chat_to_human': false,
      'title': '',
      'created_at': now,
      'updated_at': now,
    };

    // Store user data in Firebase or local storage
    // Replace with your Firebase SDK or database implementation
    await saveUserData(phoneNumber, userData);

    // Determine greeting based on the current time
    final currentHour = DateTime.now().hour;
    String greeting;
    if (currentHour < 12) {
      greeting = 'Good Morning';
    } else if (currentHour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    final messageText =
        "$greeting, you are chatting to ${Constants.myDisplayname} from ${Constants.business_name}. Is this a good time for me to take you through our benefits?";

    // Prepare the payload for sending a message
    final payload = {
      "messaging_product": "whatsapp",
      "to": phoneNumber,
      "recipient_type": "individual",
      "type": "interactive",
      "interactive": {
        "type": "list",
        "body": {
          "text": messageText,
        },
        "footer": {
          "text": "Please select one of the options",
        },
        "action": {
          "button": "Choose",
          "sections": [
            {
              "title": "Options",
              "rows": [
                {"id": "yes_initial", "title": "Yes"},
                {"id": "no_initial", "title": "No"},
              ],
            },
          ],
        },
      },
    };

    // Send the WhatsApp message
    await sendWhatsAppMessage(
      payload,
    );

    // Store the message in incoming messages table
    final incomingMessageData = {
      'message': messageText,
      'timestamp': now,
      'step': 'introduction',
      'step_no': 1,
      "sent_by": "business",
      "cec_message_type_id": 0
    };
    await saveIncomingMessage(phoneNumber, incomingMessageData);
  }
}
