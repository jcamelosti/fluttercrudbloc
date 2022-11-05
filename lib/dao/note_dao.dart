import 'package:crudblocsqlite/models/note.dart';
import 'package:crudblocsqlite/utils/db/base_dao.dart';

// Data Access Object
class NoteDAO extends BaseDAO<Note> {

  @override
  String get tableName => "notes";

  @override
  Note fromMap(Map<String, dynamic> map) {
    return Note.fromMap(map);
  }

  // buscar notas
  Future<List<Note>> buscarNotas() async {
    final result = await query('SELECT * FROM $tableName ORDER BY id');
    // print(result);
    return result;
  }
}
