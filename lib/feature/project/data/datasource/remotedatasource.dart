import 'package:project_manager/core/network/project/apiclient.dart';
import 'package:project_manager/feature/project/data/models/projectmodel.dart';

class RemoteDataSource {
  final Apiclient apiclient;
  RemoteDataSource(this.apiclient);


  Future<List<ProjectModel>> getAllProject() async {
    final data = await this.apiclient.get('/project') as List<dynamic>;
    return data.map((e) => ProjectModel.fromJson(e as Map<String,dynamic>,e['id'] as int)).toList();
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    final data = await this.apiclient.post('/project', project.toJson());
    return ProjectModel.fromJson(data as Map<String, dynamic>,data['id'] as int);
  }

  Future<ProjectModel> updateProject(ProjectModel project) async {
    final data = await this.apiclient.post('/project/${project.id}', project.toJson());
    return ProjectModel.fromJson(data as Map<String, dynamic>,data['id'] as int); 
  }

  Future<void> deleteProject(String id){
    return this.apiclient.delete('/project/$id');
  }
}