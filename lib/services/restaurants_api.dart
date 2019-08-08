import '../helpers/http.dart' as http_helper;
import '../helpers/http_request.dart';

/// Access and interacts with the user-referrer API
class RestaurantsApi {
  var request = new HttpRequest();

  getAllRestaurants() async {
    String getRestaurantsUri = 'http://${http_helper.main_url}/restaurants';

    return await request.getRequest(getRestaurantsUri);
  }

  getRestaurantProducts(int restaurantId) async {
    String getRestProductsUri = 'http://${http_helper.main_url}/restaurants/'
        '$restaurantId/products';

    return await request.getRequest(getRestProductsUri);
  }
}
