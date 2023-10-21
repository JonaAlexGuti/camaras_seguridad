
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../crudCamaras/listarCamaras.dart';

class HomePage extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const HomePage({Key? key, this.savedThemeMode}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return  Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
          title:  Center(
            child: Text(S.of(context).camara,
                style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.grey)),
          ),
          backgroundColor: Colors.black),
      body:  ListarCamaras()
    );
  }

}