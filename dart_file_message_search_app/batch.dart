import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:excel/excel.dart';

List<File> getAllDartFiles(Directory dir) {
  List<File> files = [];
  dir.listSync(recursive: true).forEach((FileSystemEntity entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  });
  return files;
}

void main() {
  Directory directory = Directory(
      '検索するディレクトリのパス');
  List<File> dartFiles = getAllDartFiles(directory);

  String excelFilePath =
      'エクセルのパス';
  var bytes = File(excelFilePath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var sheet = excel['Sheet1']; // シート名に合わせて変更してください

  bool foundMatch = false;

  for (var file in dartFiles) {
    String fileContent = file.readAsStringSync();
    //String fileName = path.basename(file.path);

    for (var row in sheet.rows) {
      if (row.isNotEmpty) {
        String? cellValueNullable = row[0]?.value?.toString(); // A列の値を取得

        if (cellValueNullable != null) {
          String cellValue = cellValueNullable;

          if (fileContent.contains(cellValue)) {
            print('一致が見つかりました！ファイルパス: ${file.path}');
            print('検索対象の文字列: $cellValue');
            foundMatch = true;
          }
        }
      }
    }
  }

  if (!foundMatch) {
    print('一致するファイルが見つかりませんでした。');
  }
}


// dart \batch.dart \pubspec.yaml