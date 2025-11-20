import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관제 대시보드')),
      body: const Center(child: Text('대시보드 콘텐츠를 여기에 구성하세요.')),
    );
  }
}
