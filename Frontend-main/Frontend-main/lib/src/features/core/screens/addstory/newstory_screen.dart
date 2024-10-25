import 'package:codesafari/src/features/authentication/controllers/login_controller.dart';
import 'package:codesafari/src/features/core/screens/addstory/story_screen.dart';
import 'package:codesafari/src/repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewstoryScreen extends StatefulWidget {
  const NewstoryScreen({super.key});

  @override
  _NewstoryScreenState createState() => _NewstoryScreenState();
}




class _NewstoryScreenState extends State<NewstoryScreen>
    with TickerProviderStateMixin {
  // Changed to TickerProviderStateMixin
  // Variables to hold the selected answers
  String? _selectedConcept;
  String? _selectedStoryGenre;
  String? _selectedLanguage;
  bool _isLoading = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  final loginController = Get.find<LoginController>();
  String email = '';




  // Function to make POST request to Flask API
  Future<void> _generateStory() async {
    setState(() {
      _isLoading = true;
      _progressController.reset();
      _progressController.forward();
    });

    final userEmail = Get.find<UserRepository>().getLoggedInUserEmail();

    // Prepare the data to be sent to the API
    final requestData = {
      'api_key': 'AIzaSyBIiTogO5dybROEfWlvZt2KHsc06PVOeWg',
      'concept': _selectedConcept,
      'genre': _selectedStoryGenre,
      'language': _selectedLanguage,
      'email': email,
    };

    // Print the request data
    print('Data being sent to API: $requestData');

    final response = await http.post(
      Uri.parse(
          'https://88f2-2402-4000-b193-51c2-fec2-e70a-ded8-3206.ngrok-free.app/generate_story'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Story and MCQs generated successfully') {
        // Delay the navigation to the story screen by 15 seconds
        await Future.delayed(const Duration(seconds: 15));
        _navigateToStoryScreen(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate story')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate story')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to navigate to the story screen with the generated data
  void _navigateToStoryScreen(Map<String, dynamic> data) {
    String genreImage = '';

    switch (_selectedStoryGenre) {
      case 'Adventure':
        genreImage = 'assets/images/story/adventure.gif';
        break;
      case 'Fantasy':
        genreImage = 'assets/images/story/fantasy.png';
        break;
      case 'Fairy Tales':
        genreImage = 'assets/images/story/fairytale.png';
        break;
      case 'Mystery':
        genreImage = 'assets/images/story/mystery.gif';
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryScreen(
          data: data,
          genreImage: genreImage,
        ),
      ),
    );
  }

  // PageController to handle page transitions
  final PageController _pageController = PageController();
  double _progress = 0.0;
  final int _pagesCount = 3; // Track the number of pages manually
  late AnimationController _animationController;
  late AnimationController _arrowAnimationController;
  late Animation<double> _arrowAnimation;
  int _currentPage = 0;

  Future<String> getEmail() async {
    return await loginController.getUsername() ?? 'User';
  }

  Future<void> _assignEmail() async {
    email = await getEmail();
  }

  @override
  void initState() {
    super.initState();
    _assignEmail();

    // Initialize the page controller listener
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        final page = _pageController.page;
        if (page != null) {
          setState(() {
            _progress = page / (_pagesCount - 1);
            _currentPage = page.round();
          });
        }
      }
    });




    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Initialize the progress animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize the arrow animation controller
    _arrowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true); // Repeat animation with reverse effect

    _arrowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
          parent: _arrowAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _arrowAnimationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100,
        title: Text(
          'New Story',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CSAccentColor,
              ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(CSAccentColor),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Almost done!",
                    style: TextStyle(
                      color: CSAccentColor2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Story is on your way..",
                    style: TextStyle(
                      color: CSAccentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 50),
                // Progress Bar with increased height
                SizedBox(
                  height: 8.0, // Increased height for the progress bar
                  width: 350.0,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.deepPurple.shade200,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(CSAccentColor),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildQuestionPage(
                        title:
                            'Which programming concept would you like to study today?',
                        subtitle:
                            'Choose a concept you\'re interested in. Let\'s make learning fun and productive!',
                        options: [
                          'Sequence',
                          'Loops',
                          'Conditionals',
                          'Variables'
                        ],
                        groupValue: _selectedConcept,
                        onChanged: (value) {
                          setState(() {
                            _selectedConcept = value;
                          });
                        },
                        onNext: () {
                          _animationController.forward().then((_) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            _animationController.reset(); // Reset animation
                          });
                        },
                      ),
                      _buildQuestionPage(
                        title: 'What\'s your favorite kind of story?',
                        subtitle:
                            'Choose the type of story you love the most! This helps us find the best stories for you.',
                        options: [
                          'Adventure',
                          'Fantasy',
                          'Fairy Tales',
                          'Mystery'
                        ],
                        groupValue: _selectedStoryGenre,
                        onChanged: (value) {
                          setState(() {
                            _selectedStoryGenre = value;
                          });
                        },
                        onNext: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      _buildQuestionPage(
                        title:
                            'What is your preferred language to generate the story?',
                        subtitle: 'Choose the language you prefer.',
                        options: ['English', 'Tamil'],
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        },
                        onNext: () {
                          if (_selectedConcept != null &&
                              _selectedStoryGenre != null &&
                              _selectedLanguage != null) {
                            print('Selected Concept: $_selectedConcept');
                            print('Selected Story Type: $_selectedStoryGenre');
                            print('Selected Language: $_selectedLanguage');
                            _generateStory();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please complete all questions before proceeding.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuestionPage({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? groupValue,
    required void Function(String?) onChanged,
    required VoidCallback onNext,
  }) {
    return Padding(
      padding: const EdgeInsets.all(CSDefaultSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CSAccentColor2,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black38,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) {
            return ListTile(
              title: Text(option),
              leading: Radio<String>(
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            );
          }),
          const SizedBox(height: 32),
          if (_currentPage < 2) // Show arrow for the first and second pages
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onNext,
                child: AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_arrowAnimation.value, 0),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: CSAccentColor,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            )
          else if (_currentPage == 2) // Show the button on the third page
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CSAccentColor, // Button background color
                  shape: const StadiumBorder(), // Rounded button
                ),
                child: const Center(
                  // Center the button text
                  child: Text(
                    'Generate Your Story',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
