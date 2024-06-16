import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/historyProvider.dart';

class HistoryFilterRow extends StatelessWidget {
  const HistoryFilterRow({
    super.key,
    this.isAdmin = false,
  });
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shape: LinearBorder.bottom(
                    side: BorderSide(
                      color: value.selectedHistory == 'Aktif'
                          ? Color(0xff0E82FD)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  value.changeHistory('Aktif');
                  isAdmin
                      ? value.filterAllTransactions('Aktif')
                      : value.filterHistory('Aktif');
                },
                child: Text(
                  'Aktif',
                  style: TextStyle(
                    color: value.selectedHistory == 'Aktif'
                        ? Color(0xff0E82FD)
                        : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shape: LinearBorder.bottom(
                    side: BorderSide(
                      color: value.selectedHistory == 'Selesai'
                          ? Color(0xff0E82FD)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  value.changeHistory('Selesai');
                  isAdmin
                      ? value.filterAllTransactions('Selesai')
                      : value.filterHistory('Selesai');
                },
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    color: value.selectedHistory == 'Selesai'
                        ? Color(0xff0E82FD)
                        : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shape: LinearBorder.bottom(
                    side: BorderSide(
                      color: value.selectedHistory == 'Dibatalkan'
                          ? Color(0xff0E82FD)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {
                  value.changeHistory('Dibatalkan');
                  isAdmin
                      ? value.filterAllTransactions('Dibatalkan')
                      : value.filterHistory('Dibatalkan');
                },
                child: Text(
                  'Dibatalkan',
                  style: TextStyle(
                    color: value.selectedHistory == 'Dibatalkan'
                        ? Color(0xff0E82FD)
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
