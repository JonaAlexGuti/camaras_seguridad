// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Cámaras`
  String get camara {
    return Intl.message(
      'Cámaras',
      name: 'camara',
      desc: '',
      args: [],
    );
  }

  /// `Cámara fuera de línea`
  String get cammen {
    return Intl.message(
      'Cámara fuera de línea',
      name: 'cammen',
      desc: '',
      args: [],
    );
  }

  /// `Agregar Cámara`
  String get addCam {
    return Intl.message(
      'Agregar Cámara',
      name: 'addCam',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa un nombre`
  String get addName {
    return Intl.message(
      'Ingresa un nombre',
      name: 'addName',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get name {
    return Intl.message(
      'Nombre',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Dirección IP de la cámara`
  String get IP {
    return Intl.message(
      'Dirección IP de la cámara',
      name: 'IP',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa una IP`
  String get addIP {
    return Intl.message(
      'Ingresa una IP',
      name: 'addIP',
      desc: '',
      args: [],
    );
  }

  /// `Agregar Cámara`
  String get addButton {
    return Intl.message(
      'Agregar Cámara',
      name: 'addButton',
      desc: '',
      args: [],
    );
  }

  /// `Cámara Registrada`
  String get camOk {
    return Intl.message(
      'Cámara Registrada',
      name: 'camOk',
      desc: '',
      args: [],
    );
  }

  /// `Inserte la información que se pide`
  String get addEmpty {
    return Intl.message(
      'Inserte la información que se pide',
      name: 'addEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Editar Cámara`
  String get editCam {
    return Intl.message(
      'Editar Cámara',
      name: 'editCam',
      desc: '',
      args: [],
    );
  }

  /// `Eliminar Cámara`
  String get delCam {
    return Intl.message(
      'Eliminar Cámara',
      name: 'delCam',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar`
  String get cancelDel {
    return Intl.message(
      'Cancelar',
      name: 'cancelDel',
      desc: '',
      args: [],
    );
  }

  /// `¿Está seguro de eliminar `
  String get askDel {
    return Intl.message(
      '¿Está seguro de eliminar ',
      name: 'askDel',
      desc: '',
      args: [],
    );
  }

  /// `Cámara eliminada`
  String get delOk {
    return Intl.message(
      'Cámara eliminada',
      name: 'delOk',
      desc: '',
      args: [],
    );
  }

  /// `Cámara actualizada`
  String get camUpd {
    return Intl.message(
      'Cámara actualizada',
      name: 'camUpd',
      desc: '',
      args: [],
    );
  }

  /// `Editar Información`
  String get editCamInfo {
    return Intl.message(
      'Editar Información',
      name: 'editCamInfo',
      desc: '',
      args: [],
    );
  }

  /// `Guardar`
  String get saveEditData {
    return Intl.message(
      'Guardar',
      name: 'saveEditData',
      desc: '',
      args: [],
    );
  }

  /// `Imagen Capturada`
  String get SS_Saved {
    return Intl.message(
      'Imagen Capturada',
      name: 'SS_Saved',
      desc: '',
      args: [],
    );
  }

  /// `La imagen no se pudo capturar`
  String get SS_Fail {
    return Intl.message(
      'La imagen no se pudo capturar',
      name: 'SS_Fail',
      desc: '',
      args: [],
    );
  }

  /// `Grabando`
  String get SR_Start {
    return Intl.message(
      'Grabando',
      name: 'SR_Start',
      desc: '',
      args: [],
    );
  }

  /// `Grabación Detenida`
  String get SR_Stop {
    return Intl.message(
      'Grabación Detenida',
      name: 'SR_Stop',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es', countryCode: 'MX'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
