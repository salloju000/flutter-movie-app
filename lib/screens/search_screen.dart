import 'package:assignment_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    searchMovies(_controller.text);
  }

  Future<void> searchMovies(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load search results');
    }
  }

  void navigateToDetailsScreen(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Movies"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for a movie...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var movie = searchResults[index]['show'];
                return ListTile(
                  onTap: () => navigateToDetailsScreen(movie),
                  leading: movie['image'] != null
                      ? Image.network(
                          movie['image']['medium'] ?? '',
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.movie),
                  title: Text(
                    movie['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
