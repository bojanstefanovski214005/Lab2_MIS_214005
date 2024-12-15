import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/api_services.dart';

class JokesByCategoryScreen extends StatefulWidget {
  final String type;

  const JokesByCategoryScreen({super.key, required this.type});

  @override
  _JokesByCategoryScreenState createState() => _JokesByCategoryScreenState();
}

class _JokesByCategoryScreenState extends State<JokesByCategoryScreen> {
  late Future<List<Joke>> _jokes;

  @override
  void initState() {
    super.initState();
    _jokes =
        ApiServices.fetchJokesByType(widget.type); // Fetch jokes based on type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text('${widget.type} jokes',
            style: const TextStyle(color: Colors.white)),
        backgroundColor:
            const Color.fromARGB(255, 36, 119, 79), // Matching the theme color
      ),
      body: FutureBuilder<List<Joke>>(
        future: _jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jokes available.'));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0), // Space between cards
                  child: Card(
                    color: const Color.fromARGB(255, 36, 119, 79),
                    elevation: 5, // Shadow effect
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jokes[index].setup,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            jokes[index].punchline,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}