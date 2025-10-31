// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:project_manager/core/entities/status.dart';
// import 'package:project_manager/core/utils/project_utils.dart';
// import 'package:project_manager/core/widget/action_button.dart';

// class ModernProjectCard extends StatelessWidget {
//   final dynamic project;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback? onTap;

//   const ModernProjectCard({
//     super.key,
//     required this.project,
//     required this.onEdit,
//     required this.onDelete,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = ProjectUtils.statusColor(project.status);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
//           BoxShadow(color: const Color(0xFF000000).withOpacity(0.02), blurRadius: 1, offset: const Offset(0, 1)),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: onTap != null ? () {
//             HapticFeedback.lightImpact();
//             onTap!();
//           } : null,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(width: 12, height: 12, decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]), shape: BoxShape.circle)),
//                     const SizedBox(width: 16),
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(colors: [color.withOpacity(0.1), color.withOpacity(0.05)]),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: color.withOpacity(0.2)),
//                       ),
//                       child: Icon(ProjectUtils.statusIcon(project.status), size: 24, color: color),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(child: Text(project.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)), overflow: TextOverflow.ellipsis)),
//                               const SizedBox(width: 12),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]), borderRadius: BorderRadius.circular(12)),
//                                 child: Text(ProjectUtils.statusText(project.status), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           project.description.isNotEmpty
//                               ? Text(project.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis)
//                               : const Text('Không có mô tả', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6B7280)),
//                           const SizedBox(width: 8),
//                           Text(ProjectUtils.formatDateRange(project.timestamp.startDate, project.timestamp.endDate), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         ModernActionButton(icon: Icons.edit_rounded, color: const Color(0xFF3B82F6), onTap: onEdit),
//                         const SizedBox(width: 8),
//                         ModernActionButton(icon: Icons.delete_rounded, color: const Color(0xFFEF4444), onTap: onDelete),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }