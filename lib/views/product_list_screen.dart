import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/product_view_model.dart';
import '../viewmodels/cart_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_theme.dart';
import '../widgets/product_list_components.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showSearch = false;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _searchController.addListener(_onSearchChanged);
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (_showSearch) {
        _animationController.forward();
        Future.delayed(const Duration(milliseconds: 100), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _animationController.reverse();
        _searchFocusNode.unfocus();
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductViewModel productViewModel = Get.find<ProductViewModel>();
    final CartViewModel cartViewModel = Get.find<CartViewModel>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ProductListComponents.buildHeaderBackground(),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showSearch
                  ? ProductListComponents.buildSearchField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      animation: _animation,
                      onClear: () => _searchController.clear(),
                    )
                  : const Text(
                      'Shopsy',
                      key: ValueKey('appTitle'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
              ),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _showSearch ? Icons.close : Icons.search,
                    key: ValueKey(_showSearch ? 'close' : 'search'),
                    color: Colors.white,
                  ),
                ),
                tooltip: _showSearch ? 'Close search' : 'Search products',
                onPressed: _toggleSearch,
              ),
              ProductListComponents.buildCartButton(
                cartViewModel,
                () => Get.toNamed(AppRoutes.cart),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
        body: Obx(() {
          if (productViewModel.isLoading.value) {
            return ProductListComponents.buildLoadingState();
          }
          
          if (productViewModel.hasError.value) {
            return ProductListComponents.buildErrorState(
              message: productViewModel.errorMessage.value,
              onRetry: () => productViewModel.retryLoading()
            );
          }

          if (productViewModel.products.isEmpty) {
            return ProductListComponents.buildEmptyState();
          }

          return ProductListComponents.buildProductGrid(
            context: context,
            productViewModel: productViewModel,
            cartViewModel: cartViewModel,
            searchQuery: _searchQuery,
          );
        }),
      ),
    );
  }

}
