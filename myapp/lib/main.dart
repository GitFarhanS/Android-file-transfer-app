import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilePickerDemo(),
    );
  }
}

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String? _filePath;
  String? _uploadMessage;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadFile() async {
    if (_filePath == null) {
      setState(() {
        _uploadMessage = "No file selected to upload";
      });
      return;
    }

    // Replace '192.168.x.x' with your computer's IP address
    var uri = Uri.parse('http://90.248.233.183:5000/upload');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _filePath!));

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _uploadMessage = "File uploaded successfully";
      });
    } else {
      setState(() {
        _uploadMessage = "File upload failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _filePath != null ? 'Selected file: $_filePath' : 'No file selected',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick a File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
            SizedBox(height: 20),
            Text(
              _uploadMessage != null ? _uploadMessage! : '',
            ),
          ],
        ),
      ),
    );
  }
}
