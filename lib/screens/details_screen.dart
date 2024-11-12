import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  const DetailsScreen({super.key, required this.movie});

  // Function to clean HTML tags from the summary
  String cleanHtml(String htmlText) {
    final document = parse(htmlText);
    return parse(document.body!.text).documentElement!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 700.0, // Set expanded height to 500
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: movie['image'] != null
                  ? Image.network(
                      movie['image']['original'],
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 90.0, horizontal: 16.0),
                  child: Center(
                    child: Text(
                      movie['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 250, 246, 246),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    movie['summary'] != null && movie['summary'] is String
                        ? cleanHtml(movie['summary'])
                        : 'No summary available',
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
