import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/history_filter_row.dart';
import '../../components/transaksi_history_card.dart';
import '../../components/custom_divider.dart';
import '../../providers/historyProvider.dart';
import '../../providers/doctorProvider.dart';
import 'package:intl/intl.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<HistoryProvider>(context, listen: false)
          .getAllTransactions();
      Provider.of<HistoryProvider>(context, listen: false)
          .filterAllTransactions('Aktif');
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: Column(
        children: [
          const HistoryFilterRow(
            isAdmin: true,
          ),
          Consumer<HistoryProvider>(
            builder: (context, value, child) {
              if (value.allTransactionsFiltered.isEmpty) {
                return Expanded(
                  child: Center(child: Text('No transactions found')),
                );
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<HistoryProvider>(context, listen: false)
                        .refreshTransactions();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: value.allTransactionsFiltered.length,
                      itemBuilder: (context, index) {
                        var transaction = value.allTransactionsFiltered[index];
                        var doctorId = transaction['doctor_id'];
                        DateTime createdAt = transaction['created_at'].toDate();
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(createdAt);

                        // Show divider if it's the first transaction or the date is different from the previous transaction
                        bool showDivider = index == 0 ||
                            DateFormat('dd MMM yyyy').format(
                                  value.allTransactionsFiltered[index - 1]
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
                                    isAdmin: true,
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
