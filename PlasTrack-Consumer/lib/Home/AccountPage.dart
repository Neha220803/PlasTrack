import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionData {
  final String? toUser;
  final String? reason;
  final int? amount;
  final Timestamp time_stamp;

  TransactionData({
    required this.toUser,
    required this.reason,
    required this.amount,
    required this.time_stamp,
  });
}

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);

  return '$formattedDate';
}

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');
      

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _transactions.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                child: Text(
                  'Incentives Recieved',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 21.59,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    var transactionData = snapshot.data?.docs[index].data()
                        as Map<String, dynamic>;
                    var transaction = TransactionData(
                      amount: transactionData['amount'],
                      reason: transactionData['reason'],
                      time_stamp: transactionData['time_stamp'],
                      toUser: transactionData['to_user'],
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            transaction.reason ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'Recieved on ${formattedTimestamp(transaction.time_stamp.toDate())}',
                                style: TextStyle(
                                  color: Color(0xFF898989),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            '+₹${transaction.amount}',
                            style: TextStyle(
                              color: Color(0xFF898989),
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
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
