import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final _locationController = TextEditingController();
  final _locationDetailController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedShift;
  String? _selectedPosition;
  String? _selectedExperience;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDoctorData(widget.doctorId);
  }

  Future<void> _loadDoctorData(String doctorId) async {
    final addDoctorProvider =
        Provider.of<AddDoctorProvider>(context, listen: false);
    final doctor = await addDoctorProvider.fetchDoctorById(doctorId);

    print('Doctor data: $doctor'); // Debugging line

    setState(() {
      _nameController.text = doctor['nama'];
      _descriptionController.text = doctor['deskripsi'];
      _alumniController.text = doctor['alumni'];
      _locationController.text = doctor['lokasi'];
      _locationDetailController.text = doctor['lokasiDetail'];
      _priceController.text = NumberFormat("#,##0", "id_ID").format(
          double.parse(
              doctor['price'].replaceAll(',', '').replaceAll('.', '')));
      _selectedShift = doctor['shift'];
      _selectedPosition = doctor['posisi'];
      _selectedExperience = doctor['pengalaman'];
      _imageUrl = doctor['imageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final addDoctorProvider = Provider.of<AddDoctorProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Dokter',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Container(
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
                    child: Stack(
                      children: [
                        if (addDoctorProvider.imageFile != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(addDoctorProvider.imageFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        else if (_imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey[300],
                            ),
                          ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showPicker(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField('Nama Lengkap', _nameController),
                  _buildTextField('Deskripsi', _descriptionController),
                  _buildTextField('Alumni', _alumniController),
                  _buildDropdownField('Posisi', _selectedPosition, [
                    'Umum',
                    'Gigi',
                    'Kardiologi',
                    'Otologi',
                    'Ortopendi',
                    'Neurologi',
                    'Usus',
                  ]),
                  _buildDropdownField('Pengalaman', _selectedExperience, [
                    '5 tahun',
                    '6 tahun',
                    '7 tahun',
                    '8 tahun',
                    '9 tahun',
                    '10 tahun+'
                  ]),
                  _buildTextField('Lokasi', _locationController),
                  _buildTextField('Detail Lokasi', _locationDetailController),
                  _buildTextField('Harga', _priceController,
                      keyboardType: TextInputType.number),
                  _buildDropdownField('Shift', _selectedShift,
                      ['Shift 1', 'Shift 2', 'Shift 3']),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await addDoctorProvider.updateDoctor(
                            id: widget.doctorId,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            alumni: _alumniController.text,
                            position: _selectedPosition!,
                            experience: _selectedExperience!,
                            location: _locationController.text,
                            locationDetail: _locationDetailController.text,
                            price: NumberFormat("#,##0", "id_ID").format(
                                double.parse(_priceController.text
                                    .replaceAll(',', '')
                                    .replaceAll('.', ''))),
                            shift: _selectedShift!,
                          );

                          await addDoctorProvider.updateAvailableDates(
                            doctorId: widget.doctorId,
                            shift: _selectedShift!,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Edit data doctor berhasil')),
                          );

                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Terjadi kesalahan saat mengedit dokter')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0E82FD),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Update Data Dokter',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ));
  }

  Widget _buildDropdownField(
      String labelText, String? selectedValue, List<String> items) {
    bool isValidValue = selectedValue != null && items.contains(selectedValue);

    List<String> dropdownItems = List.from(items);
    if (!isValidValue && selectedValue != null) {
      dropdownItems.add(selectedValue);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Card(
          color: Colors.grey[300],
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              value: isValidValue ? selectedValue : null,
              onChanged: (value) {
                setState(() {
                  if (labelText == 'Posisi') {
                    _selectedPosition = value;
                  } else if (labelText == 'Shift') {
                    _selectedShift = value;
                  } else if (labelText == 'Pengalaman') {
                    _selectedExperience = value;
                  }
                });
              },
              items: dropdownItems
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Silakan pilih ${labelText.toLowerCase()}';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeri'),
                onTap: () {
                  Provider.of<AddDoctorProvider>(context, listen: false)
                      .pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Kamera'),
                onTap: () {
                  Provider.of<AddDoctorProvider>(context, listen: false)
                      .pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
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
                return 'Silakan masukkan ${labelText.toLowerCase()}';
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
