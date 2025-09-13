import 'dart:async';

import 'package:flutter/material.dart';

import '../Login.dart';
import '../constants/Constants.dart';

mixin InactivityLogoutMixin<T extends StatefulWidget> on State<T> {
  Timer? _countdownTimer;
  int _countdown = 10;

  void startInactivityTimer() {
    Constants.inactivityTimer?.cancel();
    Constants.inactivityTimer = Timer(const Duration(minutes: 70), () {
      if (mounted) {
        _showLogoutDialog();
      }
    });
  }

  void restartInactivityTimer() {
    _countdownTimer?.cancel();
    Constants.inactivityTimer?.cancel();
    startInactivityTimer();
  }

  void _showLogoutDialog() {
    if (!mounted) return;

    _countdown = 10; // Reset countdown
    _countdownTimer
        ?.cancel(); // Cancel any existing timer before starting new one

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // Start the countdown timer once, outside of StatefulBuilder
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }

          if (_countdown > 0) {
            _countdown--;
            // Force rebuild of dialog
            try {
              (dialogContext as Element).markNeedsBuild();
            } catch (e) {
              // Dialog context is no longer valid, cancel timer
              timer.cancel();
            }
          } else {
            timer.cancel();
            if (mounted && Navigator.canPop(dialogContext)) {
              Navigator.of(dialogContext).pop(); // Close the dialog
            }
            if (mounted) {
              _signOut();
            }
          }
        });

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Inactive Session'),
              content: Text('You will be signed out in $_countdown seconds.'),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                              color: Constants.ctaColorLight,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetTimer();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Constants.ctaColorLight,
                                borderRadius: BorderRadius.circular(360)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5, bottom: 5),
                              child: const Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    ).then((_) {
      _countdownTimer
          ?.cancel(); // Ensure the timer is cancelled when the dialog is dismissed
    });
  }

  void _resetTimer() {
    // _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    const additionalTime = Duration(minutes: 1);
    Constants.inactivityTimer =
        Timer(const Duration(minutes: 2) + additionalTime, () {
      if (mounted) {
        _showLogoutDialog();
      }
    });
    // startInactivityTimer();
  }

  void _signOut() {
    if (!mounted) return;

    print("User has been signed out due to inactivity");
    try {
      for (int i = 1; i <= Constants.pageLevel; i++) {
        print("Went back $i");
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
      Constants.isLoggedIn = true;
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  @override
  void dispose() {
    Constants.inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
