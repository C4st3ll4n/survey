import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/add_account.dart';
import '../factories.dart';

AddAccount makeAddAccount() =>
    RemoteAddAccount(httpClient: makeHttpAdapter(), url: makeAPIUrl("signup"));
