import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chapters/chapter_screen.dart';
import 'package:e_learning_app/screens/subjects/provider/subject_provider.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<SubjectProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.subjects.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/404.jpeg',
                        width: 350,
                        height: 350,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  try {
                    await provider.fetchSubjects();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to load data. Please try again later.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Subjects',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.subjects.length,
                        itemBuilder: (context, index) {
                          final subject = provider.subjects[index];
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0.1,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 25),
                                leading: Image.network(
                                  subject.subjectIcon.trim(),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    subject.subjectName,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setInt('subjectId', subject.id);
                                  await prefs.setString(
                                      'subjectName', subject.subjectName);
                                  print(subject.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChapterScreen(
                                        subjectId: subject.id,
                                        subjectName: subject.subjectName,
                                      ),
                                    ),
                                  ); // Pass the subjectId
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
