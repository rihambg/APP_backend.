import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:sugarblood/models/activity_model.dart';
import 'package:sugarblood/models/blood_sugar_model.dart';
import 'package:sugarblood/models/meal_model.dart';
import 'package:sugarblood/models/medication_model.dart';
import 'package:sugarblood/pages/community_and_chat_page.dart';
import 'package:sugarblood/pages/doctor_listing_page.dart';
import 'package:sugarblood/services/api_service.dart';

class DiabetesMedicationPage extends StatefulWidget {
  const DiabetesMedicationPage({Key? key}) : super(key: key);

  @override
  _DiabetesMedicationPageState createState() => _DiabetesMedicationPageState();
}

class _DiabetesMedicationPageState extends State<DiabetesMedicationPage> {
  late Future<List<BloodSugarReading>> _bloodSugarFuture;
  late Future<List<Medication>> _medicationsFuture;
  late Future<List<ActivityLog>> _activitiesFuture;
  late Future<List<MealLog>> _mealsFuture;
  late Future<Map<String, dynamic>> _patientDetailsFuture;

  @override
  void initState() {
    super.initState();
    _bloodSugarFuture = ApiService.fetchBloodSugar();
    _medicationsFuture = ApiService.fetchMedications();
    _activitiesFuture = ApiService.fetchActivities();
    _mealsFuture = ApiService.fetchMeals();
    _patientDetailsFuture = ApiService.fetchPatientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Diabetes & Health Overview',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildActionRow(),
                const SizedBox(height: 12),
                _buildQuickStatsRow(),
                const SizedBox(height: 16),
                _buildBloodSugarCard(),
                const SizedBox(height: 16),
                _buildActivityCard(),
                const SizedBox(height: 16),
                _buildMedicationCard(),
                const SizedBox(height: 16),
                _buildMealCard(),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _patientDetailsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final patient = snapshot.data!;
        final diabetesType = patient['diabetes_type'] ?? 'Unknown';

        Map<String, dynamic> targetRanges = {
          'type1': {'min': 80, 'max': 130, 'postprandialMax': 180},
          'type2': {'min': 80, 'max': 130, 'postprandialMax': 180},
          'prediabetes': {'min': 70, 'max': 130, 'postprandialMax': 140},
          'gestational': {'min': 70, 'max': 95, 'postprandialMax': 140},
          'Unknown': {'min': 70, 'max': 140, 'postprandialMax': 180},
        };

        final range = targetRanges[diabetesType] ?? targetRanges['Unknown'];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Ranges for ${diabetesType.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRangeIndicator(
                        'Fasting', '${range['min']}-${range['max']} mg/dL'),
                    _buildRangeIndicator('After Meals',
                        'Below ${range['postprandialMax']} mg/dL'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRangeIndicator(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          'Log Blood Sugar',
          Icons.monitor_heart,
          Colors.blue,
          () => _showBloodSugarDialog(),
        ),
        _buildActionButton(
          'Log Activity',
          Icons.directions_run,
          Colors.green,
          () => _showActivityDialog(),
        ),
        _buildActionButton(
          'Log Meal',
          Icons.restaurant,
          Colors.orange,
          () => _showMealDialog(),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _showBloodSugarDialog() {
    TextEditingController valueController = TextEditingController();
    String readingType = 'fasting';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Blood Sugar Reading'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Blood Sugar (mg/dL)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: readingType,
                items: const [
                  DropdownMenuItem(value: 'fasting', child: Text('Fasting')),
                  DropdownMenuItem(
                      value: 'postprandial', child: Text('After Meal')),
                  DropdownMenuItem(value: 'random', child: Text('Random')),
                ],
                onChanged: (value) => readingType = value!,
                decoration: const InputDecoration(
                  labelText: 'Reading Type',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (valueController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Reading logged successfully')),
                  );
                  setState(() {
                    _bloodSugarFuture = ApiService.fetchBloodSugar();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showActivityDialog() {
    TextEditingController stepsController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    String activityType = 'walking';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Physical Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: activityType,
                items: const [
                  DropdownMenuItem(value: 'walking', child: Text('Walking')),
                  DropdownMenuItem(value: 'running', child: Text('Running')),
                  DropdownMenuItem(value: 'cycling', child: Text('Cycling')),
                  DropdownMenuItem(value: 'swimming', child: Text('Swimming')),
                  DropdownMenuItem(value: 'workout', child: Text('Workout')),
                ],
                onChanged: (value) => activityType = value!,
                decoration: const InputDecoration(
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Steps (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (durationController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Activity logged successfully')),
                  );
                  setState(() {
                    _activitiesFuture = ApiService.fetchActivities();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showMealDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select a recipe or enter custom meal:'),
                const SizedBox(height: 16),
                FutureBuilder<List<MealRecipe>>(
                  future: ApiService.fetchRecipes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No recipes found');
                    }
                    return Column(
                      children: snapshot.data!
                          .map((recipe) => ListTile(
                                leading: recipe.imagePath != null
                                    ? Image.network(recipe.imagePath!)
                                    : const Icon(Icons.fastfood),
                                title: Text(recipe.title),
                                subtitle: Text('${recipe.calories} kcal'),
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Meal logged successfully')),
                                  );
                                  setState(() {
                                    _mealsFuture = ApiService.fetchMeals();
                                  });
                                },
                              ))
                          .toList(),
                    );
                  },
                ),
                const Divider(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCustomMealDialog();
                  },
                  child: const Text('Enter Custom Meal'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCustomMealDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController caloriesController = TextEditingController();
    TextEditingController carbsController = TextEditingController();
    String mealType = 'breakfast';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Custom Meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Meal Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: mealType,
                items: const [
                  DropdownMenuItem(
                      value: 'breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
                  DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
                  DropdownMenuItem(value: 'snack', child: Text('Snack')),
                ],
                onChanged: (value) => mealType = value!,
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    caloriesController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meal logged successfully')),
                  );
                  setState(() {
                    _mealsFuture = ApiService.fetchMeals();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBloodSugarCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_heart, size: 18),
                SizedBox(width: 8),
                Text('Blood Sugar Trends',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<BloodSugarReading>>(
                future: _bloodSugarFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final data = snapshot.data!;
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt());
                              return Text(DateFormat('HH:mm').format(date));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString());
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      minY: 50,
                      maxY: 300,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              .map((e) => FlSpot(
                                    e.date.millisecondsSinceEpoch.toDouble(),
                                    e.value.toDouble(),
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          belowBarData: BarAreaData(
                              show: true, color: Colors.blue.withOpacity(0.1)),
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<BloodSugarReading>>(
              future: _bloodSugarFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No readings yet');
                }
                final readings = snapshot.data!.take(3).toList();
                return Column(
                  children: readings
                      .map((reading) => ListTile(
                            leading: _getReadingIcon(
                                reading.value, reading.readingType),
                            title: Text('${reading.value} mg/dL'),
                            subtitle: Text(
                                '${reading.readingType} - ${DateFormat('MMM d, HH:mm').format(reading.date)}'),
                            trailing: Text(_getReadingStatus(
                                reading.value, reading.readingType)),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReadingIcon(double value, String readingType) {
    double min = 70;
    double max = readingType == 'postprandial' ? 180 : 130;

    if (value < min) {
      return const Icon(Icons.warning, color: Colors.orange);
    } else if (value > max) {
      return const Icon(Icons.warning, color: Colors.red);
    } else {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
  }

  String _getReadingStatus(double value, String readingType) {
    double min = 70;
    double max = readingType == 'postprandial' ? 180 : 130;

    if (value < min) {
      return 'Low';
    } else if (value > max) {
      return 'High';
    } else {
      return 'Normal';
    }
  }

  Widget _buildActivityCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.directions_run, size: 18),
                SizedBox(width: 8),
                Text('Activity Summary',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<ActivityLog>>(
              future: _activitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(child: Text('No activities logged yet'));
                }

                int totalSteps =
                    data.fold(0, (sum, item) => sum + (item.steps ?? 0));
                double totalCalories =
                    data.fold(0, (sum, item) => sum + item.calories);
                int totalMinutes =
                    data.fold(0, (sum, item) => sum + item.durationMinutes);

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActivityStat('Steps', '$totalSteps'),
                        _buildActivityStat('Calories', '$totalCalories'),
                        _buildActivityStat('Minutes', '$totalMinutes'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 150,
                      child: BarChart(
                        BarChartData(
                          barGroups: data
                              .take(7)
                              .map((e) => BarChartGroupData(
                                    x: data.indexOf(e),
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.calories.toDouble(),
                                        color: Colors.green,
                                        width: 16,
                                      ),
                                    ],
                                  ))
                              .toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < data.length) {
                                    return Text(DateFormat('MMM d')
                                        .format(data[value.toInt()].date));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString());
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medication, size: 18),
                SizedBox(width: 8),
                Text('Medication Schedule',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Medication>>(
              future: _medicationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final medications = snapshot.data!;
                if (medications.isEmpty) {
                  return const Center(child: Text('No medications scheduled'));
                }

                return Column(
                  children: [
                    ...medications.map((med) => ListTile(
                          leading: const Icon(Icons.medical_services),
                          title: Text(med.name),
                          subtitle: Text('${med.dosage} - ${med.time}'),
                          trailing: Switch(
                            value: med.status == 'taken',
                            onChanged: (value) {
                              setState(() {
                                _medicationsFuture =
                                    ApiService.fetchMedications();
                              });
                            },
                          ),
                        )),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showAddMedicationDialog();
                      },
                      child: const Text('Add Medication'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMedicationDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController dosageController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Medication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 08:00 AM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    dosageController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Medication added successfully')),
                  );
                  setState(() {
                    _medicationsFuture = ApiService.fetchMedications();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.restaurant, size: 18),
                SizedBox(width: 8),
                Text('Meal Log',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<MealLog>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final meals = snapshot.data!;
                if (meals.isEmpty) {
                  return const Center(child: Text('No meals logged yet'));
                }

                Map<String, List<MealLog>> mealsByDay = {};
                for (var meal in meals) {
                  String date = DateFormat('MMM d').format(meal.date);
                  if (!mealsByDay.containsKey(date)) {
                    mealsByDay[date] = [];
                  }
                  mealsByDay[date]!.add(meal);
                }

                return Column(
                  children: [
                    ...mealsByDay.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...entry.value.map((meal) => ListTile(
                                  leading: _getMealTypeIcon(meal.mealType),
                                  title: Text(meal.name),
                                  subtitle: Text(
                                      '${meal.calories} kcal, ${meal.carbs}g carbs'),
                                  trailing: Text(meal.mealType),
                                )),
                            const Divider(),
                          ],
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return const Icon(Icons.breakfast_dining, color: Colors.orange);
      case 'lunch':
        return const Icon(Icons.lunch_dining, color: Colors.green);
      case 'dinner':
        return const Icon(Icons.dinner_dining, color: Colors.blue);
      case 'snack':
        return const Icon(Icons.cookie, color: Colors.brown);
      default:
        return const Icon(Icons.fastfood);
    }
  }

  Widget _buildFloatingNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
              'assets/home.png', true, const DiabetesMedicationPage()),
          _buildNavItem(
              'assets/compass.png', false, const CommunityAndChatPage()),
          _buildNavItem(
              'assets/stethoscope.png', false, const DoctorListingPage()),
          _buildNavItem(
              'assets/people.png', false, const CommunityAndChatPage()),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, bool isSelected, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          imagePath,
          width: 24,
          height: 24,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
