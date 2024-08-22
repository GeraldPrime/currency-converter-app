// import 'package:currency_converter_app/home_screen.dart';
// import 'package:currency_converter_app/screens/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../service/auth.dart';
// import 'forgot_password.dart';
//
// class LogIn extends StatefulWidget {
//   const LogIn({super.key});
//
//   @override
//   State<LogIn> createState() => _LogInState();
// }
//
// class _LogInState extends State<LogIn> {
//   String email = "", password = "";
//   bool _isLoading = false;
//
//   TextEditingController mailcontroller = new TextEditingController();
//   TextEditingController passwordcontroller = new TextEditingController();
//
//   final _formkey = GlobalKey<FormState>();
//
//   userLogin() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator
//     });
//
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.orangeAccent,
//           content: Text(
//             "No User Found for that Email",
//             style: TextStyle(fontSize: 18.0),
//           ),
//         ));
//       } else if (e.code == 'wrong-password') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.orangeAccent,
//           content: Text(
//             "Wrong Password Provided by User",
//             style: TextStyle(fontSize: 18.0),
//           ),
//         ));
//       }
//     } finally {
//       setState(() {
//         _isLoading = false; // Hide loading indicator
//       });
//     }
//   }
//
//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator
//     });
//
//     try {
//       await AuthMethods().signInWithGoogle(context);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } catch (e) {
//       // Handle the error if needed
//     } finally {
//       setState(() {
//         _isLoading = false; // Hide loading indicator
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       extendBodyBehindAppBar: true,
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: Image.asset(
//                   "assets/images/car.PNG",
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(
//                 height: 30.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Form(
//                   key: _formkey,
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFedf0f8),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please Enter E-mail';
//                             }
//                             return null;
//                           },
//                           controller: mailcontroller,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Email",
//                             hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30.0,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
//                         decoration: BoxDecoration(
//                           color: Color(0xFFedf0f8),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: TextFormField(
//                           controller: passwordcontroller,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please Enter Password';
//                             }
//                             return null;
//                           },
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Password",
//                             hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
//                           ),
//                           obscureText: true,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30.0,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (_formkey.currentState!.validate()) {
//                             setState(() {
//                               email = mailcontroller.text;
//                               password = passwordcontroller.text;
//                             });
//                             userLogin();
//                           }
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF273671),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Sign In",
//                               style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
//                 },
//                 child: Text("Forgot Password?",
//                     style: TextStyle(color: Color(0xFF8c8e98), fontSize: 18.0, fontWeight: FontWeight.w500)),
//               ),
//               SizedBox(
//                 height: 40.0,
//               ),
//               Text(
//                 "or LogIn with Google",
//                 style: TextStyle(color: Color(0xFF273671), fontSize: 22.0, fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 height: 30.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: _signInWithGoogle,
//                     child: Image.asset(
//                       "assets/images/google.png",
//                       height: 45,
//                       width: 45,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30.0,
//                   ),
//
//                 ],
//               ),
//               SizedBox(
//                 height: 40.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Don't have an account?",
//                       style: TextStyle(color: Color(0xFF8c8e98), fontSize: 18.0, fontWeight: FontWeight.w500)),
//                   SizedBox(
//                     width: 5.0,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
//                     },
//                     child: Text(
//                       "SignUp",
//                       style: TextStyle(color: Color(0xFF273671), fontSize: 20.0, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           if (_isLoading)
//             Center(
//               child: Container(
//                 // color: Colors.black54,
//                 child: CircularProgressIndicator(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';
import '../service/auth.dart';
import 'signup.dart';
import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  bool _isLoading = false;

  final mailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // User can dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> userLogin() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No User Found for that Email";
          break;
        case 'wrong-password':
          errorMessage = "Wrong Password Provided by User";
          break;
        default:
          errorMessage = "An unexpected error occurred.";
          break;
      }

      await _showErrorDialog(errorMessage);
    } catch (e) {
      await _showErrorDialog("An unexpected error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await AuthMethods().signInWithGoogle(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      await _showErrorDialog("Google sign-in failed: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/car.PNG",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter E-mail';
                            }
                            return null;
                          },
                          controller: mailcontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            userLogin();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF273671),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFF8c8e98), fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 40.0),
              Text(
                "or LogIn with Google",
                style: TextStyle(color: Color(0xFF273671), fontSize: 22.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _signInWithGoogle,
                    child: Image.asset(
                      "assets/images/google.png",
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 30.0),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Color(0xFF8c8e98), fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Color(0xFF273671), fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}

