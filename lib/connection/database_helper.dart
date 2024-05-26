import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final String _host = 'srv1402.hstgr.io'; // Hostinger database host
  static final int _port = 3306; // MySQL default port
  static final String _databaseName = 'u646358860_aquac';
  static final String _user = 'u646358860_aquac';
  static final String _password = '7Ul7I552Pq=';

  static Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _databaseName,
    );

    return await MySqlConnection.connect(settings);
  }
}