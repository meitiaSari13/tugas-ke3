import 'package:fluter_apk/model/user_model.dart';
import 'package:flutter/material.dart';
import '../repositories/firestore_repository.dart';

class EditUserScreen extends StatefulWidget {
  final User user;
  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100], // Warna background pink soft
      appBar: AppBar(
        title: Text('Edit Pengguna'),
        backgroundColor: Colors.pink, // Warna AppBar pink
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5, // Menambahkan efek bayangan pada card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Warna putih untuk kontras dengan background pink
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, color: Colors.pink),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: Colors.pink),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      if (name.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nama dan email tidak boleh kosong')),
                        );
                        return;
                      }
                      try {
                        await _firestoreRepository.updateUser(widget.user.id, {
                          'name': name,
                          'email': email,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data berhasil diperbarui!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal memperbarui data: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // Warna tombol pink
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
