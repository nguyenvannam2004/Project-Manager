import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';

class Apiclient {
  static List<Task> task = [];

  Apiclient(){
    if(task.isNotEmpty) return;
    task = [
      Task(01,01,  'NguyenVanA' , 'loptruong' ,Status.completed , 01, TimeStamp(  DateTime.now(),DateTime.now(),DateTime.now(),DateTime.now())),
      Task(02,02,  'NguyenVanB' , 'loppho' ,Status.inProgress , 02, TimeStamp(  DateTime.now(),DateTime.now(),DateTime.now(),DateTime.now())),
      Task(03,03,  'NguyenVanC' , 'sinhvien' ,Status.pending , 03, TimeStamp(  DateTime.now(),DateTime.now(),DateTime.now(),DateTime.now())),
    ];
  }



  Future<dynamic> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/tasks') {
       return task
          .map((p) => {
                'id': p.id,
                'stagedId': p.stagedId,
                'name': p.name,
                'description': p.description,
                'status': p.status,
                'createBy': p.createBy,
                'timeStamp': p.timeStamp,
              })
          .toList();
    }
    throw Exception('Unknown path: $path');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async { 
 await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/tasks') {
      final newTask = Task(
        body['id'],
        body['stagedId'],
        body['name'],
        body['description'],
        body['status'],
        body['createBy'],
        body['timeStamp'],
      );
      task.add(newTask);
      return {
        'id': newTask.id,
        'stagedId': newTask.stagedId,
        'name': newTask.name,
        'description': newTask.description,
        'status': newTask.status,
        'createBy': newTask.createBy,
        'timeStamp': newTask.timeStamp,
      };
    }
    throw Exception('Unknown POST path: $path');

   }

  Future<dynamic> put(String path, Map<String, dynamic> body) async { 
     await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/tasks/')) {
      final idStr = path.split('/').last;
      final id = int.tryParse(idStr);
      if (id == null) throw Exception('Invalid id in path');
      final index = task.indexWhere((p) => p.id == id);
      if (index == -1) throw Exception('Task not found');

      final updated = Task(
        body['id'],
        body['stagedId'],
        body['name'],
        body['description'],
        body['status'],
        body['createBy'],
        body['timeStamp'],
      );
      task[index] = updated;
      return {
        'id': updated.id,
        'stagedId': updated.stagedId,
        'name': updated.name,
        'description': updated.description,
        'status': updated.status,
        'createBy': updated.createBy,
        'timeStamp': updated.timeStamp,
      };
    }
    throw Exception('Unknown PUT path: $path');
  }

  Future<void> delete(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/tasks/')) {
      final idStr = path.split('/').last;
      final id = int.tryParse(idStr);
      if (id == null) throw Exception('Invalid id in path');
      task.removeWhere((p) => p.id == id);
      return;
    }
    throw Exception('Unknown DELETE path: $path');
   }

}