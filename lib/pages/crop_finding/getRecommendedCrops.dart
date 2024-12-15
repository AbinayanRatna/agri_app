import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> getRecommendedCrops(List<double> inputFeatures) async {
  final url = Uri.parse('http://10.0.2.2:5000/recommend'); // Update with the server's actual URL
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'features': inputFeatures}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List<String>.from(data['recommended_crops']);
  } else {
    throw Exception('Failed to fetch recommendations: ${response.body}');
  }
}
