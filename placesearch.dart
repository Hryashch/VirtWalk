import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchSearchResults(String query, String apiKey, String cx) async {
  final response = await http.get(Uri.parse('https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cx&q=$query'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    // Если запрос прошел успешно, декодируем ответ JSON
    Map<String, dynamic> data = jsonDecode(response.body);
    // Возвращаем результаты поиска
    print(data['items']);
    return data['items'];
  } else {
    // Если запрос не удался, выбрасываем исключение
    throw Exception('Failed to load search results');
  }
}