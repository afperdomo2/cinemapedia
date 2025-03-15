import 'package:cinemapedia/data/datasources/isar_datasource.dart';
import 'package:cinemapedia/data/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return LocalStorageRepositoryImpl(IsarDatasource());
});
