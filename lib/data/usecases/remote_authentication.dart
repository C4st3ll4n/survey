import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
	final HttpClient httpClient;
	final String url;
	
	RemoteAuthentication({@required this.httpClient, @required this.url});
	
	Future<void> auth(AuthenticationParams authenticationParams) async {
		//final Map body = {'email':authenticationParams.email, 'password':authenticationParams.secret};
		await httpClient.request(url: url, method: 'post', body:authenticationParams.toJson());
	}
}
