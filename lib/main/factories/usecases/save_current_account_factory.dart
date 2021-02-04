import '../factories.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() =>
    LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageSecureAdapter());
