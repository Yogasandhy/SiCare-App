import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/doctor_card.dart';

import '../../providers/doctorProvider.dart';

class DoctorCategoryScreen extends StatefulWidget {
  const DoctorCategoryScreen({super.key, required this.category});
  final String category;

  @override
  State<DoctorCategoryScreen> createState() => _DoctorCategoryScreenState();
}

class _DoctorCategoryScreenState extends State<DoctorCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _listDoctors = [];
  List<Map<String, dynamic>> _searchResults = [];

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      print(value);
      final results = _listDoctors
          .where((doctor) => doctor['nama'].toLowerCase().contains(value))
          .toList();
      setState(() {
        _isSearching = true;
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {},
                onChanged: _onSearchChanged,
                leading: const Icon(Icons.search),
                hintText: 'Cari Dokter',
                controller: _searchController,
              ),
              SizedBox(height: 20.0),
              if (_isSearching) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DoctorCard(
                          doctorId: _searchResults[index]['id'],
                          doctorData: _searchResults[index],
                          availableDates: _searchResults[index]
                              ['available_dates'],
                        ),
                      );
                    },
                  ),
                )
              ] else ...[
                Expanded(
                  child: FutureBuilder(
                    future:
                        doctorProvider.getDoctorsByPosition(widget.category),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final doctorsData =
                              snapshot.data as List<Map<String, dynamic>>;
                          _listDoctors = doctorsData;
                          return doctorsData.isNotEmpty
                              ? ListView.builder(
                                  itemCount: doctorsData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: DoctorCard(
                                        doctorId: doctorsData[index]['id'],
                                        doctorData: doctorsData[index],
                                        availableDates: doctorsData[index]
                                            ['available_dates'],
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('Tidak ada dokter'),
                                );
                        }
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ));
  }
}
