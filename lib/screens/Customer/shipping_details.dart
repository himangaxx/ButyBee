import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:admin/screens/Customer/payment_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippingDetailsPage extends StatefulWidget {
  final String userId;

  ShippingDetailsPage({required this.userId});

  @override
  _ShippingDetailsPageState createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch existing shipping details if they exist
    fetchExistingShippingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 190, 210, 253),
        title: Text('Shipping Details'),
        actions: [
          // Add the IconButton for the cart
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Contact Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: houseController,
                decoration: InputDecoration(labelText: 'House/apt'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Street (Optional)'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: zipController,
                decoration: InputDecoration(labelText: 'Zip Number'),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.maxFinite,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 6, 42, 118),
                  ),
                  onPressed: () {
                    // Save or update shipping details to Firestore
                    saveOrUpdateShippingDetails();
                    // You can also implement payment processing logic here
                  },
                  child: Text('Save and Proceed to Pay'),
                ),
              ),
            ],
          ),
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

  void fetchExistingShippingDetails() async {
    try {
      // Fetch existing shipping details from Firestore
      DocumentSnapshot shippingDetailsDocument = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.userId)
          .collection('shippingDetails')
          .doc('user_shipping_details') // Assuming a single document for user
          .get();

      if (shippingDetailsDocument.exists) {
        // Update text controllers with existing values
        Map<String, dynamic> data =
            shippingDetailsDocument.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['contactName'];
          phoneNumberController.text = data['phoneNumber'];
          houseController.text = data['house'];
          streetController.text = data['street'];
          cityController.text = data['city'];
          zipController.text = data['zip'];
        });
      }
    } catch (error) {
      print('Error fetching existing shipping details: $error');
    }
  }

  void saveOrUpdateShippingDetails() async {
    // Check if shipping details document already exists
    DocumentReference shippingDetailsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('shippingDetails')
        .doc('user_shipping_details');

    // bool shippingDetailsExist = (await shippingDetailsRef.get()).exists;

    // Save or update shipping details to Firestore
    await shippingDetailsRef.set({
      'contactName': nameController.text,
      'phoneNumber': phoneNumberController.text,
      'house': houseController.text,
      'street': streetController.text,
      'city': cityController.text,
      'zip': zipController.text,
    });

    // Navigate back to the cart or another page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(userId: widget.userId!),
      ),
    );
  }
}
