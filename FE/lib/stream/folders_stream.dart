import 'dart:async';
import 'package:wordwizzard/services/folder.dart';

class FoldersStream {
  dynamic foldersData;
  dynamic folderDetailData;
  static final FoldersStream _instance = FoldersStream._internal();
  factory FoldersStream() => _instance;

  FoldersStream._internal() {
    foldersController = StreamController<dynamic>.broadcast(sync: true);
    folderDetailsController = StreamController<dynamic>.broadcast(sync: true);
  }

  late StreamController<dynamic> foldersController;
  Stream get foldersStream => foldersController.stream;
  late StreamController<dynamic> folderDetailsController;
  Stream get folderDetailsStream => folderDetailsController.stream;

  void getFoldersData() {
    handleGetAllFolders(1, "", 10).then((val) {
      if (val["code"] == 0) {
        foldersData = val["data"];
        foldersController.sink.add(foldersData);
      }else if(val["code"] == -1) {
        foldersController.sink.addError(val["code"]);
      }
    });
  }

  void getFolderDetailsData(String folderId){
    handleGetFolderDetails(folderId).then((val) {
      if (val["code"] == 0) {
        foldersData = val["data"];
        folderDetailsController.sink.add(foldersData);
      } else if (val["code"] == -1) {
        folderDetailsController.sink.addError(val["code"]);
      }
    });
  }

  void dispose() {
    foldersController.close();
  }
}
