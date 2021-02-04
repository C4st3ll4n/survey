import 'package:meta/meta.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try{
    final response = await cacheStorage.fetch("surveys");
      if(response?.isEmpty!=false){
        throw Exception("Cache data is invalid or null");
      }
      return response
          .map<SurveyEntity>(
              (e) =>LocalSurveyModel.fromJson(e).toEntity()
      )
          .toList();
    }catch(e){
      throw DomainError.unexpected;
    }
    
  }

  Future<void> validate() async{
    try{
    final data = await cacheStorage.fetch("surveys");
    data
        .map<SurveyEntity>(
            (e) =>LocalSurveyModel.fromJson(e).toEntity()
    )
        .toList();
    }catch(e){
      await cacheStorage.delete("surveys");
    }
  }
  
  
  
  
}
