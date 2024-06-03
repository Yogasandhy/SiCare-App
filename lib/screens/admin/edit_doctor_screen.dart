import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/AddDoctorProvider.dart';
import 'dart:io';

class EditDoctorScreen extends StatefulWidget {
  final String doctorId;

  const EditDoctorScreen({required this.doctorId, super.key});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _alumniController = TextEditingController();
  final _positionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationDetailController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedShift;

  @override
  void initState() {
    super.initState();
    _loadDoctorData(widget.doctorId);
  }

  Future<void> _loadDoctorData(String doctorId) async {
    final addDoctorProvider = Provider.of<AddDoctorProvider>(context, listen: false);
    final doctor = await addDoctorProvider.fetchDoctorById(doctorId);

    setState(() {
      _nameController.text = doctor['nama'];
      _descriptionController.text = doctor['deskripsi'];
      _alumniController.text = doctor['alumni'];
      _positionController.text = doctor['posisi'];
      _experienceController.text = doctor['pengalaman'];
      _locationController.text = doctor['lokasi'];
      _locationDetailController.text = doctor['lokasiDetail'];
      _priceController.text = doctor['price'].toString();
      _selectedShift = doctor['shift'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final addDoctorProvider = Provider.of<AddDoctorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dokter'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            GestureDetector(
              onTap: () => addDoctorProvider.pickImage(ImageSource.gallery),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: addDoctorProvider.imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(addDoctorProvider.imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.add,
                          size: 100,
                          color: Colors.grey[300],
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Nama Lengkap', _nameController),
            _buildTextField('Deskripsi', _descriptionController),
            _buildTextField('Alumni', _alumniController),
            _buildTextField('Posisi', _positionController),
            _buildTextField('Pengalaman', _experienceController),
            _buildTextField('Lokasi', _locationController),
            _buildTextField('Detail Lokasi', _locationDetailController),
            _buildTextField('Harga', _priceController, keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: _selectedShift,
              onChanged: (value) {
                setState(() {
                  _selectedShift = value;
                });
              },
              items: ['Shift 1', 'Shift 2', 'Shift 3']
                  .map((shift) => DropdownMenuItem(
                        value: shift,
                        child: Text(shift),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Shift',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan pilih shift';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  addDoctorProvider.updateDoctor(
                    id: widget.doctorId,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    alumni: _alumniController.text,
                    position: _positionController.text,
                    experience: _experienceController.text,
                    location: _locationController.text,
                    locationDetail: _locationDetailController.text,
                    price: double.parse(_priceController.text),
                    shift: _selectedShift!,
                  ).then((_) {
                    addDoctorProvider.updateAvailableDates(
                      doctorId: widget.doctorId,
                      shift: _selectedShift!,
                    ).then((_) {
                      Navigator.pop(context);
                    });
                  });
                }
              },
              child: Text('Update Data Dokter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Card(
          color: Colors.grey[300],
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silakan masukkan $labelText.toLowerCase()';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
