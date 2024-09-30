import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poc_pdf/prepare_pdf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Permission _permission = Permission.storage;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PoC PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !kIsWeb
                ? Text(
                    "${_permission.toString()} : ${_permissionStatus.toString()}")
                : Container(),
            !kIsWeb ? const SizedBox(height: 8) : Container(),
            !kIsWeb
                ? FilledButton(
                    onPressed: _requestPermission,
                    child: const Text("Solicitar permissão de armazenamento"),
                  )
                : Container(),
            const SizedBox(height: 8),
            const FilledButton(
              onPressed: preparePdf,
              child: Text("Criar PDF"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _listenForPermissionStatus();
    }
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;

    setState(() => _permissionStatus = status);
  }

  Future<void> _requestPermission() async {
    final status = await _permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }
}
