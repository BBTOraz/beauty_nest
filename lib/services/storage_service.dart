import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {
  Future<String> uploadPhoto(File file, String path);
  Future<String> getPhotoUrl(String path);
}

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadPhoto(File file, String path) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
    await uploadTask;
    return await ref.getDownloadURL();
  }

  @override
  Future<String> getPhotoUrl(String path) async {
    return await _storage.ref().child(path).getDownloadURL();
  }
}
