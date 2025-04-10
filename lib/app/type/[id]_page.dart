import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_modelo_20251/main.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:collegeapi/api.dart';
import 'package:dio/dio.dart';

class TypeEditPage extends StatefulWidget {
  const TypeEditPage({super.key});

  /*static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (_) => context.read<AppApi>(),
                dispose: (_, instance) => instance.dispose(),
              )
            ],
            child: const TypeEditPage()
        ));
  }*/

  @override
  State<TypeEditPage> createState() => _TypeEditPageState();
}

class _TypeEditPageState extends State<TypeEditPage> {
  late final String tipoId;
  final TextEditingController _nameController = TextEditingController();

  AppApi? api;
  late CategoryControllerApi? categoryController;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = Routefly.query['id'];
    if (args != null && !(args is String)) {
      tipoId = args.toString();
      // Aqui você pode buscar os dados do type usando o ID
      // Exemplo fictício:
      _nameController.text = 'Tipo $tipoId';
    } else {
      tipoId = 'unknown';
    }
  }

  void _salvar() {
    final nomeEditado = _nameController.text;


    final categoryDTO = CategoryDTO(name: nomeEditado); // CategoryDTO |

    categoryController?.categoryControllerCreate(categoryDTO)
        .then((value) {
          // Salvar as alterações do type usando o tipoId e nomeEditado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Categoria $tipoId salvo como "$nomeEditado"')),
          );
          Navigator.pop(context);
        }).catchError((error) {
          var errorResponse = MessageResponse.fromJson(jsonDecode(error.message));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error "${errorResponse?.message}"')),
          );
        });

  }

  @override
  Widget build(BuildContext context) {
    initApi(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tipo $tipoId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Tipo',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void initApi(BuildContext context) {
    if(this.api == null){
      this.api = context.read<AppApi>();
      this.categoryController = CategoryControllerApi(api?.api);
    }
  }
}
