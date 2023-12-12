import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String userId;

  PaymentPage({required this.userId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String userId;
  String selectedPaymentMethod = '';
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cardExpirationController = TextEditingController();
  TextEditingController filePathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // Assign the value in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 190, 210, 253),
        title: Text('Choose Payment Method'),
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
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildPaymentMethodTile('Card Payment', Icons.credit_card),
            buildPaymentMethodTile('Cash on Delivery', Icons.money),
            SizedBox(height: 16),
            if (selectedPaymentMethod == 'Card Payment')
              buildCardPaymentFields(),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 6, 42, 118),
              ),
              onPressed: () {
                // Validate and process the selected payment method
                if (validatePayment()) {
                  // Payment logic based on the selected method
                  processPayment();

                  // Navigate to the Thank You page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                }
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      )),
    );
  }

  bool validatePayment() {
    if (selectedPaymentMethod == 'Card Payment') {
      // Validate card payment fields
      if (cardNumberController.text.isEmpty ||
          cvvController.text.isEmpty ||
          nameController.text.isEmpty ||
          cardExpirationController.text.isEmpty) {
        // Show an error message
        showErrorMessage('Please fill in all card payment fields');
        return false;
      }
    } else if (selectedPaymentMethod == 'Online Transaction') {
      // Validate online transaction file
      if (filePathController.text.isEmpty) {
        // Show an error message
        showErrorMessage('Please pick a file for online transaction');
        return false;
      }
    }
    // No validation issues
    return true;
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void processPayment() async {
    // Process the payment based on the selected method
    print('Processing payment for: $selectedPaymentMethod');
    if (selectedPaymentMethod == 'Card Payment') {
      print('Card Number: ${cardNumberController.text}');
      print('CVV: ${cvvController.text}');
      print('Name: ${nameController.text}');
      print('Card Expiration: ${cardExpirationController.text}');
    } else if (selectedPaymentMethod == 'PayPal') {
      // Implement PayPal payment logic
      print('Processing PayPal payment...');
    } else if (selectedPaymentMethod == 'Online Transaction') {
      // Implement online transaction payment logic
      print('Uploading file: ${filePathController.text}');
    }

    String? getCurrentUserId() {
      User? user = FirebaseAuth.instance.currentUser;
      return user?.uid;
    }

    // Get the current user ID (replace this with your actual user ID retrieval logic)
    String? userId = getCurrentUserId();

    // Fetch user details from Firestore
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      // Retrieve user-specific details
      DocumentSnapshot shippingDetailsSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('shippingDetails')
          .doc('user_shipping_details')
          .get();

      if (shippingDetailsSnapshot.exists) {
        // Retrieve shipping details
        String city = shippingDetailsSnapshot['city'];
        String contactName = shippingDetailsSnapshot['contactName'];
        String house = shippingDetailsSnapshot['house'];
        String phoneNumber = shippingDetailsSnapshot['phoneNumber'];
        String street = shippingDetailsSnapshot['street'];
        String zip = shippingDetailsSnapshot['zip'];

        await FirebaseFirestore.instance.collection('orders').doc(userId).set({
          'userId': userId,
          'shippingDetails': {
            'city': city,
            'contactName': contactName,
            'house': house,
            'phoneNumber': phoneNumber,
            'street': street,
            'zip': zip,
          },
        });

        // Fetch cart items from Firestore
        QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .get();

        if (cartSnapshot.docs.isNotEmpty) {
          // Process each cart item as an order
          for (DocumentSnapshot cartItem in cartSnapshot.docs) {
            String productName = cartItem['name'];
            String productImg = cartItem['imageUrl'];
            int quantity = cartItem['quantity'];
            String paymentMethod = selectedPaymentMethod;

            Future<String> uploadFile() async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                // Get the file
                PlatformFile file = result.files.first;

                // Create a reference to Firebase Storage
                Reference storageReference =
                    FirebaseStorage.instance.ref().child('files/${file.name}');

                // Upload the file
                UploadTask uploadTask = storageReference.putData(file.bytes!);

                // Get the download URL
                String fileUrl = await (await uploadTask).ref.getDownloadURL();

                return fileUrl;
              } else {
                return ''; // Return an empty string if no file is selected
              }
            }

            // Check if it's an online transaction
            if (selectedPaymentMethod == 'Online Transaction') {
              // Upload file to Firebase Storage
              String fileUrl = await uploadFile();

              // Save order details to Firestore
              await FirebaseFirestore.instance
                  .collection('orders')
                  .doc(userId)
                  .collection('products')
                  .add({
                'status': 'pending',
                'productImg': productImg,
                'productName': productName,
                'quantity': quantity,
                'paymentMethod': paymentMethod,
                'fileUrl': fileUrl, // Save the download URL in the database
                // Add other details as needed
              });
            } else {
              // Save order details to Firestore for non-online transaction
              await FirebaseFirestore.instance
                  .collection('orders')
                  .doc(userId)
                  .collection('products')
                  .add({
                'status': 'pending',
                'productImg': productImg,
                'productName': productName,
                'quantity': quantity,
                'paymentMethod': paymentMethod,
                // Add other details as needed
              });
            }
          }

          // Clear the cart after processing orders
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        } else {
          print('No items in the cart');
        }
      } else {
        print('Shipping details not found');
      }
    } else {
      print('User details not found');
    }
  }

  Widget buildPaymentMethodTile(String title, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedPaymentMethod == title
            ? Colors.blue // Set the button color when selected
            : Colors.grey, // Set the button color when not selected
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  Widget buildCardPaymentFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: cardNumberController,
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: cvvController,
          decoration: InputDecoration(labelText: 'CVV'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Cardholder Name'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: cardExpirationController,
          decoration: InputDecoration(labelText: 'Card Expiration'),
        ),
      ],
    );
  }

  Widget buildPayPalSignInButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement PayPal sign-in logic
        print('Signing in to PayPal...');
      },
      child: Text('Sign In to PayPal'),
    );
  }

  Widget buildFileUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            // Open the file picker
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            // Check if a file was selected
            if (result != null) {
              setState(() {
                // Update the file path controller with the selected file path
                filePathController.text = result.files.single.path!;
              });
            }
          },
          child: Text('Pick a File'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: filePathController,
          decoration: InputDecoration(labelText: 'Selected File'),
          readOnly: true, // Make the text field read-only
        ),
        SizedBox(height: 16),
        // ElevatedButton(
        //   onPressed: () {
        //     // Implement file upload logic
        //     print('Uploading file: ${filePathController.text}');
        //   },
        //   child: Text('Upload File'),
        // ),
      ],
    );
  }
}
