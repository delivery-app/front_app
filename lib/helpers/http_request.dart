import 'package:dio/dio.dart';

class HttpRequest {
  Dio dio = new Dio();

  getRequest(String requestUrl) async {
    return await dio.get(requestUrl).then((response) {
      return response.data['data'];
    }).catchError((err) {
      print('${err.response.statusCode}, ${err.response.data}');
      return err;
    });
  }
}
