import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      theme: ThemeData(
        // Mengubah tema utama menjadi Navy/Indigo modern
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF1E3A8A),
      ),
      home: const ShoppingCartScreen(),
    );
  }
}

// Model data produk
class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageAssetPath;
  int likes;
  int quantity;
  bool isSelected;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageAssetPath,
    required this.likes,
    this.quantity = 1,
    this.isSelected = false,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  // Data produk
  final List<Product> products = [
    Product(
      id: '1',
      name: 'liverpool kits 96/97',
      brand: 'REEBOK',
      price: 1780000,
      imageAssetPath: 'assets/images/liverpool kits 96.png',
      likes: 345,
    ),
    Product(
      id: '2',
      name: 'AS roma kits 98/99',
      brand: 'DIADORA',
      price: 1220000,
      imageAssetPath: 'assets/images/AS roma kits 98.png',
      likes: 422,
    ),
    Product(
      id: '3',
      name: 'Fiorentina kits 97/98',
      brand: 'FILA',
      price: 2500000,
      imageAssetPath: 'assets/images/Fiorentina kits 97.png',
      likes: 246,
    ),
  ];

  double get totalPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  String formatRupiah(double number) {
    return 'Rp ${number.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang diubah ke Slate Light Gray yang sangat bersih
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Cart'),
        // Warna Navy Blue Elegan untuk AppBar
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Subtitle petunjuk dengan warna lembut yang kontras
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFFEFF6FF),
            width: double.infinity,
            child: const Text(
              'Tekan untuk memilih, tekan 2x untuk suka.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF2563EB)),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var p in products) {
                        p.isSelected = false;
                      }
                      product.isSelected = true;
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      product.likes += 1;
                    });
                  },
                  onLongPress: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Produk dipilih',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${product.name} telah dipilih'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF0F172A),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      // Border biru royal terang jika dipilih
                      border: Border.all(
                        color: product.isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product.imageAssetPath,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 75,
                                height: 75,
                                color: const Color(0xFFE2E8F0),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image, color: Color(0xFF94A3B8)),
                                    Text('Gambar\ntidak ada',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0F172A), // Teks judul lebih gelap & tajam
                                ),
                              ),
                              Text(
                                product.brand,
                                style: const TextStyle(
                                  color: Color(0xFF64748B), // Subtitle abu-abu sedang
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formatRupiah(product.price),
                                style: const TextStyle(
                                  color: Color(0xFF2563EB), // Harga biru terang
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  const Icon(Icons.favorite, color: Color(0xFFEF4444), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.likes}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Tombol Pengatur Jumlah
                        Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF64748B)),
                              onPressed: () {
                                setState(() {
                                  if (product.quantity > 1) {
                                    product.quantity--;
                                  }
                                });
                              },
                            ),
                            Text(
                              '${product.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              icon: const Icon(Icons.add_circle, color: Color(0xFF2563EB)),
                              onPressed: () {
                                setState(() {
                                  product.quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Total Harga & Tombol Checkout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total ($totalItems produk)',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                    Text(
                      formatRupiah(totalPrice),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // Tombol checkout biru cerah mencolok
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB), // Item aktif
        unselectedItemColor: const Color(0xFF94A3B8), // Item tidak aktif
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}