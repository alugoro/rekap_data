import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_mobile/tampildata.dart';

class Inputan extends StatefulWidget {
  Inputan({Key? key}) : super(key: key);

  @override
  State<Inputan> createState() => _InputanState();
}

class _InputanState extends State<Inputan> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController nim = TextEditingController();
  TextEditingController kelas = TextEditingController();
  TextEditingController jurusan = TextEditingController();

  Future<bool> _simpan() async {
    final response = await http.post(
      Uri.parse('https://farrelputra.000webhostapp.com/APIsaveData.php'),
      body: {
        "nama": nama.text,
        "nim": nim.text,
        "kelas": kelas.text,
        "jurusan": jurusan.text,
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
        backgroundColor: Color.fromARGB(255, 77, 161, 230),
      ),
      body: Form(
        key: formkey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: nama,
                decoration: InputDecoration(
                  hintText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nama Tidak Boleh Kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nim,
                decoration: InputDecoration(
                  hintText: "NIM",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "NIM Tidak Boleh Kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: kelas,
                decoration: InputDecoration(
                  hintText: "Kelas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kelas Tidak Boleh Kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: jurusan,
                decoration: InputDecoration(
                  hintText: "Jurusan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Jurusan Tidak Boleh Kosong!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _simpan().then((value) {
                      if (value) {
                        _showSnackBar('Data Berhasil Disimpan!');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Datamhs()),
                          (route) => false,
                        );
                      } else {
                        _showSnackBar('Data Gagal Disimpan!');
                      }
                    });
                  }
                },
                child: Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
