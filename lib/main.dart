import 'package:flutter/material.dart';

// Main entry point of the app. This runs the app and sets the first screen (MyApp).
void main() => runApp(MyApp());

// Stateless widget for the overall structure of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build method creates the visual part of the app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Name of the app shown on the task manager.
      title: 'Counter App',
      theme: ThemeData(
        // Main color theme of the app.
        primarySwatch: Colors.blue,
      ),
      // The screen that opens when the app starts.
      home: CounterWidget(),
    );
  }
}

// This is the StatefulWidget, meaning it can change (or "hold state") when user interacts.
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

// This is where we manage the state (the data that can change) for the CounterWidget.
class _CounterWidgetState extends State<CounterWidget> {
  // This is where we store the current value of the counter.
  int _counter = 0;

  // This is the value by which the counter will increment.
  int _incrementValue = 1;

  // List to store the history of counter values.
  List<int> _counterHistory = [];

  // Controller for the text field where users can input custom increment values.
  final TextEditingController _incrementController = TextEditingController();

  // Function to increase the counter when the button is pressed.
  void _incrementCounter() {
    setState(() {
      // Only increase if the counter doesn't exceed 100.
      if (_counter + _incrementValue <= 100) {
        _counter += _incrementValue;
        _counterHistory.add(_counter); // Store the new value in history.
      }
    });
  }

  // Function to decrease the counter when the button is pressed.
  void _decrementCounter() {
    setState(() {
      // Only decrease if the counter is greater than 0.
      if (_counter > 0) {
        _counter -= _incrementValue;
        _counterHistory.add(_counter); // Store the new value in history.
      }
    });
  }

  // Function to reset the counter to 0.
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _counterHistory.add(_counter); // Add the reset value to history.
    });
  }

  // Function to undo the last counter change using the history.
  void _undo() {
    setState(() {
      if (_counterHistory.isNotEmpty) {
        // Remove the last value from the history.
        _counterHistory.removeLast();
        // Set the counter to the last value in the history or 0 if history is empty.
        _counter = _counterHistory.isNotEmpty ? _counterHistory.last : 0;
      }
    });
  }

  // Build method is where the UI (User Interface) is constructed.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold gives a structure to the page, like a layout template.
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      // Body is the main content of the screen.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically.
        children: [
          Center(
            child: Container(
              // Add a BoxDecoration to style the container with a circular shape and border.
              decoration: BoxDecoration(
                color: _counter == 0
                    ? Colors.red // Red when the counter is 0.
                    : _counter >= 50
                    ? Colors.green // Green when the counter is 50 or more.
                    : Colors.blue, // Blue for other values.
                shape: BoxShape.circle, // Makes the container circular.
              ),
              padding: const EdgeInsets.all(30.0), // Space around the text inside the circle.
              child: Text(
                '$_counter',
                // Change font size based on the counter value.
                style: TextStyle(
                  fontSize: 50.0 + (_counter.toDouble() * 0.5),
                  color: Colors.white, // Text color.
                ),
              ),
            ),
          ),

          // Slider to allow the user to manually change the counter value.
          Slider(
            min: 0, // Minimum value for the slider.
            max: 100, // Maximum value for the slider.
            value: _counter.toDouble(), // The current value of the counter.
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt(); // Update the counter with the slider value.
              });
            },
            activeColor: Colors.blue, // Color when the slider is active.
            inactiveColor: Colors.red, // Color when the slider is inactive.
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              // Text field for custom increment input.
              controller: _incrementController,
              keyboardType: TextInputType.number, // Makes the keyboard show numbers only.
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input Value', // Label for the text field.
              ),
              onChanged: (value) {
                setState(() {
                  // If the input is valid, use it. Otherwise, default to 1.
                  _incrementValue = int.tryParse(value) ?? 1;
                });
              },
            ),
          ),
          // Row of buttons to increase, decrease, or reset the counter.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly.
            children: [
              ElevatedButton(
                onPressed: _incrementCounter, // Button to increase the counter.
                child: const Text('Increment'),
              ),
              ElevatedButton(
                onPressed: _decrementCounter, // Button to decrease the counter.
                child: const Text('Decrement'),
              ),
              ElevatedButton(
                onPressed: _resetCounter, // Button to reset the counter.
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: _undo, // Button to undo the last action.
                child: const Text('Undo'),
              ),
            ],
          ),
          const SizedBox(height: 5), // Adds some space below the buttons.
          const Text('Counter History:'), // Label for the counter history.
          // Expanded widget allows the list to take up available space.
          Expanded(
            child: ListView.builder(
              itemCount: _counterHistory.length, // Number of items in the history.
              itemBuilder: (context, index) {
                // Builds each item in the history list.
                return ListTile(
                  title: Text('Value: ${_counterHistory[index]}'),
                );
              },
            ),
          ),
          // Show a message when the counter reaches 100.
          if (_counter == 100)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Limit reached!',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}
