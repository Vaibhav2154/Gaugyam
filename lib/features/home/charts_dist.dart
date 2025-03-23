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
      final uuid = user.id;
      final profileResponse =
          await supabase.from('profiles').select('id').eq('id', uuid).single();

      final userId = profileResponse['id'];
      final cattleResponse = await supabase
          .from('cattle')
          .select()
          .eq('uuid', userId);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cattle Statistics",
                style: TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.gradient1,
                ),
              ),
              SizedBox(height: 10),
              _buildSectionTitle("Male to Female Ratio"),
              _buildGenderDistributionChart(),
              _buildSectionTitle("Breed Ratio"),
              _buildBreedDistributionChart(),
              _buildSectionTitle("Age Distribution"),
              _buildAgeDistributionChart(),
            ],
          ),
        );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Calibre',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppPallete.gradient1,
        ),
      ),
    );
  }

  Widget _buildGenderDistributionChart() {
    final genderCounts = {'Male': 0, 'Female': 0};
    for (var cow in cowProfiles) {
      String gender = cow['gender'].toString().toLowerCase();
      if (gender == 'male' || gender == 'female') {
        String formattedGender = gender[0].toUpperCase() + gender.substring(1);
        genderCounts[formattedGender] =
            (genderCounts[formattedGender] ?? 0) + 1;
      }
    }
    int total = genderCounts['Male']! + genderCounts['Female']!;
    return _buildPieChart(
      "Gender Distribution",
      {'Male': genderCounts['Male']!, 'Female': genderCounts['Female']!},
      total,
      [Colors.blue, Colors.pink],
    );
  }

  Widget _buildBreedDistributionChart() {
    final Map<String, int> breedCounts = {};
    for (var cow in cowProfiles) {
      breedCounts[cow['breed']] = (breedCounts[cow['breed']] ?? 0) + 1;
    }
    int total = breedCounts.values.fold(0, (sum, val) => sum + val);
    return _buildPieChart(
      "Breed Distribution",
      breedCounts,
      total,
      Colors.primaries,
    );
  }

  Widget _buildPieChart(
    String title,
    Map<String, int> data,
    int total,
    List<Color> colors,
  ) {
    final sections =
        data.entries.map((entry) {
          double percentage = (entry.value / total) * 100;
          return PieChartSectionData(
            value: entry.value.toDouble(),
            color:
                colors[data.keys.toList().indexOf(entry.key) % colors.length],
            title: "${entry.key}\n${percentage.toStringAsFixed(1)}%",
            titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          );
        }).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPallete.gradient1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 40)),
    );
  }

  Widget _buildAgeDistributionChart() {
    final Map<int, int> ageCounts = {};
    for (var cow in cowProfiles) {
      int age = int.tryParse(cow['age'].toString()) ?? 0;
      ageCounts[age] = (ageCounts[age] ?? 0) + 1;
    }
    final bars =
        ageCounts.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: Colors.orange,
                width: 15,
              ),
            ],
          );
        }).toList();

    return Container(
      height: 250,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPallete.gradient1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BarChart(
        BarChartData(
          barGroups: bars,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text('${value.toInt()} yrs'),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${group.x} yrs: ${rod.toY.toInt()} cattle',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
