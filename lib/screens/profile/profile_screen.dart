import 'package:e_learning_app/screens/profile/provider/profile_provider.dart';
import 'package:e_learning_app/screens/profile/result_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/profile.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool _isEditing = false;
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Loading state
        if (profileProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                // SizedBox(height: 16),
                // Text('Loading...', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        // Error state when no profile data is available
        if (profileProvider.profile == null) {
          return const Center(child: Text('No profile data available'));
        }

        final profile = profileProvider.profile!;

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: [
                if (_isEditing) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.blue,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = false; // Save and exit edit mode
                      });
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.blue,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = false; // Save and exit edit mode
                      });
                    },
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 10),
                    child: IconButton(
                      icon:
                      const Icon(Icons.more_vert, color: Colors.blue, size: 40),
                      onPressed: () async {
                        final value = await showMenu<String>(
                          color: Colors.white,
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              100.0, 70.0, 30.0, 0.0), // Adjust position
                          items: [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              height: 70, // Adjust the height of each item
                              child: SizedBox(
                                width: 100, // Increase width of the menu
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.edit, color: Colors.black),
                                    SizedBox(width: 15),
                                    Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'logout',
                              height: 70,
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.logout, color: Colors.black),
                                    SizedBox(width: 15),
                                    Text(
                                      'Logout',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15.0), // Rounded corners
                          ),
                        );

                        if (value == 'edit') {
                          setState(() {
                            _isEditing = true; // Enable edit mode
                          });
                        } else if (value == 'logout') {
                          _showLogoutConfirmation(context);
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    _buildProfilePicture(profile),
                    const SizedBox(height: 15),
                    Text(
                      profile.userName ?? "Unknown User",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.email ?? "No Email Provided",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildStatsRow(profile),
                    const SizedBox(height: 30),
                    _buildSettings(profile),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture(Profile profile) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(profile.profileImageUrl ?? 'https://e-learning-app-bucket.s3.ap-south-1.amazonaws.com/user-profile-images/1-38778606-fabd-4a25-a752-ea9cdf5d3dff.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildStatsRow(Profile profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildStatCard(profile.completerChapterInPercentage.toString(), "Chapters\nCompleted"),
        _buildStatCard(profile.averageScore.toString(), "Average\nTest Score"),
        _buildStatCard(profile.highestScore.toString(), "Highest\nTest Score"),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    int numericValue = int.tryParse(value) ?? 0;
    Color color = _getStatColor(numericValue);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: 32,
                        color: color,
                      ),
                    ),
                    TextSpan(
                      text: "%",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.left,
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

  Color _getStatColor(int value) {
    if (value < 30) {
      return Colors.red.shade600;
    } else if (value >= 30 && value <= 50) {
      return Colors.orange.shade600;
    } else if (value > 50 && value <= 75) {
      return Colors.yellow.shade600;
    } else if (value > 75 && value < 100) {
      return Colors.green.shade600;
    } else {
      return Colors.green.shade600; // Darker green for 100%
    }
  }

  Widget _buildSettings(Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 23,
                height: 23,
                child: Image.asset(
                  'assets/icons/result_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "Results",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResultDetailsScreen()));
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ],
          ),
          const Padding(
            padding:
            EdgeInsets.only(left: 50), // Adjust left padding for alignment
            child: Text(
              "Check the test scores you have \nattempted.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 0.3),

          // Notification Settings Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 20),
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
                    _isNotificationEnabled =value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
              ),
            ],
          ),
          const Padding(
            padding:
            EdgeInsets.only(left: 50), // Adjust left padding for alignment
            child: Text(
              "Turn off the notification if you don’t \nwant to receive.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 0.3),
        ],
      ),
    );
  }
  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minHeight: 220, maxWidth: 340), // Limit the height
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Centering Logout Title and Text
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 50,
                          ),
                          child: Text(
                            'Are you sure you want to logout now?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20, // Slightly smaller text size
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60, // Increased height
                        width: 130, // Reduced width
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                            Colors.transparent, // Transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                                color: Colors.blue, width: 2), // Blue border
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 60, // Increased height
                        width: 130, // Reduced width
                        child: Material(
                          elevation: 6, // Elevation for shadow
                          shadowColor: Colors.blue[400], // Shadow color
                          borderRadius: BorderRadius.circular(
                              10), // Matches button border radius
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.blue, // Blue background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                  color: Colors.blue), // Blue border
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center, // Centers content
                              children: [
                                const SizedBox(width: 8),
                                const Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                const SizedBox(width: 20),
                                CircleAvatar(
                                  backgroundColor: Colors.blue[700],
                                  radius: 12,
                                  child: const Icon(Icons.arrow_right_alt_sharp,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
// import 'dart:io';
// import 'package:e_learning_app/screens/profile/result_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../login/login_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _isNotificationEnabled = true;
//   bool _isEditing = false;
//   File? _image;
//   TextEditingController _usernameController = TextEditingController(text: "Prallav Raj");
//
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           actions: _isEditing
//               ? [
//             IconButton(
//               icon: const Icon(Icons.close, color: Colors.blue, size: 40),
//               onPressed: () => setState(() => _isEditing = false),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.check, color: Colors.blue, size: 40),
//               onPressed: () => setState(() => _isEditing = false),
//             ),
//           ]
//               : [
//             Padding(
//               padding: const EdgeInsets.only(top: 15, right: 10),
//               child: IconButton(
//                 icon: const Icon(Icons.more_vert, color: Colors.blue, size: 40),
//                 onPressed: () async {
//                   final value = await showMenu<String>(
//                     color: Colors.white,
//                     context: context,
//                     position: const RelativeRect.fromLTRB(100.0, 70.0, 30.0, 0.0),
//                     items: const [
//                       PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
//                       PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
//                     ],
//                   );
//                   if (value == 'edit') {
//                     setState(() => _isEditing = true);
//                   } else if (value == 'logout') {
//                     _showLogoutConfirmation(context);
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: _buildBody(),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 30),
//               _buildProfilePicture(),
//               const SizedBox(height: 15),
//               _isEditing
//                   ? TextField(
//                 controller: _usernameController,
//                 style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               )
//                   : Text(
//                 _usernameController.text,
//                 style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               const Text("prallav.raj@gmail.com", style: TextStyle(fontSize: 18, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfilePicture() {
//     return GestureDetector(
//       onTap: _isEditing ? _pickImage : null,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundImage: _image != null
//                 ? FileImage(_image!)
//                 : const AssetImage('assets/icons/result_icon.png') as ImageProvider,
//             child: _isEditing
//                 ? ClipOval(
//               child: Container(
//                 color: Colors.white.withOpacity(0.4), // Blur effect
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             )
//                 : null,
//           ),
//           if (_isEditing)
//             Container(
//               width: 50,
//               height: 50,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.blue, // Blue circle around the icon
//               ),
//               child: const Icon(
//                 Icons.camera_alt_outlined,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//
//   void _showLogoutConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to logout?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }
// }