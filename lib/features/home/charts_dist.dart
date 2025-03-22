import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class CattleStatisticsWidget extends StatefulWidget {
  const CattleStatisticsWidget({super.key});

  @override
  State<CattleStatisticsWidget> createState() => _CattleStatisticsWidgetState();
}

class _CattleStatisticsWidgetState extends State<CattleStatisticsWidget> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> cowProfiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCowProfiles();
  }

  Future<void> fetchCowProfiles() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      final uuid = user.id; // Get current user's UUID

      // Step 1: Fetch user ID from the 'profiles' table
      final profileResponse =
          await supabase
              .from('profiles')
              .select('id')
              .eq('id', uuid)
              .single(); // Assuming 'uuid' is the correct column in 'profiles'

      // ignore: unnecessary_null_comparison
      if (profileResponse == null) {
        print('User profile not found');
        return;
      }

      final userId = profileResponse['id']; // Get the user's 'id' from profiles

      print(userId);
      // Step 2: Fetch cattle profiles where owner_id matches userId
      final cattleResponse = await supabase
          .from('cattle')
          .select()
          .eq('uuid', userId); // Match cattle profiles with user ID

      if (mounted) {
        setState(() {
          cowProfiles = cattleResponse;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cow profiles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : cowProfiles.isEmpty
        ? Center(child: Text('No cow profiles found.'))
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cattle Statistics",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Male to female ratio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                ),
              ),
              _buildGenderDistributionChart(),
              SizedBox(height: 30),
              Text(
                'Breed Ratio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                ),
              ),
              _buildBreedDistributionChart(),
              SizedBox(height: 30),
              Text(
                'Age Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                ),
              ),
              _buildAgeDistributionChart(),
            ],
          ),
        );
  }

  /// 📌 Gender Distribution Pie Chart
  Widget _buildGenderDistributionChart() {
    final genderCounts = {'Male': 0, 'Female': 0};
    for (var cow in cowProfiles) {
      genderCounts[cow['gender']] = (genderCounts[cow['gender']] ?? 0) + 1;
    }

    return _buildPieChart(
      title: "Gender Distribution",
      sections: [
        PieChartSectionData(
          value: genderCounts['Male']!.toDouble(),
          color: Colors.blue,
          title: "Male",
        ),
        PieChartSectionData(
          value: genderCounts['Female']!.toDouble(),
          color: Colors.pink,
          title: "Female",
        ),
      ],
    );
  }

  /// 📌 Breed Distribution Pie Chart
  Widget _buildBreedDistributionChart() {
    final Map<String, int> breedCounts = {};
    for (var cow in cowProfiles) {
      breedCounts[cow['breed']] = (breedCounts[cow['breed']] ?? 0) + 1;
    }

    final sections =
        breedCounts.entries
            .map(
              (entry) => PieChartSectionData(
                value: entry.value.toDouble(),
                color:
                    Colors.primaries[breedCounts.keys.toList().indexOf(
                          entry.key,
                        ) %
                        Colors.primaries.length],
                title: entry.key,
              ),
            )
            .toList();

    return _buildPieChart(title: "Breed Distribution", sections: sections);
  }

  /// 📌 Age Distribution Bar Chart
  Widget _buildAgeDistributionChart() {
    final Map<int, int> ageCounts = {};
    for (var cow in cowProfiles) {
      int age;
      try {
        age = int.parse(cow['age'].toString());
      } catch (e) {
        print('Error parsing age: ${cow['age']}');
        continue; // Skip this cow if age can't be parsed
      }
      ageCounts[age] = (ageCounts[age] ?? 0) + 1;
    }

    final bars =
        ageCounts.entries
            .map(
              (entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: Colors.orange,
                    width: 15,
                  ),
                ],
              ),
            )
            .toList();

    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "Age Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: bars,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, _) => Text('${value.toInt()} yrs'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 Reusable Pie Chart Widget
  Widget _buildPieChart({
    required String title,
    required List<PieChartSectionData> sections,
  }) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
