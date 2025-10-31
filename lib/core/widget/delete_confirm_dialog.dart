import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(
  BuildContext context, {
  required String itemName,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(  // Đổi tên biến
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text('Xác nhận xóa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bạn có chắc chắn muốn xóa "$itemName"?'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Expanded(child: Text('Hành động này không thể hoàn tác', style: TextStyle(color: Color(0xFF991B1B))))
            ]),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),  // Dùng dialogContext
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(dialogContext).pop(true),   // Dùng dialogContext
          icon: const Icon(Icons.delete_rounded),
          label: const Text('Xóa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    ),
  );
}