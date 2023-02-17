import 'package:mysql1/mysql1.dart';

class Mysql{
  static String host = '192.168.28.254',
    user = 'test',
    password = 'test2023',
    db = 'final_db';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }

}