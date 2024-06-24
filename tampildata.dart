import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_mobile/inputan.dart';
import 'package:uas_mobile/edit.dart';

class Datamhs extends StatefulWidget {
  Datamhs({Key? key}) : super(key: key);

  @override
  State<Datamhs> createState() => _DatamhsState();
}

class _DatamhsState extends State<Datamhs> {
  List _listdata = [];
  bool _isloading = true;

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse('https://farrelputra.000webhostapp.com/APIreadData.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _hapus(String nim) async {
    try {
      final response = await http.post(
        Uri.parse('https://farrelputra.000webhostapp.com/APIhapusData.php'),
        body: {
          "nim": nim,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _showDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_listdata[index]['nama']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('NIM: ${_listdata[index]['nim']}'),
              Text('Kelas: ${_listdata[index]['kelas']}'),
              Text('Jurusan: ${_listdata[index]['jurusan']}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Konfirmasi'),
                            content: Text('Apakah Anda yakin ingin menghapus data?'),
                            actions: [
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  _hapus(_listdata[index]['nim']).then((_) {
                                    setState(() {
                                      _listdata.removeAt(index);
                                    });
                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Edit(ListData: {
                            "nama": _listdata[index]['nama'],
                            "nim": _listdata[index]['nim'],
                            "kelas": _listdata[index]['kelas'],
                            "jurusan": _listdata[index]['jurusan'],
                          }),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
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

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Mahasiswa"),
        backgroundColor: Color.fromARGB(255, 77, 161, 230),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_listdata[index]['nama']),
                    subtitle: Text(_listdata[index]['nim']),
                    onTap: () {
                      _showDetails(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "+",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Inputan()),
          );
        },
      ),
    );
  }
}
