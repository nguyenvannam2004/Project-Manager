import 'package:flutter/material.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';

class Stage{
  final int id;
  final String name;
  final int projectId;
  final String description;
  final Status status;
  final TimeStamp timestamps;

  Stage(this.id, this.name, this.projectId, this.description, this.status, this.timestamps);
 
}