// lib/features/adoption_requests/presentation/screens/request_form_screen.dart

import 'package:flutter/material.dart';

class RequestAdoptionScreen extends StatefulWidget {
  final String petId;
  const RequestAdoptionScreen({super.key, required this.petId});

  @override
  State<RequestAdoptionScreen> createState() => _RequestAdoptionScreenState();
}

class _RequestAdoptionScreenState extends State<RequestAdoptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _experienciaController = TextEditingController();
  final TextEditingController _razonController = TextEditingController();
  bool _tieneOtrasMascotas = false;
  bool _tienePatio = false;
  int _personasHogar = 1;
  bool _hayNinos = false;

  @override
  void dispose() {
    _experienciaController.dispose();
    _razonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Para la primera iteración, solo mostrar snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud enviada (simulada)')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario de adopción')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _experienciaController,
                decoration: const InputDecoration(labelText: 'Experiencia con mascotas'),
                validator: (v) => v == null || v.isEmpty ? 'Completa este campo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _razonController,
                decoration: const InputDecoration(labelText: 'Razón para adoptar'),
                validator: (v) => v == null || v.isEmpty ? 'Completa este campo' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('¿Tiene otras mascotas?'),
                value: _tieneOtrasMascotas,
                onChanged: (v) => setState(() => _tieneOtrasMascotas = v),
              ),
              SwitchListTile(
                title: const Text('¿Tiene patio?'),
                value: _tienePatio,
                onChanged: (v) => setState(() => _tienePatio = v),
              ),
              ListTile(
                title: const Text('Personas en el hogar'),
                trailing: DropdownButton<int>(
                  value: _personasHogar,
                  items: List.generate(6, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
                  onChanged: (v) => setState(() => _personasHogar = v ?? 1),
                ),
              ),
              SwitchListTile(
                title: const Text('¿Hay niños en el hogar?'),
                value: _hayNinos,
                onChanged: (v) => setState(() => _hayNinos = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _submit, child: const Text('Enviar solicitud')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}