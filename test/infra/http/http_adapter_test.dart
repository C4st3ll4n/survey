import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class ClientSpy extends Mock implements Client{

}


class HttpAdapter implements HttpClient {
  HttpAdapter(this.client);
  
	final Client client;

  @override
  Future<Map> request({@required String url, @required  String method, Map body}) async {
    throw UnimplementedError();
  }
	
}

void main(){
	
	group("POST", (){
		test('Should call post with correct values', () async{
			final client = ClientSpy();
			final sut = HttpAdapter(client);
			final url = faker.internet.httpUrl();
			await sut.request(url: url, method: "post");
			
			verify(client.post(url));
			
		});
	});
	
	group("GET", (){
	});
	
}
