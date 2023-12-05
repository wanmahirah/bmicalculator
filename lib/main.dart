import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMI {
  final String fullname;
  final String height;
  final String weight;
  final String gender;

  BMI(this.fullname, this.height, this.weight, this.gender);
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BMIList(),
    );
  }
}

class BMIList extends StatefulWidget {
  @override
  _BMIListState createState() => _BMIListState();
}

class _BMIListState extends State<BMIList> {
  final List<BMI> bmiList = [];
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedGender;
  String bmiStatus = '';
  double bmiValue = 0.0;

  void _addBMI() {
    String fullname = fullnameController.text.trim();
    String height = heightController.text.trim();
    String weight = weightController.text.trim();

    if (fullname.isNotEmpty &&
        height.isNotEmpty &&
        weight.isNotEmpty &&
        selectedGender != null) {

      double heightInCM = double.parse(height);
      double weightInKG = double.parse(weight);

      // Calculate BMI value
      bmiValue = weightInKG / ((heightInCM / 100) * (heightInCM / 100));
      String status = calculateBMIStatus(bmiValue, selectedGender!);

      setState(() {
        bmiStatus = status;
        bmiList.add(BMI(fullname, height, weight, selectedGender!));
        fullnameController.clear();
        heightController.clear();
        weightController.clear();
      });
    }
  }

  String calculateBMIStatus(double bmi, String gender) {

    // Gender - Male
    if (gender == "Male") {
      if (bmi < 18.5) {
        return "Underweight. Careful during strong wind!";
      }
      else if (bmi >= 18.5 && bmi <= 24.9) {
        return "That’s ideal! Please maintain";
      }
      else if (bmi >= 25.0 && bmi <= 29.9) {
        return "Overweight! Work out please";
      }
      else {
        return "Whoa Obese! Dangerous mate!";
      }
    }

    // Gender - Female
    else {
      if (bmi < 16) {
        return "Underweight. Careful during strong wind!";
      }
      else if (bmi >= 16 && bmi <= 22) {
        return "That’s ideal! Please maintain";
      }
      else if (bmi > 22 && bmi <= 27) {
        return "Overweight! Work out please";
      }
      else {
        return "Whoa Obese! Dangerous mate!";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fullname TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: fullnameController,
                decoration: InputDecoration(
                  labelText: 'Your Fullname',
                ),
              ),
            ),

            // Height TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: heightController,
                onChanged: (_) => _updateBMIValue(),
                decoration: InputDecoration(
                  labelText: 'height in cm; 170',
                ),
              ),
            ),

            // Weight TextField
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: weightController,
                onChanged: (_) => _updateBMIValue(),
                decoration: InputDecoration(
                  labelText: 'Weight in KG',
                ),
              ),
            ),

            // Display calculated BMI
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: '$bmiValue'),
                decoration: InputDecoration(
                  labelText: 'BMI Value',
                ),
              ),
            ),

            // Select gender
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Male gender
                Radio(
                  value: "Male",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  },
                ),
                Text('Male'),

                // Female gender
                Radio(
                  value: "Female",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),

            ElevatedButton(
              onPressed: _addBMI,
              child: Text('Calculate BMI and Save'),
            ),

            SizedBox(height: 20),

            // Display BMI Status
            Text(
              '$selectedGender $bmiStatus',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBMIValue() {
    String height = heightController.text.trim();
    String weight = weightController.text.trim();

    if (height.isNotEmpty && weight.isNotEmpty) {
      double heightInCM = double.parse(height);
      double weightInKG = double.parse(weight);

      // Update BMI value
      setState(() {
        bmiValue = weightInKG / ((heightInCM / 100) * (heightInCM / 100));
      });
    }
  }
}