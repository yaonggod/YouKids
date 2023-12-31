import 'dart:convert';
import 'package:dio/dio.dart';

class PostingServices {
  static String baseUrl = 'https://j9a604.p.ssafy.io/api';

  static Future<void> postingCapsuleImgsContents({
    required String description,
    required String location,
    required dynamic userId,
    required List<String>? fileList,
    List<List<int>>? childrenList,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/capsule/upload';

    List<MultipartFile> files = [];
    if (fileList != null) {
      for (String filePath in fileList) {
        MultipartFile file = await MultipartFile.fromFile(filePath);
        files.add(file);
      }
    }
    final formData = FormData.fromMap({
      "fileList": files,
      "request": jsonEncode({
        "description": description,
        "childrenList": childrenList,
        "location": location,
        "userId": userId,
      }),
    });

    final response = await dio.post(
      url,
      data: formData,
    );

    if (response.statusCode == 200) {
      return;
    }
    throw Error();
  }
}
