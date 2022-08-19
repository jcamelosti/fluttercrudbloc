import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _db;

  DatabaseProvider._init();

  // retorna uma instancia do banco de dados
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase('notes.db');
    return _db!;
  }

  Future<Database> _useDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    // Descomentar as duas linhas abaixo para apagar a base de dados toda vez
    // que o app iniciar

    // String path = join(dbPath, 'notes.db');
    // await deleteDatabase(path);

    // Retorna o banco de dados aberto
    return await openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT)');
      },
      version: 2,
    );
  }

  // buscar notas
  Future<List<Note>> buscarNotas() async {
    final db = await instance.db;
    final result = await db.rawQuery('SELECT * FROM notes ORDER BY id');
    // print(result);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  //criar nova nota
  Future<Note> save(Note note) async {
    final db = await instance.db;
    final id = await db.rawInsert(
        'INSERT INTO notes (title, content) VALUES (?,?)',
        [note.title, note.content]);

    // print('Nota de id $id criada com sucesso.');
    return note.copy(id: id);
  }

  //atualizar nota
  Future<Note> update(Note note) async {
    final db = await instance.db;
    await db.rawUpdate('UPDATE notes SET title = ?, content = ? WHERE id = ?',
        [note.title, note.content, note.id]);

    // print('Nota de id ${note.id} atualizada com sucesso.');
    return note;
  }

  //excluir notas
  Future<int> deleteAll() async {
    final db = await instance.db;
    final result = await db.rawDelete('DELETE FROM notes');
    // o result é a quantidade de linhas excluídas
    // print('${result} notas excluídas com sucesso.');
    return result;
  }

  //excluir nota
  Future<int> delete(int noteId) async {
    final db = await instance.db;
    final result =
    await db.rawDelete('DELETE FROM notes WHERE id = ?', [noteId]);
    // print('Nota de id ${noteId} excluída com sucesso.');
    // o result é a quantidade de linhas excluídas
    return result;
  }

  //fechar conexao com o banco de dados, funcao nao usada nesse app
  Future close() async {
    final db = await instance.db;
    db.close();
  }
}