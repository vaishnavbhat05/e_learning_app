import 'package:e_learning_app/screens/home/provider/home_provider.dart';
import 'package:e_learning_app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chapters/chapter_screen.dart';

class SearchNotFoundScreen extends StatefulWidget {
  const SearchNotFoundScreen({super.key});

  @override
  _SearchNotFoundScreenState createState() => _SearchNotFoundScreenState();
}

class _SearchNotFoundScreenState extends State<SearchNotFoundScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  bool isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.length >= 3) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      // Call searchSubjects to fetch matching subjects from the provider
      await homeProvider.searchSubjects(query);

      setState(() {
        // Map the search results to subject names
        _suggestions = homeProvider.searchResults
            .map((subject) => subject.subjectName) // Assuming subjectName is available
            .toList();
      });
    } else {
      setState(() {
        _suggestions.clear(); // Clear suggestions if the query is too short
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      resizeToAvoidBottomInset: true, // This ensures the keyboard doesn't overlap
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(index: 0), // Navigate to Profile tab
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Result',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    'assets/images/search_not_found.png', // Ensure this asset exists
                    height: 350,
                  ),
                ),
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Not Found',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Search not found, please try again',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                            hintText: 'Search...',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final keyword = _searchController.text.trim();
                          if (keyword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter a search keyword")),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                            _suggestions.clear();
                          });

                          final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                          try {
                            // Clear existing results and perform new search
                            homeProvider.searchResults.clear();
                            await homeProvider.searchSubjects(keyword);

                            if (homeProvider.searchResults.isNotEmpty) {
                              final subject = homeProvider.searchResults.first;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterScreen(
                                    subjectId: subject.id,
                                    subjectName: subject.subjectName,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SearchNotFoundScreen()),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("An error occurred, please try again")),
                            );
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: isLoading
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                              : const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true, // Prevent overflow
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            setState(() {
                              _searchController.text = _suggestions[index];
                              _suggestions.clear(); // Clear suggestions after selection
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20), // Extra space for better UX when keyboard appears
              ],
            ),
          ),
        ),
      ),
    );
  }
}
