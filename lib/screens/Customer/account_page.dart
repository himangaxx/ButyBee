import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:admin/screens/Customer/shipping_details.dart';
import 'package:admin/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String userId; // Declare userId at the class level

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    // String? userId = getCurrentUserId();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 190, 210, 253),
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShippingDetailsPage(
                        userId: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 94, 157),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShippingDetailsPage(
                        userId: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 94, 157),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Edit Shipping Address',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 94, 157),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            // SizedBox(
            //   width: double.maxFinite,
            //   height: 150,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle orders action
            //       // Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Color.fromARGB(255, 6, 94, 157),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //     ),
            //     child: Text(
            //       'Orders',
            //       style: TextStyle(fontSize: 20, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 6, 42, 118),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to home
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.assignment_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to orders
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to account
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}
