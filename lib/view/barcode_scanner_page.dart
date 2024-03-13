import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  BarcodeScannerPageState createState() => BarcodeScannerPageState();
}

class BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final List _barcode = [];

  void exibirAlertaContagem() {
    var contagem = contarItens();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Número de itens scaneados:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              contagem.isNotEmpty
                  ? Column(
                      children: contagem.entries
                          .map((entry) => Text("${entry.value}x ${entry.key}"))
                          .toList(),
                    )
                  : const Text('Nenhum código registrado'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      _barcode.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      _barcode.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, int> contarItens() {
    var contador = <String, int>{};
    for (var barcode in _barcode) {
      contador[barcode] = (contador[barcode] ?? 0) + 1;
    }
    print(_barcode);
    print(contador);

    return contador;
  }

  Future<void> scanBarcode() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
      "#ff6666",
      "Concluir",
      false,
      ScanMode.BARCODE,
    )!
        .listen(
      (barcode) {
        if (barcode.toString() != '-1') {
          print(barcode.toString());
          _barcode.add(barcode.toString());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner de Código de Barras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                scanBarcode();
              },
              child: const Text('Escanear Código de Barras'),
            ),
            ElevatedButton(
              onPressed: () {
                exibirAlertaContagem();
              },
              child: const Text('Salvar Códigos Contados'),
            ),
          ],
        ),
      ),
    );
  }
}
