import 'package:flutter/material.dart';

// class VocabTopic {
//   final String name;
//   final String url;
//   final IconData icon;
//   final Color color;
//   final Color bgColor;
//   final int tableIndex; // Thêm trường này

//   VocabTopic({
//     required this.name,
//     required this.url,
//     required this.icon,
//     required this.color,
//     required this.bgColor,
//     required this.tableIndex, // Bắt buộc truyền vào
//   });

//   // Constructor từ JSON (nếu cần lưu vào database)
//   factory VocabTopic.fromJson(Map<String, dynamic> json) {
//     return VocabTopic(
//       name: json['name'] as String,
//       url: json['url'] as String,
//       icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
//       color: Color(json['color'] as int),
//       bgColor: Color(json['bgColor'] as int),
//       tableIndex: json['tableIndex'] as int,
//     );
//   }

//   // Convert sang JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'url': url,
//       'iconCode': icon.codePoint,
//       'color': color.value,
//       'bgColor': bgColor.value,
//       'tableIndex': tableIndex,
//     };
//   }

//   // Copy with method
//   VocabTopic copyWith({
//     String? name,
//     String? url,
//     IconData? icon,
//     Color? color,
//     Color? bgColor,
//     int? tableIndex,
//   }) {
//     return VocabTopic(
//       name: name ?? this.name,
//       url: url ?? this.url,
//       icon: icon ?? this.icon,
//       color: color ?? this.color,
//       bgColor: bgColor ?? this.bgColor,
//       tableIndex: tableIndex ?? this.tableIndex,
//     );
//   }

//   @override
//   String toString() {
//     return 'VocabTopic(name: $name, url: $url, tableIndex: $tableIndex)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is VocabTopic &&
//         other.name == name &&
//         other.url == url &&
//         other.tableIndex == tableIndex;
//   }

//   @override
//   int get hashCode => name.hashCode ^ url.hashCode ^ tableIndex.hashCode;
// }

class VocabTopic {
  final String name;
  final String url;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final int tableIndex;

  VocabTopic({
    required this.name,
    required this.url,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.tableIndex,
  });
}
