

import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: _screenSize.width / 10),
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, // Change from max to min
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align to start for wrapping
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commissioned by ABC Finance Ltd.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                softWrap: true, // Ensure text wraps
                              ),
                              SizedBox(height: 10),
                              Text(
                                'globally recognized financial institution known for its commitment to innovation and customer-centric services',
                                style: TextStyle(color: Colors.white),
                                softWrap: true, // Ensure text wraps
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Made by aptech students, Enugu',
                                style: TextStyle(color: Colors.white),
                                softWrap: true, // Ensure text wraps
                              ),
                              SizedBox(height: 20),

                            ],
                          ),
                        ),
                        // Uncomment and adjust as needed
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         'Legal',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 22,
                        //         ),
                        //         softWrap: true,
                        //       ),
                        //       SizedBox(height: 15),
                        //       Text(
                        //         'Terms & Conditions',
                        //         style: TextStyle(color: Colors.white),
                        //         softWrap: true,
                        //       ),
                        //       SizedBox(height: 5),
                        //       Text(
                        //         'Privacy',
                        //         style: TextStyle(color: Colors.white),
                        //         softWrap: true,
                        //       ),
                        //       SizedBox(height: 5),
                        //       Text(
                        //         'Info Source',
                        //         style: TextStyle(color: Colors.white),
                        //         softWrap: true,
                        //       ),
                        //       SizedBox(height: 5),
                        //       Text(
                        //         'Froud Prevention',
                        //         style: TextStyle(color: Colors.white),
                        //         softWrap: true,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
