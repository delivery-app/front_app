import '../helpers/http.dart' as http_helper;
import '../helpers/http_request.dart';

/// Access and interacts with the user-referrer API
class ProductsApi {
  var request = new HttpRequest();

  getAllProducts() async {
    String getProductsUri = 'http://${http_helper.main_url}/products';

    return await request.getRequest(getProductsUri);
  }
}
