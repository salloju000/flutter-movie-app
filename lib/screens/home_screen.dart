import 'package:assignment_app/screens/details_screen.dart';
import 'package:assignment_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  int page = 1; // Start page for loading movies
  bool isLoading = true;
  bool isMoreDataAvailable = true; // To check if more data is available

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  // Function to fetch movies from the API with pagination
  Future<void> fetchMovies() async {
    if (!isMoreDataAvailable) {
      return; // Stop fetching if no more data is available
    }

    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));

    if (response.statusCode == 200) {
      List<dynamic> newMovies = json.decode(response.body);

      setState(() {
        movies.addAll(newMovies);
        isLoading = false;
        page++; // Increase page number for next fetch
        if (newMovies.isEmpty) {
          isMoreDataAvailable = false; // Stop loading if no more data
        }
      });
    } else {
      setState(() {
        isLoading = false;
        isMoreDataAvailable = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  // Function to handle movie click (navigating to details)
  void navigateToDetailsScreen(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(movie: movie),
      ),
    );
  }

  // Function to clean HTML content
  String cleanHtml(String htmlContent) {
    final document = parse(htmlContent);
    final body = document.body;

    body?.querySelectorAll('p, br').forEach((element) {
      element.replaceWith(dom.Text(' '));
    });

    return body?.text.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: movies.length +
                  1, // +1 for the loading indicator at the bottom
              itemBuilder: (context, index) {
                if (index < movies.length) {
                  var movie = movies[index];
                  return GestureDetector(
                    onTap: () => navigateToDetailsScreen(movie),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            movie['image'] != null
                                ? Image.network(
                                    movie['image']['medium'],
                                    height: 264,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : const Placeholder(fallbackHeight: 200),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return isLoading && isMoreDataAvailable
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
              },
              controller: ScrollController()
                ..addListener(() {
                  if (!isLoading &&
                      isMoreDataAvailable &&
                      ScrollController().position.pixels >=
                          ScrollController().position.maxScrollExtent - 100) {
                    fetchMovies(); // Load more when reaching near the end
                  }
                }),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
