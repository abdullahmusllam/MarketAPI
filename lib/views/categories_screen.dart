import 'package:e_market_api/controllers/categry_controller.dart';
import 'package:e_market_api/views/products_screen.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService apiService = ApiService();

  Future<List<String>> _getCategories() async {
    return await apiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'التصنيفات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: colorScheme.primary),
                    );
                  } else if (snapshot.hasError) {
                    return _buildErrorState(colorScheme, snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState(colorScheme);
                  }

                  final categories = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryColor = _getCategoryColor(index, colorScheme);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductsScreen(category: category),
                            ),
                          );
                        },
                        child: _buildCategoryCard(category, categoryColor, colorScheme),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, Color color, ColorScheme scheme) {
    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(_getCategoryIcon(category), color: color, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              category,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ColorScheme scheme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: scheme.error),
          const SizedBox(height: 16),
          Text('خطأ: $error', style: TextStyle(color: scheme.error, fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 70, color: scheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'لا توجد فئات متاحة',
            style: TextStyle(fontSize: 18, color: scheme.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index, ColorScheme scheme) {
    final colors = [
      scheme.primary,
      scheme.error,
      scheme.tertiary,
      scheme.secondary,
      Colors.amber,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoryIcon(String category) {
    final Map<String, IconData> icons = {
      'electronics': Icons.devices,
      'jewelery': Icons.diamond,
      "men's clothing": Icons.man,
      "women's clothing": Icons.woman,
    };
    return icons[category.toLowerCase()] ?? Icons.category;
  }
}
