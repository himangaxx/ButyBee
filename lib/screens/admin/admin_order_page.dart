import 'package:admin/screens/admin/admin_account_page.dart';
import 'package:admin/screens/admin/admin_analytics_page.dart';
import 'package:admin/screens/admin/product_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Shipped'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('pending'),
          _buildOrdersList('confirmed'),
          _buildOrdersList('shipped'),
          _buildOrdersList('completed'),
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
                Icons.analytics_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to home
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsTab(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Navigate to orders
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => product_home(),
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
                // Navigate to cart page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersTab(),
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
                    builder: (context) => const AccountTab(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc()
          .collection('products')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var orders = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            var shippingDetails = order['shippingDetails'];
            var products = order['products'];

            return OrderCard(
              shippingDetails: shippingDetails,
              products: products,
            );
          },
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> shippingDetails;
  final List<dynamic> products;

  const OrderCard({
    Key? key,
    required this.shippingDetails,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Order for: ${shippingDetails['contactName']}'),
            subtitle:
                Text('Contact Number: ${shippingDetails['contactNumber']}'),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, productIndex) {
              var product = products[productIndex];
              return ListTile(
                title: Text(product['productName']),
                subtitle: Text('Quantity: ${product['quantity']}'),
                leading: Image.network(product['productImg']),
              );
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersTab(),
  ));
}
