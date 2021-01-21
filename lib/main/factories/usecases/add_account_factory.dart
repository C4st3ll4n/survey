import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/usecases/add_account.dart';
import 'package:survey/main/factories/factories.dart';

AddAccount makeAddAccount() => RemoteAddAccount(httpClient: makeHttpAdapter(),url: "");