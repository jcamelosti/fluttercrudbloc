import 'package:crudblocsqlite/models/client.dart';
import 'package:crudblocsqlite/utils/db/base_dao.dart';

// Data Access Object
class ClientDAO extends BaseDAO<Client> {

  @override
  String get tableName => "clients";

  @override
  Client fromMap(Map<String, dynamic> map) {
    return Client.fromMap(map);
  }

  //GET ALL CLIENTES
  Future<List<Client>> getClients() async {
    final result = await query('SELECT * FROM $tableName ORDER BY id');
    return result;
  }
}
