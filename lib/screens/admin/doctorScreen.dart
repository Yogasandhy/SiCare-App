import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/components/custom_appbar.dart';
import 'package:sicare_app/components/doctor_card.dart';
import '../../providers/doctorProvider.dart';
import 'add_doctor_screen.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _refreshData(BuildContext context) async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    await doctorProvider.refreshDoctors();
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      setState(() {
        _isSearching = true;
      });
      final doctorProvider =
          Provider.of<DoctorProvider>(context, listen: false);
      doctorProvider.searchDoctorsByName(value).then((results) {
        setState(() {
          _searchResults = results;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dokter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDoctorScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 40),
                      backgroundColor: const Color(0xff0E82FD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Tambah Dokter',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 20.0),
            if (_isSearching) ...[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final doctorData = _searchResults[index]['doctor'];
                      final availableDates =
                          _searchResults[index]['available_dates'];

                      return DoctorCard(
                        doctorId: doctorData['id'],
                        doctorData: doctorData,
                        availableDates: availableDates,
                        isAdmin: true,
                      );
                    },
                  ),
                ),
              )
            ] else ...[
              Consumer<DoctorProvider>(
                builder: (context, provider, child) {
                  return Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: provider.getAllDoctorsWithAvailableDates(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final doctors = snapshot.data!;

                        return RefreshIndicator(
                          onRefresh: () => _refreshData(context),
                          child: ListView.builder(
                            itemCount: doctors.length,
                            itemBuilder: (context, index) {
                              final doctorData = doctors[index];
                              final doctorId = doctorData['id'];
                              final availableDates =
                                  doctorData['available_dates'];
                              return DoctorCard(
                                doctorId: doctorId,
                                doctorData: doctorData,
                                availableDates: availableDates,
                                isAdmin: true,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
