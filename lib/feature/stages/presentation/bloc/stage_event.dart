import 'package:flutter/widgets.dart';
import 'package:project_manager/core/entities/status.dart';

abstract class StageEvent {}

class LoadStageEvent extends StageEvent {}

class CreateStageEvent extends StageEvent {
  final int id;
  final String name;
  final int projectId;
  final Text description;  // ← Đổi từ String sang Text
  final DateTime startDate;
  final DateTime endDate;
  final Status status;  // ← Đổi từ String sang Status
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateStageEvent({
    required this.id,
    required this.name,
    required this.projectId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

class UpdateStageEvent extends StageEvent {
  final int id;
  final String name;
  final int projectId;
  final Text description;  // ← Đổi từ String sang Text
  final DateTime startDate;
  final DateTime endDate;
  final Status status;  // ← Đổi từ String sang Status
  final DateTime createdAt;
  final DateTime updatedAt;

  UpdateStageEvent({
    required this.id,
    required this.name,
    required this.projectId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

class DeleteStageEvent extends StageEvent {
  final int id;

  DeleteStageEvent({required this.id});
}