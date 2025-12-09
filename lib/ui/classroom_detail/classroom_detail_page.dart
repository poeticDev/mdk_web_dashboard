import 'package:flutter/material.dart';

class ClassroomDetailPage extends StatelessWidget {
  const ClassroomDetailPage({
    required this.roomId,
    super.key,
  });

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('강의실 상세 - $roomId'),
      ),
      body: Center(
        child: Text('강의실 상세 데이터를 구성하세요. (ID: $roomId)'),
      ),
    );
  }
}
