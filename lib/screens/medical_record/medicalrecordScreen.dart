import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sicare_app/providers/historyProvider.dart';
import '../../components/history_filter_row.dart';
import '../../components/transaksi_history_card.dart';
import '../../components/custom_divider.dart';
import '../../providers/doctorProvider.dart';
import 'package:intl/intl.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false)
          .filterHistory('Aktif');
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/mainlogobiru.png', fit: BoxFit.cover),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // row for selecting aktif, selesai, dan dibatalkan
          HistoryFilterRow(),
          // listview for medical record
          Consumer<HistoryProvider>(
            builder: (context, value, child) {
              if (value.userFilteredHistory.isEmpty) {
                return Center(child: Text('No transactions found'));
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<HistoryProvider>(context, listen: false)
                        .refreshUserHistory();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: value.userFilteredHistory.length,
                      itemBuilder: (context, index) {
                        var transaction = value.userFilteredHistory[index];
                        var doctorId = transaction['doctor_id'];
                        DateTime createdAt = transaction['created_at'].toDate();
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(createdAt);

                        // Show divider if it's the first transaction or the date is different from the previous transaction
                        bool showDivider = index == 0 ||
                            DateFormat('dd MMM yyyy').format(
                                  value.userFilteredHistory[index - 1]
                                          ['created_at']
                                      .toDate(),
                                ) !=
                                formattedDate;

                        return Column(
                          children: [
                            if (showDivider) CustomDivider(text: formattedDate),
                            FutureBuilder(
                              future: doctorProvider.getDoctor(doctorId),
                              builder: (context, snapshot) {
                                var doctorData = snapshot.data;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: TransaksiHistoryCard(
                                    data: {
                                      'doctor_data': doctorData,
                                      'history_data': transaction,
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
