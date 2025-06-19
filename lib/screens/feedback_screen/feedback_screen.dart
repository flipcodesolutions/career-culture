import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // State variables for the rating and checkboxes
  int? _selectedRating; // Stores the index of the selected emoji rating
  bool _helpsGoalYes = false;
  bool _helpsGoalNo = false;
  bool _helpsGoalNotSure = false;
  final TextEditingController _commentController = TextEditingController();

  // Map to hold emoji icons and their descriptions
  final List<Map<String, dynamic>> _ratings = [
    {'icon': '😠', 'description': 'Terrible'},
    {'icon': '😞', 'description': 'Bad'},
    {'icon': '😐', 'description': 'Neutral'},
    {'icon': '😮', 'description': 'Good'},
    {'icon': '🥰', 'description': 'Excellent'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar with back button
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow for the app bar
        leading: IconButton(
          icon: const Icon(
            Icons
                .arrow_back_ios_new, // Use iOS style back arrow for closer match
            color: Colors.black,
          ),
          onPressed: () {
            // Handle back button press
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "We Care About Your Experience" Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💬', // Emoji icon
                    style: TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We Care About Your Experience',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700], // Darker green for title
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Please take a moment to share your thoughts about today\'s session.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Counselor Information Card
              Card(
                elevation: 2, // Slight shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Counselor Avatar/Icon
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: const Icon(
                          Icons
                              .person_outline, // Placeholder for counselor avatar
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Counselor Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Counselor: Meena Vyas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Date: June 6, 2025',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Time Slot: 7:00 PM - 8:00 PM',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // "How would you rate this session?" Section
              const Text(
                'How would you rate this session?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              // Emoji Rating Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_ratings.length, (index) {
                  bool isSelected = _selectedRating == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRating = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected
                                    ? Colors.orange.withOpacity(0.2)
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.orange
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            _ratings[index]['icon'],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        if (isSelected) // Show description only for the selected emoji
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _ratings[index]['description'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // "Do this session helps you to move closer to your goal?" Section
              const Text(
                'Do this session helps you to move closer to your goal?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              // Checkbox options
              Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Yes'),
                    value: _helpsGoalYes,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _helpsGoalYes = newValue!;
                        if (newValue) {
                          _helpsGoalNo = false;
                          _helpsGoalNotSure = false;
                        }
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.leading, // Checkbox on the left
                    contentPadding: EdgeInsets.zero, // Remove default padding
                    activeColor: Colors.orange, // Checkbox color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('No'),
                    value: _helpsGoalNo,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _helpsGoalNo = newValue!;
                        if (newValue) {
                          _helpsGoalYes = false;
                          _helpsGoalNotSure = false;
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Not sure yet'),
                    value: _helpsGoalNotSure,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _helpsGoalNotSure = newValue!;
                        if (newValue) {
                          _helpsGoalYes = false;
                          _helpsGoalNo = false;
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // "Comment (Optional)" Section
              const Text(
                'Comment (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                maxLines: 5, // Allow multiple lines for comments
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle submit button press
                      print(
                        'Rating: ${_selectedRating != null ? _ratings[_selectedRating!]['description'] : 'Not rated'}',
                      );
                      print(
                        'Helps Goal: Yes: $_helpsGoalYes, No: $_helpsGoalNo, Not sure: $_helpsGoalNotSure',
                      );
                      print('Comment: ${_commentController.text}');
                      // You would typically send this data to a backend service here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Feedback Submitted! (console logged)'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(
                            context,
                          ).colorScheme.secondary, // Orange/yellow color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Rounded corners
                      ),
                      elevation: 3, // Slight shadow for the button
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
