import 'package:survey/data/usecases/add_account/authentication.dart';
import 'package:survey/domain/usecases/add_account.dart';
import 'package:survey/main/factories/factories.dart';

AddAccount makeAddAccount() => RemoteAddAccount(httpClient: makeHttpAdapter(),url: "");