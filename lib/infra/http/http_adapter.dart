import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  HttpAdapter(this.client);

  final Client client;

  @override
  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    var jsonBody = body!=null?jsonEncode(body):null;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return (response?.body == null || response.body.isEmpty)? null :jsonDecode(response.body);
  }
}
