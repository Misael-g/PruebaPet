// lib/features/adoption_requests/presentation/screens/request_detail_screen.dart

import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;
  const RequestDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de solicitud')),
      body: Center(child: Text('Detalle de la solicitud $requestId (pendiente)')),
    );
  }
}