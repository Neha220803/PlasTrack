// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plas_track2/Utils/constants.dart';
import 'package:plas_track2/Widgets/custom_text.dart';
import 'package:plas_track2/Widgets/custome_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  final TextEditingController _amountController =
      TextEditingController(text: '0.00');
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');

  String _selectedUser = '';

  static const menuItems = <String>[
    'Neeharika S',
    'Anaya Singh',
    'Isha Darshini',
  ];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String? _btn2SelectedVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Container(
                  height: 40,
                  width: 350,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: black, width: 2.0),
                    ),
                  ),
                  child: CustomText(
                    value: 'Enter Recycling Bonus',
                    color: grey[900],
                    size: 21.59,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 60),
                DropdownButton(
                  value: _btn2SelectedVal,
                  hint: const Text('Choose a User'),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _btn2SelectedVal = newValue);
                      _selectedUser = newValue;
                    }
                  },
                  items: _dropDownMenuItems,
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 300.39,
                  height: 148.44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF002D56),
                    borderRadius: BorderRadius.circular(31.62),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          value: 'Enter Credit Amount',
                          color: white,
                          size: 21.84,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: white,
                            fontSize: 23,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  text: "View Payment Options",
                  callback: () {
                    int amount =
                        (double.parse(_amountController.text) * 100).toInt();
                    Razorpay razorpay = Razorpay();
                    var options = {
                      'key': 'rzp_test_1DP5mmOlF5G5ag',
                      'amount': amount,
                      'name': 'Neeharika S',
                      'description': 'Plastrack: Cultivating Change',
                      'retry': {'enabled': true, 'max_count': 1},
                      'send_sms_hash': true,
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'test@razorpay.com'
                      },
                      'external': {
                        'wallets': ['paytm']
                      }
                    };
                    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                        handlePaymentErrorResponse);
                    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                        handlePaymentSuccessResponse);
                    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                        handleExternalWalletSelected);
                    razorpay.open(options);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    try {
      int amount = (double.parse(_amountController.text)).toInt();
      await _transactions.add({
        'upi_transaction_id': response.paymentId,
        'amount': amount, // Replace with the actual amount
        'time_stamp': FieldValue.serverTimestamp(),
        'to_user': _selectedUser,
        'reason': 'Recycling Bonus'
      });

      // Show success dialog
      showAlertDialog(
          context, "Payment Successful", "Payment ID: ${response.paymentId}");
    } catch (e) {
      print('Error adding transaction to Firestore: $e');
      // Show error dialog
      showAlertDialog(
          context, "Error", "Failed to update transaction in database.");
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
