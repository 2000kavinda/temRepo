import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;


class QARepository {
  final Uri _urlAskQuestionByText = Uri.parse('${dotenv.env['BE_URL']}${dotenv.env['BE_KAS_ASQ_QUESTION_BY_TEXT_URL']}');
  final Uri _urlAskQuestionByImage = Uri.parse('${dotenv.env['BE_URL']}${dotenv.env['BE_KAS_ASQ_QUESTION_BY_IMAGE_URL']}');
  final Uri _urlAskQuestionByVoice = Uri.parse('${dotenv.env['BE_URL']}${dotenv.env['BE_KAS_ASQ_QUESTION_BY_VOICE_URL']}');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<Map<String, dynamic>> askQuestionByText(String question) async {
    final token = await LoginController.instance.getAccessToken();
    final body = jsonEncode({'question': question});
    final headersWithToken = {
      ..._headers,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(_urlAskQuestionByText, headers: headersWithToken, body: body);
      return _handleResponse(response);
    } catch (error) {
      return {'error': 'Error asking question by text: $error'};
    }
  }

  Future<Map<String, dynamic>> askQuestionByImage(File image) async {
    final token = await LoginController.instance.getAccessToken();
    final imageBytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      return {'error': 'Error decoding image'};
    }

    final base64Image = base64Encode(img.encodePng(decodedImage));
    print('base64,$base64Image');
    final body = jsonEncode({'image': 'base64,$base64Image'});
    final headersWithToken = {
      ..._headers,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(_urlAskQuestionByImage, headers: headersWithToken, body: body);
      print(response);
      return _handleResponse(response);
    } catch (error) {
      return {'error': 'Error asking question by image: $error'};
    }
  }

  Future<Map<String, dynamic>> askQuestionByVoice(File voice) async {
    final token = await LoginController.instance.getAccessToken();
    final headersWithToken = {
      ..._headers,
      'Authorization': 'Bearer $token',
    };

    final request = http.MultipartRequest('POST', _urlAskQuestionByVoice)
      ..headers.addAll(headersWithToken)
      ..files.add(await http.MultipartFile.fromPath('audio', voice.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      return _handleResponse(http.Response(responseBody, response.statusCode));
    } catch (error) {
      return {'error': 'Error asking question by voice: $error'};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    } else {
      return {'error': jsonResponse['error'] ?? 'Unknown error'};
    }
  }
}