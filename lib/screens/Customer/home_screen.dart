import 'package:admin/screens/Customer/account_page.dart';
import 'package:admin/screens/Customer/cart_page.dart';
import 'package:admin/screens/Customer/order_page.dart';
import 'package:admin/screens/Customer/product_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 190, 210, 253),
        title: const Text(
          '               ButyBee',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 20, 92, 216),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 226, 226, 226),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Handle search query changes
                // You may want to update the displayed product list based on the search query
              },
              decoration: InputDecoration(
                hintText: 'Search products',
                border: InputBorder.none,
                // Remove the default border
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear the search query
                    _searchController.clear();
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ProductList(searchQuery: _searchController.text),
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

class ProductList extends StatelessWidget {
  final String searchQuery;

  const ProductList({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Filter products based on the search query
        var filteredProducts = snapshot.data!.docs.where((product) {
          var productName = product['name'].toString().toLowerCase();
          return productName.contains(searchQuery.toLowerCase());
        }).toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Adjust the number of cards per row as needed
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = filteredProducts[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                // Handle the tap event, navigate to the product details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(productId: document.id),
                  ),
                );
              },
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.all(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Display the product image
                    Image.network(
                      data['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                    // Overlay with a semi-transparent background for text
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Color.fromARGB(255, 6, 17, 113).withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs.${data['price'].toString()}',
                                style: const TextStyle(
                                  fontSize: 6,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductSearch extends SearchDelegate<String> {
  final List<DocumentSnapshot> products;

  ProductSearch({required this.products});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // ... (You can customize how search results are displayed)
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // ... (You can customize how search suggestions are displayed)
    return Container();
  }
}
