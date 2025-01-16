import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () async {
                await showMenu<String>(
                  color: Colors.white,
                  context: context,
                  position:
                      const RelativeRect.fromLTRB(100.0, 50.0, 20.0, 20.0),
                  items: [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.black),
                          SizedBox(width: 20),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      height: 60,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.black),
                          SizedBox(width: 20),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0)), // Rounded corners
                ).then((value) {
                  if (value == 'edit') {
                    print('Edit option selected');
                  } else if (value == 'logout') {
                    print('Logout option selected');
                  }
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              // Profile Picture with Blue Border
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ), // Blue border
                ),
                child: const Padding(
                  padding: EdgeInsets.all(
                      5), // This creates the small space inside the border
                  child: CircleAvatar(
                    radius: 60, // Image size
                    // backgroundImage: AssetImage('assets/images/book.png'), // Your image asset
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Prallav Raj",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "prallav.raj@gmail.com",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // Stats Row with padding and left-alignment
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStatCard(
                      "30%", "Chapters\nCompleted", Colors.red[200]!),
                  _buildStatCard(
                      "70%", "Average\nTest Score", Colors.yellow[600]!),
                  _buildStatCard(
                      "75%", "Highest\nTest Score", Colors.orange[300]!),
                ],
              ),
              const SizedBox(height: 30),

              // Results and Notification without color or border
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_turned_in_sharp,
                          color: Colors.blue[300],
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Results",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.blue, size: 20)),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 40.0),
                      child: Text(
                        "Check the test scores you have \nattempted.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Divider(
                      thickness: 0.4,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.orange),
                        const SizedBox(width: 15),
                        const Text(
                          "Notification Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              _isNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.blue,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        )

                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 40.0), // Added left padding for the subtext
                      child: Text(
                        "Turn off the notification if you don’t \nwant to receive.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Divider(
                      thickness: 0.4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              bottom: 20,
              left: 20,), // Adds padding inside the card
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns content to the left
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 30,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.left, // Align text to the left
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
