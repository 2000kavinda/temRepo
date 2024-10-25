import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants/text_strings.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  String otp = ""; // Initialize otp with an empty string

  @override
  Widget build(BuildContext context) {
    var otpController = Get.put(OtpController());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(CSDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CSOtpTitle,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 50.0,
                color: CSAccentColor,
              ),
            ),
            Text(
              CSOtpSubTitle.toUpperCase(),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40.0),
            Text(
              "$CSOtpMessage ${widget.phoneNumber}",
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              fieldWidth: 40.0,
              onSubmit: (code) {
                setState(() {
                  otp = code;
                });
                OtpController.instance.verifyOTP(otp);
              },
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (otp.isNotEmpty) {
                    OtpController.instance.verifyOTP(otp);
                  } else {
                    // Handle the case where otp is not provided
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the OTP'),
                      ),
                    );
                  }
                },
                child: Text(CSNext.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
