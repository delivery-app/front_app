import 'package:dio/dio.dart';
import '../helpers/http.dart' as http_helper;

/// Access and interacts with the user-referrer API
class ProductsApi {
  Dio dio = new Dio();

  getAllProducts() async {
    String getProductsUri = 'http://${http_helper.main_url}/products';

    return await dio.get(getProductsUri).then((products) {
      return products.data['data'];
    }).catchError((prodErr) {
      print('${prodErr.response.statusCode}, ${prodErr.response.data}');
      return prodErr;
    });
  }
}
