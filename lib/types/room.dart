import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RoomEntity {
  /// The generated code assumes these values exist in JSON.
  final String id;
  final List<String> messageIndexes;
  final String name;
  final String roomPreview;
  final DateTime updatedAt;
  final int unreadCount;
  RoomEntity(
      {required this.id,
      required this.messageIndexes,
      required this.name,
      required this.roomPreview,
      required this.updatedAt,
      required this.unreadCount});
}
