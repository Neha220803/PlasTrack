import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plas_track2/Functions/formatted_time.dart';
import 'package:plas_track2/Utils/constants.dart';
import 'package:plas_track2/Widgets/custom_text.dart';

class TransactionData {
  final String? toUser;
  final String? reason;
  final int? amount;
  final Timestamp timeStamp;

  TransactionData({
    required this.toUser,
    required this.reason,
    required this.amount,
    required this.timeStamp,
  });
}

class PastOrders extends StatefulWidget {
  const PastOrders({super.key});

  @override
  State<PastOrders> createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _transactions.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Past Transactions",
                style: TextStyle(color: white),
              ),
              backgroundColor: black,
              iconTheme: const IconThemeData(color: white),
            ),
            body: Column(
              children: [
                // SizedBox(height: 20),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var transactionData = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      var transaction = TransactionData(
                        amount: transactionData['amount'],
                        reason: transactionData['reason'],
                        timeStamp: transactionData['time_stamp'],
                        toUser: transactionData['to_user'],
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          elevation: 4,
                          color: white,
                          child: ListTile(
                            title: CustomText(
                              value: "To ${transaction.toUser ?? ""}",
                              fontWeight: FontWeight.w700,
                              size: 20.0,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                CustomText(
                                  value:
                                      'Transferred on ${formattedTimestamp(transaction.timeStamp.toDate())}',
                                  color: customGrey,
                                  fontWeight: FontWeight.w700,
                                  size: 12.0,
                                ),
                              ],
                            ),
                            trailing: Text(
                              '- ₹${transaction.amount}',
                              style: const TextStyle(
                                color: customGrey,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
