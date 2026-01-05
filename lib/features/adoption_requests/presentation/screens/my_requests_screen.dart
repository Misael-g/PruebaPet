// lib/features/adoption_requests/presentation/screens/my_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adoption_requests_provider.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdoptionRequestsProvider>().loadMyRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      body: Consumer<AdoptionRequestsProvider>(
        builder: (context, prov, _) {
          if (prov.status == RequestsStatus.loading) return const Center(child: CircularProgressIndicator());
          if (prov.requests.isEmpty) return const Center(child: Text('No tienes solicitudes'));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: prov.requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = prov.requests[index];
              Color badgeColor = Colors.grey;
              String label = r.estado;
              if (r.estado == 'pendiente') { badgeColor = Colors.orange; label = 'Pendiente'; }
              else if (r.estado == 'aprobada') { badgeColor = Colors.green; label = 'Aprobada'; }
              else if (r.estado == 'rechazada') { badgeColor = Colors.red; label = 'Rechazada'; }

              return ListTile(
                title: Text('Solicitud para ${r.mascotaId}'),
                subtitle: Text('Estado: $label'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(label, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold)),
                ),
                onTap: () {
                  // Abrir detalle de solicitud (pendiente implementación)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detalle de solicitud (pendiente)')));
                },
              );
            },
          );
        },
      ),
    );
  }
}