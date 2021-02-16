import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  HttpAdapter(this.client);

  final Client client;

  @override
  Future<dynamic> request(
      {@required String url,
      @required String method,
      Map body,
      Map headers}) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    var jsonBody = body != null ? jsonEncode(body) : null;
    Response response = Response('', 500);
    try {
      if (method == 'post') {
        response = await client
            .post(
              url,
              headers: defaultHeaders,
              body: jsonBody,
            )
            .timeout(
              Duration(seconds: 10),
            );
      } else if (method == "get") {
        response = await client
            .get(
              url,
              headers: defaultHeaders,
            )
            .timeout(
              Duration(seconds: 10),
            );
      } else if (method == "put") {
        response =
            await client.put(url, headers: defaultHeaders, body: jsonBody);
      }
    } catch (e, stck) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isNotEmpty ? json.decode(response.body) : null;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}
