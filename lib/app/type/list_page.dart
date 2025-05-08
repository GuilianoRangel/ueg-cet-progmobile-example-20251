import 'package:collegeapi/collegeapi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

import '../../main.dart';


class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<CategoryDTO> _categories = [];
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  AppApi? api;
  late CategoryControllerApi? categoryController;

  @override
  void initState() {
    super.initState();
    if(this.api != null) {
      _fetchCategories();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchCategories();
      }
    });
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);

    final pageable = Pageable((p) => p
      ..page = _currentPage
      ..size = _pageSize
      ..sort = ListBuilder<String>(['name,asc']),
    );

    //Pageable pageable = Pageable(page: _currentPage, size: _pageSize);

    Response<PageCategoryDTO>? result = await categoryController?.categoryControllerListAllPage(page: pageable);

    if (result != null) {
      setState(() {
        _categories.addAll(result.data?.content as Iterable<CategoryDTO>);
        _currentPage++;
        _hasMore = !(result.data?.last??true);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initApi(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _categories.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _categories.length) {
            final category = _categories[index];
            return ListTile(
              title: Text(category.name),
              subtitle: Text(category.searchDescription ?? ''),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }


  void initApi(BuildContext context) {
    if(this.api == null){
      this.api = context.read<AppApi>();
      this.categoryController = this.api?.api.getCategoryControllerApi();
      _fetchCategories();
    }
  }
}
