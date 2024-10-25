import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:codesafari/src/constants/FAQ_QA.dart';
import 'package:codesafari/src/features/core/screens/assisting_system/FAQ.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_speech/config/recognition_config_v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:codesafari/src/repository/QA_repository/QA_repository.dart';
import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/text_strings.dart';
import 'package:codesafari/src/features/core/screens/assisting_system/Custom_QA.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart' as stt;
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pbgrpc.dart' as stt;
import 'package:grpc/grpc.dart' as grpc;
import 'package:cheetah_flutter/cheetah.dart';

class AssistingSystem extends StatefulWidget {
  const AssistingSystem({super.key});

  @override
  _AssistingSystemState createState() => _AssistingSystemState();
}

class _AssistingSystemState extends State<AssistingSystem> {
  bool isTamil = false;
  final TextEditingController _textController = TextEditingController();
  bool _isTextEmpty = true;
  final ImagePicker _picker = ImagePicker();
  bool _hasAskedQuestion = false; // Track if the user has asked a question
  final QARepository _qaRepository = QARepository(); // Add QARepository instance
  bool _isLoading = false; // Track loading state
  String? _response; // Store the response
  final List<Map<String, dynamic>> resJson = [];
  final ScrollController _scrollController = ScrollController(); // Add ScrollController
  String? _base64Image; // Store the base64 image string
  int _countdown = 5;
  Timer? _timer;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = '';
  bool isTranscribing = false;
  String content = '';
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose(); // Dispose ScrollController
    _timer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _textController.text.isEmpty;
    });
  }


  Future<void> _askQuestionByVoice() async {
    // Initialize the speech recognizer
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _transcribedText = ''; // Reset transcribed text
      });

      _speech.listen(
        onResult: (val) async {
          _transcribedText = val.recognizedWords;

          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        listenFor: Duration(seconds: 5), // Listen for 5 seconds
      );

      // Wait for the listening duration to complete
      await Future.delayed(Duration(seconds: 5));

      setState(() {
        _isLoading = true;
        _hasAskedQuestion = true;
        _isListening = false;
      });

      print(_transcribedText);

      if (_transcribedText.isNotEmpty) {
        try {
          final formattedText = _transcribedText.trim(); // Format the transcribed text
          final response = await _qaRepository.askQuestionByText(formattedText);
          if (response != null && response['message'] != null && response['message']['response'] != null && response['message']['response']['AI-Mentor'] != null) {
            final nestedResponse = response['message']['response']['AI-Mentor']['response'];
            setState(() {
              _response = response.toString();
              resJson.add({
                'question': formattedText,
                'answer': {
                  'eng': nestedResponse['res_eng'],
                  'tamil': nestedResponse['res_tam'],
                },
              });
              _isLoading = false;
            });
          } else {
            setState(() {
              _response = 'Error: Invalid response format';
              _isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            _response = 'Error asking question by text: $e';
            _isLoading = false;
          });
        }
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Speech recognition not available');
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _openCamera() async {
    if (await Permission.camera.request().isGranted) {
      try {
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          final imageBytes = await File(image.path).readAsBytes();
          final decodedImage = img.decodeImage(imageBytes);

          if (decodedImage != null) {
            final jpgImage = img.encodeJpg(decodedImage);
            final tempDir = await getTemporaryDirectory();
            final tempFile = File('${tempDir.path}/captured_image.jpg');
            await tempFile.writeAsBytes(jpgImage);
            final xFile = XFile(tempFile.path);
            await _askQuestionByImage(xFile);
          } else {
            print('Error: Unable to decode image.');
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> _openFileExplorer() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _askQuestionByImage(image);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _askQuestionByImage(XFile image) async {
    setState(() {
      _isLoading = true;
      _hasAskedQuestion = true;
    });
    final response = await _qaRepository.askQuestionByImage(File(image.path));
    setState(() {
      _response = response.toString();
      print(response);
      print(response.runtimeType);
      final nestedResponse = response['message']['response']['AI-Mentor']['response'];
      resJson.add({
        'question': 'Image Question',
        'answer': {
          'eng': nestedResponse['res_eng'],
          'tamil': nestedResponse['res_tam'],
        },
      });
      print(resJson);
      _isLoading = false;
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _askQuestion() async {
    setState(() {
      _isLoading = true;
      _hasAskedQuestion = true;
    });
    final question = _textController.text;
    if (question.isNotEmpty) {
      try {
        final response = await _qaRepository.askQuestionByText(question);
        if (response != null && response['message'] != null && response['message']['response'] != null && response['message']['response']['AI-Mentor'] != null) {
          final nestedResponse = response['message']['response']['AI-Mentor']['response'];
          setState(() {
            _response = response.toString();
            resJson.add({
              'question': question,
              'answer': {
                'eng': nestedResponse['res_eng'],
                'tamil': nestedResponse['res_tam'],
              },
            });
            _isLoading = false;
          });
        } else {
          setState(() {
            _response = 'Error: Invalid response format';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _response = 'Error asking question by text: $e';
          _isLoading = false;
        });
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<String> getFullName() async {

    return await loginController.getFullName() ?? 'User';
  }

  String getGreeting(String username) {
    const morningEmojis = ['☀️', '🌅', '🌞', '🌄', '🌤'];
    const afternoonEmojis = ['🌞', '🌻', '🌼', '🌿', '🌳'];
    const eveningEmojis = ['🌇', '🌆', '🌃', '⭐', '🌌'];

    final random = Random();
    final hour = DateTime.now().hour;
    if (hour < 12) {
      final emoji = morningEmojis[random.nextInt(morningEmojis.length)];
      return 'Good Morning, $username!  $emoji';
    } else if (hour < 17) {
      final emoji = afternoonEmojis[random.nextInt(afternoonEmojis.length)];
      return 'Good Afternoon, $username!  $emoji';
    } else {
      final emoji = eveningEmojis[random.nextInt(eveningEmojis.length)];
      return 'Good Evening, $username!  $emoji';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDarkTheme ? CSDarkCardBgColor : CSLightCardBgColor;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController, // Attach ScrollController
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<String>(
                            future: getFullName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CSAccentColor,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  'Error loading name',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CSAccentColor,
                                  ),
                                );
                              } else {
                                final userName = snapshot.data ?? 'User';
                                return Text(
                                  getGreeting(userName),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: CSAccentColor,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        if (!_hasAskedQuestion) // Conditionally render FAQ section
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: cardBgColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          CSKASFaq,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: CSAccentColor,
                                          ),
                                        ),
                                        FutureBuilder<List<Map<String, dynamic>>?>(
                                          future: loginController.getQaHistory(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return const Text('Error loading QA history');
                                            } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                                              return Column(
                                                children: snapshot.data!.map((faq) {
                                                  return CustomExpansionTile(
                                                    title: faq['question'],
                                                    data: [faq['answer']],
                                                    borderRadius: BorderRadius.circular(10),
                                                    isScrollable: true,
                                                  );
                                                }).toList(),
                                              );
                                            } else {
                                              return Column(
                                                children: faqData.map((faq) {
                                                  return CustomExpansionTile(
                                                    title: faq['question'],
                                                    data: [faq['answer']],
                                                    borderRadius: BorderRadius.circular(10),
                                                    isScrollable: true,
                                                  );
                                                }).toList(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (_response != null) // Display the response
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: cardBgColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: resJson.map((res) {
                                        return ChatCard(data: res);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 80), // Add padding to the bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading) // Show loading indicator
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.all(15.0),
                height: 61,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50, // Fixed height for the TextField
                                child: TextField(
                                  controller: _textController,
                                  style: TextStyle(color: Colors.black),
                                  maxLines: null, // Allow multi-line input
                                  decoration: InputDecoration(
                                    hintText: "Ask your doubts...",
                                    hintStyle: TextStyle(color: CSAccentColor),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            if (_isTextEmpty) ...[
                              IconButton(
                                icon: Icon(Icons.photo_camera, color: CSAccentColor),
                                onPressed: _openCamera,
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file, color: CSAccentColor),
                                onPressed: _openFileExplorer,
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                          color: CSAccentColor, shape: BoxShape.circle),
                      child: InkWell(
                        child: Icon(
                          _isTextEmpty ? (_isListening ? Icons.stop : Icons.keyboard_voice) : Icons.send,
                          color: Colors.white,
                        ),
                        onLongPress: () {},
                        onTap: () {
                          if (_isTextEmpty) {
                            if (_isListening) {
                              _stopListening();
                            } else {
                              setState(() {
                                _isListening = true;
                                _countdown = 5; // Reset countdown
                              });
                              _askQuestionByVoice();
                            }
                          } else {
                            _askQuestion();
                          }
                        }, // Call _askQuestion when the button is tapped
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}