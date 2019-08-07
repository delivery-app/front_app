import 'package:dio/dio.dart';
import '../helpers/http.dart' as http_helper;

/// Access and interacts with the user-referrer API
class RestaurantsApi {
  Dio dio = new Dio();

  getAllRestaurants() async {
    String getRestaurantsUri = 'http://${http_helper.main_url}/restaurants';

    return await dio.get(getRestaurantsUri).then((restaurants) {
      return restaurants.data['data'];
    }).catchError((restErr) {
      print('${restErr.response.statusCode}, ${restErr.response.data}');
      return restErr;
    });
  }

  getRestaurantProducts(int restaurantId) async {
    String getRestProductsUri = 'http://${http_helper.main_url}/restaurants/'
        '$restaurantId/products';

    return await dio.get(getRestProductsUri).then((restProducts) {
      return restProducts.data['data'];
    }).catchError((restProductErr) {
      print('${restProductErr.response.statusCode}, '
          '${restProductErr.response.data}');
      return restProductErr;
    });
  }
}
