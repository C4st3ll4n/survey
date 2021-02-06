import 'dart:developer';

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
    try {
      final response = await cacheStorage.fetch("surveys");
      if (response?.isEmpty != false) {
        throw Exception("Cache data is invalid or null");
      }
      return _mapToEntity(response);
    } catch (e, stck) {
      log("load::\n\n"+e.toString(), stackTrace: stck);
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch("surveys");
      _mapToEntity(data);
    } catch (e, stck) {
      log("validate::\n\n"+e.toString(), stackTrace: stck);
      await cacheStorage.delete("surveys");
    }
  }

  List<SurveyEntity> _mapToEntity(dynamic data) => data
      .map<SurveyEntity>(
        (e) => LocalSurveyModel.fromJson(e).toEntity(),
      )
      .toList();

  List<Map> _mapToJson(List<SurveyEntity> data) => data
      .map(
        (e) => LocalSurveyModel.fromEntity(e).toJson(),
      )
      .toList();

  Future<void> save(List<SurveyEntity> surveys) async {
    try{
      await cacheStorage.save(
        key: "surveys",
        value: _mapToJson(surveys),
      );
    } catch (e, stck) {
      log("validate::\n\n"+e.toString(), stackTrace: stck);
      throw DomainError.unexpected;
    }
  }
}
