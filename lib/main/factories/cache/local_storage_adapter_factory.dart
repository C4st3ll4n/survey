import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../infra/cache/cache.dart';

LocalStorageSecureAdapter makeLocalStorageSecureAdapter() => LocalStorageSecureAdapter(secureStorage: FlutterSecureStorage());