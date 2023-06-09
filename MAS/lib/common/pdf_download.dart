import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> fromAsset(String asset, String filename) async {
    await requestStoragePermission();
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      log("File Name $file");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      log('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      log('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      log('Permission Permanently Denied');
      await openAppSettings();
    }
  }