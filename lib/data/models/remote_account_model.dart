import '../http/http.dart';
import '../../domain/entities/entities.dart';

const String kAccessToken = "accessToken";

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if(!json.containsKey(kAccessToken)) throw HttpError.invalidData;
    return RemoteAccountModel(json[kAccessToken]);
  }
  
  AccountEntity toEntity() => AccountEntity(this.accessToken);
}
