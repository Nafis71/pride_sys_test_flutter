import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

extension FavouriteQueries on AppDatabase {
  Future<void> addFavourites({required int id}) async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      await database.insert(favouriteTable, {
        "id": id,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      logger.i("Added $id to favourite list");
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<void> removeFavourites({required int id}) async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      await database.delete(favouriteTable, where: "id = ?", whereArgs: [id]);
      logger.i("Removed $id from favourites");
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<List<int>> getFavoriteIds() async {
    try {
      final Database? database = this.database;
      if (database == null) return [];

      final List<Map<String, dynamic>> result = await database.query(
        favouriteTable,
      );

      return result.map((favourite) => favourite['id'] as int).toList();
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }

  Future<bool> isFavourite({required int id}) async {
    try {
      final Database? database = this.database;
      if (database == null) return false;

      final List<Map<String, dynamic>> result = await database.query(
        favouriteTable,
        where: "id = ?",
        whereArgs: [id],
      );

      return result.isNotEmpty;
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return false;
  }
}
