import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/transaksi_history_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false).getAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, value, child) {
          if (value.allTransactions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Sort transactions by date in descending order
          value.allTransactions.sort((a, b) {
            DateTime dateA = a['created_at'].toDate();
            DateTime dateB = b['created_at'].toDate();
            return dateB.compareTo(dateA); // Sort in descending order
          });

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: value.allTransactions.length,
              itemBuilder: (context, index) {
                var transaction = value.allTransactions[index];
                var doctorId = transaction['doctor_id'];
                DateTime createdAt = transaction['created_at'].toDate();
                String formattedDate = DateFormat('dd MMM yyyy').format(createdAt);

                // Show divider if it's the first transaction or the date is different from the previous transaction
                bool showDivider = index == 0 ||
                    DateFormat('dd MMM yyyy').format(value.allTransactions[index - 1]['created_at'].toDate()) != formattedDate;

                return Column(
                  children: [
                    if (showDivider)
                      CustomDivider(text: formattedDate),
                    FutureBuilder(
                      future: doctorProvider.getDoctor(doctorId),
                      builder: (context, snapshot) {
                        var doctorData = snapshot.data;
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
          );
        },
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final String text;

  const CustomDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
