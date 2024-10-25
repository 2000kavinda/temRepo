import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesafari/src/features/core/screens/dashboard/storydetail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codesafari/src/constants/colors.dart';
import 'package:codesafari/src/constants/sizes.dart';
import 'package:codesafari/src/features/core/screens/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // List of available image assets
  final List<String> _imageAssets = List.generate(
    20,
        (index) => 'assets/images/story/story${index + 1}.png',
  );
  final _defaultImage = 'assets/images/story/default.png';

  final _random = Random();
  final Map<String, String> _imageCache = {}; // Cache for assigned images

  String getUniqueImage(String storyId) {
    // If an image is already assigned to this story, return it
    if (_imageCache.containsKey(storyId)) {
      return _imageCache[storyId]!;
    }

    // Otherwise, assign a new unique image
    if (_imageCache.length == _imageAssets.length) {
      _imageCache.clear(); // Reset if all images are used
    }

    String image;
    do {
      image = _imageAssets[_random.nextInt(_imageAssets.length)];
    } while (_imageCache.containsValue(image));

    _imageCache[storyId] = image;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Fetch the current logged-in user's email
    final String currentUserEmail =
        FirebaseAuth.instance.currentUser?.email ?? '';

    // Fetch stories from Firestore where the email address matches the current user's email
    final storiesStream = FirebaseFirestore.instance
        .collection('stories')
        .where('email', isEqualTo: currentUserEmail)
        .snapshots();

    // Demo data in case of no stories
    final List<Map<String, dynamic>> demoData = [
      {
        'title': 'The Importance of Sequence in The Quest for the Magical Artifact',
        'genre': 'Sequence',
        'story': '''
In a faraway land of adventure, there lived a brave knight named Sir Quest. One sunny morning, he set out on a perilous quest to retrieve a magical artifact from the depths of a labyrinthine castle.

The castle was shrouded in mystery, its twisting corridors leading to unknown dangers. To navigate the castle, Sir Quest relied on a magical map that provided him with a strict sequence of directions.

"First," the map instructed, "turn left at the marble fountain." Sir Quest promptly obeyed, following the arrow pointed to the left.

"Next," the map said, "proceed straight for twenty steps." Sir Quest counted his steps carefully, walking in a straight line for the required distance.

"Then," the map continued, "take the third door on your right." Sir Quest scanned the wall for doors and counted until he reached the third on his right. He pushed the door open, revealing a dimly lit chamber.

"Finally," the map instructed, "climb the spiral staircase to the top of the tower." Sir Quest ascended the winding staircase, each step bringing him closer to his goal.

As Sir Quest followed the sequence of directions precisely, he encountered various obstacles. He battled fierce creatures, solved tricky puzzles, and dodged hidden traps. But with each challenge he faced, he remained unwavering in his determination to follow the map's instructions.

Finally, he reached the top of the tower, where the magical artifact awaited him. It was a shimmering orb that glowed with an ethereal light.

Sir Quest realized that it was the sequence of directions that had led him to success. By following the instructions in the correct order, he had overcome every obstacle and retrieved the artifact.

And so, the brave knight learned the importance of sequence in adventure and beyond. For just as following a sequence of directions led him to his goal, so too can following a sequence of instructions in programming help us create amazing things on computers.
''',
      },
      {
        'title': 'The Adventure of Max and the Lost Treasure',
        'genre': 'Sequence',
        'story': '''
Once upon a time, there was a brave adventurer named Max. Max was on a quest to find the lost treasure of the ancient wizard, Zarthus.

Zarthus was a powerful wizard, and he hid his treasure in a secret location. The only way to find the treasure was to follow a series of clues.

The first clue was a map. The map showed a path that led through a forest, across a river, and up a mountain.

Max followed the map carefully. He walked through the forest, crossed the river, and climbed up the mountain.

At the top of the mountain, Max found a cave. The cave was dark and scary, but Max was brave. He entered the cave and followed a narrow passageway.

At the end of the passageway, Max found a door. The door was locked, but there was a keyhole.

Max remembered that another clue was a key. He searched his pockets and found the key. He put the key in the keyhole and turned it.

The door opened, and Max stepped inside.

The treasure room was filled with gold, silver, and jewels. Max was amazed! He had finally found the lost treasure of Zarthus.

Max knew that he had to follow the sequence of clues in order to find the treasure. If he had missed any of the clues, he would have gotten lost.

The sequence of clues was like a program. A program is a set of instructions that a computer follows. The computer follows the instructions in the program one at a time, in order.

Just like Max followed the clues in order to find the treasure, a computer follows the instructions in a program in order to do its job.
''',
      },
      {
        'title': 'Ario and Realm of Code: A Sequencing Adventure',
        'genre': 'Sequence',
        'story': '''
In the ancient kingdom of Algoria, nestled among towering mountains and sparkling rivers, there lived a brave adventurer named Arlo. Arlo had an unyielding determination and a thirst for adventure that propelled him to embark on perilous quests.

One fateful day, as Arlo ventured deep into the Misty Forest, he stumbled upon a mysterious cave. Curiosity sparked within him, and he couldn't resist exploring its depths. As he cautiously descended the winding path, the darkness enveloped him like a thick blanket.

Suddenly, a faint glow appeared in the distance. With renewed vigor, Arlo quickened his pace, eager to uncover the secrets that lay ahead. As he approached the source of the light, he realized it was a shimmering portal. Intrigued, he reached out and touched its surface.

In an instant, Arlo was transported to a realm of infinite possibilities. A wise old wizard greeted him with a warm smile and spoke to him in a voice that echoed with ancient wisdom.

"Welcome, young adventurer, to the Realm of Code. I am here to guide you through the path of sequencing, a powerful tool that will empower you on your quests."

The wizard explained that sequencing involved arranging a series of actions or instructions in a specific order. He likened it to the adventurer's journey, where each step had to be followed in the right sequence to achieve success.

"In this realm, you will encounter obstacles and challenges," said the wizard. "But by understanding sequencing, you will be able to navigate them with precision and determination."

The wizard presented Arlo with a series of puzzles, each requiring him to use sequencing to overcome obstacles. With each puzzle he solved, Arlo gained confidence in his understanding of this powerful concept.

Through perilous canyons and winding mazes, Arlo followed the wizard's teachings, learning the importance of logical order and planning. He discovered that by carefully sequencing his actions, he could overcome any challenge that lay in his path.

Armed with this newfound knowledge, Arlo returned to the Misty Forest, a stronger and wiser adventurer than before. He could now navigate the treacherous paths with ease, his every step informed by the principles of sequencing.

From that day forward, Arlo's adventures became legends throughout the kingdom. He used his understanding of sequencing to triumph over evil, rescue those in need, and forge a brighter future for all who crossed his path. And so, in the realm of Algoria, the legend of Arlo, the master of sequencing, was passed down through generations, inspiring young adventurers to embrace the power of logical thought and embark on extraordinary journeys.
''',
      },
      {
        'title': "The Case of the Variable Variables: Maya's Perplexing Puzzle",
        'genre': 'Variable',
        'story': '''
In the quaint town of Ridgedale, where secrets whispered through the ancient cobblestone streets, there lived a young detective named Maya with a keen eye for puzzles. One fateful night, as the moon cast an eerie glow upon the town, Maya received a mysterious message from her mentor, the renowned Detective Phoenix.

"Maya, a puzzling case awaits your brilliant mind," the message read. "Investigate the mysterious disappearance of a valuable artifact—the fabled Amulet of Enigma. Your trusty journal shall serve as your loyal companion, where you must note down the clues and suspects you encounter."

With a determined glimmer in her eyes, Maya opened her vibrant journal, its pages ready to unfold the tale. As she delved into the investigation, she realized that every piece of information she discovered was like a variable, a valuable part of the puzzle that could change as the case progressed.

First, she met the enigmatic Lady Celeste, an ageless beauty rumored to possess ancient knowledge. As Maya interrogated her, Lady Celeste revealed a cryptic clue: "The amulet holds a secret key, find the box in the old oak tree."

Maya diligently jotted down this clue as a variable in her journal, labeling it "Amulet Secret." Along the way, she encountered the cunning thief, Sly Silas, who confessed to stealing a box from the old oak tree.

"The box?" Maya exclaimed with growing excitement. "What was inside?"

With a sly grin, Silas replied, "Ah, that I cannot tell. You'll have to discover its contents yourself."

Undeterred, Maya added "Box Contents" as another variable in her journal. As she continued her investigation, Maya's journal became filled with countless variables—the amulet's location, the suspects' motives, and the possible key it held.

Finally, Maya stood before the old oak tree, its gnarled branches reaching towards the starlit sky. There, hidden within its hollow trunk, she found the box. Trembling with anticipation, she opened it to reveal a golden key, its surface adorned with intricate carvings.

"Could this be the key to the Amulet of Enigma?" Maya whispered to herself.

With newfound determination, she raced back to Lady Celeste. As she fitted the key into the amulet's lock, its surface shimmered and a gentle glow filled the room. Hidden within the amulet was a priceless gemstone that emitted an otherworldly light.

Maya had solved the case, connecting the variables like a master puzzle solver. She realized that variables were essential in solving any mystery—they represented the changing pieces of information that needed to be tracked and adjusted to uncover the truth.

And so, Maya's journal became a testament to her brilliant detective work, a reminder that even in the most perplexing mysteries, variables held the key to unraveling the unknown.
''',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: textTheme.headlineSmall?.copyWith(color: CSAccentColor2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_sharp, color: CSAccentColor2),
            onPressed: () => Get.to(
                  () => const ProfileScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 800),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title below the AppBar
          Padding(
            padding: const EdgeInsets.all(CSDefaultSize),
            child: Text(
              'Your Coding Stories',
              style: textTheme.headlineSmall?.copyWith(
                color: CSSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: storiesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading stories'));
                }

                // Check for no data, and if true, use demo data
                final List<Map<String, dynamic>> stories =
                (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                    ? snapshot.data!.docs
                    .map((doc) => {
                  'title': doc['title'],
                  'genre': doc['genre'],
                  'story': doc['story'],
                  'id': doc.id,
                })
                    .toList()
                    : demoData;

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: CSDefaultSize),
                  child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cards per line
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      final genre = story['genre'] as String;
                      final title = story['title'] as String;
                      final storyId = story['id'] ?? 'demo_$index'; // Use story ID to cache image
                      final image = getUniqueImage(storyId);

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the story detail screen
                          Get.to(() => StoryDetailScreen(
                            storyTitle: title,
                            storyContent: story['story'],
                            storyImage: image,
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min, // Adjust to fit content
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16.0)),
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  title,
                                  style: textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                  overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                                  maxLines: 1, // Limit to one line
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
