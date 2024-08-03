// import 'package:sqflite/sqflite.dart';
// import 'package:toolbox/services/database_service.dart';

// import 'base_database_helper.dart';

// const String TABLE_POSTS = 'posts';

// class PostFields {
//   static final List<String> values = [id, caption, imageUrl, createdAt];

//   static const String id = '_id';
//   static const String caption = 'caption';
//   static const String imageUrl = 'imageUrl';
//   static const String createdAt = 'createdAt';
// }

// class PostService {
//   final DatabaseService _dbService = DatabaseService();
//   Future<Database?> get database => _dbService.database;

//   static const String createTableQuery = '''
//     CREATE TABLE $TABLE_POSTS (
//       ${PostFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
//       ${PostFields.caption} TEXT NOT NULL,
//       ${PostFields.imageUrl} TEXT NOT NULL,
//       ${PostFields.createdAt} TEXT NOT NULL
//     )
//   ''';

//   Future<int> insertPost(Map<String, dynamic> post) async {
//     final db = await _dbService.database;
//     return await db.insert(TABLE_POSTS, post);
//   }

//   Future<List<Map<String, dynamic>>> getPosts() async {
//     final db = await _dbService.database;
//     return await db.query(TABLE_POSTS);
//   }

//   Future<int> updatePost(int id, Map<String, dynamic> post) async {
//     final db = await _dbService.database;
//     return await db.update(
//       TABLE_POSTS,
//       post,
//       where: '${PostFields.id} = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<int> deletePost(int id) async {
//     final db = await database;
//     return await db.delete(
//       TABLE_POSTS,
//       where: '${PostFields.id} = ?',
//       whereArgs: [id],
//     );
//   }
// }
