import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:proyectomov2023/models/equipo_model.dart';
import 'package:proyectomov2023/models/laboratorios_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Data {
  static final nameDB = 'Data';
  static final versionDB = 3;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  FutureOr<void> _createTables(Database db, int version) async {
    // Crear la tabla tblTareas
    await db.execute('''
    CREATE TABLE Laboratorios (
    ID_Laboratorio INTEGER PRIMARY KEY,
    Nombre VARCHAR(100)
    )
    ''');
    await db.execute('''
    CREATE TABLE Equipo (
    ID_Equipo INTEGER PRIMARY KEY,
    Nombre VARCHAR(100),
    Marca VARCHAR(100),
    RAM INTEGER,
    Fuente_Poder VARCHAR(100),
    Procesador VARCHAR(100),
    Estatus VARCHAR(50),
    ID_Disco INTEGER,
    ID_Comentario INTEGER,
    ID_Software INTEGER,
    ID_Laboratorio INTEGER,
    FOREIGN KEY (ID_Disco) REFERENCES Disco(ID_Disco),
    FOREIGN KEY (ID_Comentario) REFERENCES Comentario(ID_Comentario),
    FOREIGN KEY (ID_Software) REFERENCES Software(ID_Software),
    FOREIGN KEY (ID_Laboratorio) REFERENCES Laboratorios(ID_Laboratorio)
    )
    ''');
    await db.execute('''
    CREATE TABLE Comentario (
    ID_Comentario INTEGER PRIMARY KEY,
    Comentario VARCHAR(500),
    Responsable VARCHAR(100),
    ID_Fecha INTEGER,
    FOREIGN KEY (ID_Fecha) REFERENCES Fecha(ID_Fecha)
    )
    ''');
    await db.execute('''
    CREATE TABLE Fecha (
    ID_Fecha INTEGER PRIMARY KEY,
    Dia INTEGER,
    Mes INTEGER,
    Año INTEGER,
    Hora VARCHAR(10)
    )
    ''');
    await db.execute('''
    CREATE TABLE Software (
    ID_Software INTEGER PRIMARY KEY,
    Nombre VARCHAR(100),
    Clase VARCHAR(100),
    ID_SO INTEGER,
    FOREIGN KEY (ID_SO) REFERENCES Sistema_Operativo(ID_SO)
    )
    ''');
    await db.execute('''
    CREATE TABLE Sistema_Operativo (
    ID_SO INTEGER PRIMARY KEY,
    Nombre VARCHAR(100),
    Versión VARCHAR(50)
    )
    ''');
    await db.execute('''
    CREATE TABLE Proyector (
    ID_Proyector INTEGER PRIMARY KEY,
    Marca VARCHAR(100),
    Modelo VARCHAR(50)
    )
    ''');
    await db.execute('''
    CREATE TABLE Disco (
    ID_Disco INTEGER PRIMARY KEY,
    Marca VARCHAR(100),
    Capacidad INTEGER,
    Tipo VARCHAR(50)
    )
    ''');
    await db.execute('''
    CREATE TABLE Monitor (
    ID_Monitor INTEGER PRIMARY KEY,
    Modelo VARCHAR(100),
    Marca VARCHAR(100)
    )
    ''');
    await db.execute('''
    CREATE TABLE Equipo_Monitor (
    ID_Monitor INTEGER,
    ID_Equipo INTEGER,
    ID_Proyector INTEGER,
    Nombre VARCHAR(100),
    PRIMARY KEY (ID_Monitor, ID_Equipo),
    FOREIGN KEY (ID_Monitor) REFERENCES Monitor(ID_Monitor),
    FOREIGN KEY (ID_Equipo) REFERENCES Equipo(ID_Equipo)
    FOREIGN KEY (ID_Proyector) REFERENCES Proyector(ID_Proyector)
    )
    ''');
  }

  //CRUD tblTareas
  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: 'idTarea = ?', whereArgs: [data['idTarea']]);
  }

  Future<int> DELETE(String tblName, int idTarea) async {
    var conexion = await database;
    return conexion!
        .delete(tblName, where: 'idTarea = ?', whereArgs: [idTarea]);
  }

  Future<List<LaboratorioModel>> GETALLLABS() async {
    var conexion = await database;
    var result = await conexion!.query('tblTareas');
    return result.map((task) => LaboratorioModel.fromMap(task)).toList();
  }

  Future<List<EquipoModel>> SELECTEQUIPOS(id) async {
    var conexion = await database;
    var result = await conexion!
        .query('Equipo', where: 'ID_Laboratorio = ?', whereArgs: [id]);
    return result.map((map) => EquipoModel.fromMap(map)).toList();
  }

  //SELECT * FROM tblCarrera

  /*/Future<List<CareerModel>> GETALLCARRERAS() async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera');
    return result.map((carrera) => CareerModel.fromMap(carrera)).toList();
  }

  //SELECT * FROM tblProfesor

  Future<List<ProfessorModel>> GETALLPROFESORES() async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor');
    return result.map((profe) => ProfessorModel.fromMap(profe)).toList();
  }

  //SELECT * FROM tblTask

  Future<List<TaskModel>> GETALLTASKS() async {
    var conexion = await database;
    var result = await conexion!.query('tblTask');
    return result.map((tasks) => TaskModel.fromMap(tasks)).toList();
  }*/

  //UPDATE & DELETE GENERAL
  Future<int> UPDATE4(String tblName, Map<String, dynamic> data,
      String whereCampo, int id) async {
    var conexion = await database;
    return conexion!
        .update(tblName, data, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<bool> _hasTaskForProfe(int idProfe) async {
    var conexion = await database;
    var result = await conexion!
        .query('tblTask', where: 'idProfessor = ?', whereArgs: [idProfe]);
    return result.isNotEmpty;
  }

  Future<bool> _hasProfeForCarrera(int idCareer) async {
    var conexion = await database;
    var result = await conexion!
        .query('tblProfesor', where: 'idCareer = ?', whereArgs: [idCareer]);
    return result.isNotEmpty;
  }

  Future<int> DELETE4(String tblName, String whereCampo, int id) async {
    var conexion = await database;
    switch (tblName) {
      case 'tblCarrera':
        bool hasProfessors = await _hasProfeForCarrera(id);
        if (hasProfessors) {
          return 0;
        } else {
          return conexion!
              .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblProfesor':
        bool hasProfessors = await _hasTaskForProfe(id);
        if (hasProfessors) {
          return 0;
        } else {
          return conexion!
              .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblTask':
        return conexion!
            .delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
    }
    return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<List<LaboratorioModel>> searchLab(
      String searchTerm, int? selectedTaskStatus) async {
    var conexion = await database;
    String whereClause = 'Nombre LIKE ?';
    List<dynamic> whereArgs = ['%$searchTerm%'];

    if (selectedTaskStatus != null) {
      whereClause += ' AND realizada = ?';
      whereArgs.add(selectedTaskStatus);
    }
    var result = await conexion!
        .query('Laboratorios', where: whereClause, whereArgs: whereArgs);
    return result.map((task) => LaboratorioModel.fromMap(task)).toList();
  }

  /*
  Future<List<CareerModel>> searchCarreras(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera',
        where: 'nameCareer LIKE ?', whereArgs: ['%$searchTerm%']);
    return result.map((carrera) => CareerModel.fromMap(carrera)).toList();
  }

  Future<List<ProfessorModel>> searchProfesores(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor',
        where: 'nameProfessor LIKE ?', whereArgs: ['%$searchTerm%']);
    return result.map((profe) => ProfessorModel.fromMap(profe)).toList();
  }
  
  Future<List<TaskModel>> getTareasRecordatorio(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask',
        where: 'DATE(fecRecordatorio) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getTareasExpiracion(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask',
        where: 'DATE(fecExpiracion) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }*/

  static searchTasks(String searchTerm, int? selectedTaskStatus) {}
}
