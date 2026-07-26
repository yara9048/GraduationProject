import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/Images/Ellipse 4.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/Images/Ellipse 7.png'),
          ),
          Positioned(
            top: 55,
            right: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    textDirection: TextDirection.rtl,
                    color: Color(0xff2A9D8F),
                    size: 30,
                  ),
                  SizedBox(width: 20,),

                  Text("سجل الدفع",style: TextStyle(fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",fontSize: 28),),


                ],
              ),
            ),
          ),
        ],
      )

    );
  }
}
