import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categories = [];
  List<bool> hoverFlags = [];

  double textPosition = 1.0;
  final promoText =
      "🔥 Promo Spesial Hari Ini! Diskon sampai 50% untuk semua produk! 🔥";

  @override
  void initState() {
    super.initState();
    loadJson();
    startMarquee();
  }

  void startMarquee() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 34));
      setState(() {
        textPosition -= 0.0024;
        if (textPosition < -1.3) textPosition = 1.0;
      });
    }
  }

  Future<void> loadJson() async {
    final response = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/products.json');
    final data = json.decode(response);

    setState(() {
      categories = data['categories'];
      hoverFlags = List.generate(categories.length, (_) => false);
    });
  }

  // Convert string → icon
  IconData getIcon(String name) {
    switch (name) {
      case "kitchen":
        return Icons.kitchen;
      case "weekend":
        return Icons.weekend;
      case "bed":
        return Icons.bed;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        elevation: 4,
        shadowColor: Colors.brown.shade900.withOpacity(0.4),
        title: Row(
          children: [
            Icon(Icons.store_mall_directory, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              "MyShop Mini",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Marquee Promo
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.brown.shade600,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 0),
                  left: MediaQuery.of(context).size.width * textPosition,
                  top: 8,
                  child: Text(
                    promoText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Pilih Kategori",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
          ),

          SizedBox(height: 14),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.78,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var cat = categories[index];
                return MouseRegion(
                  onEnter: (_) => setState(() => hoverFlags[index] = true),
                  onExit: (_) => setState(() => hoverFlags[index] = false),

                  child: AnimatedScale(
                    scale: hoverFlags[index] ? 1.05 : 1.0,
                    duration: Duration(milliseconds: 200),

                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: hoverFlags[index]
                                ? Colors.brown.shade400.withOpacity(0.45)
                                : Colors.brown.shade300.withOpacity(0.25),
                            blurRadius: hoverFlags[index] ? 18 : 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductListScreen(
                                categoryId: cat['id'],
                                categoryName: cat['name'],
                              ),
                            ),
                          );
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getIcon(cat['icon']),
                              size: 46,
                              color: Colors.brown.shade700,
                            ),
                            SizedBox(height: 12),
                            Text(
                              cat['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.brown.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
