import 'package:flutter/material.dart';
import 'package:project_management/core/entities/status.dart';
import 'package:project_management/core/entities/timestamps.dart';

class Stage{
  final int id;
  final String name;
  final int projectId;
  final Text description;
  final Status status;
  final Timestamps timestamps;

  Stage(this.id, this.name, this.projectId, this.description, this.status, this.timestamps);
  

 

 
}