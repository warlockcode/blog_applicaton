import 'dart:convert';
import 'package:blog_applicaton/blogsModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


Future<List<blogs>> fetchBlogs() async {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });
    print(response.body);

  return compute(parseBlogs, response.body);
  }

List<blogs> parseBlogs(String responseBody) {
  final data = jsonDecode(responseBody);

  final parsed =data['blogs'].cast<Map<String, dynamic>>();

  return parsed.map<blogs>((json) => blogs.fromJson(json)).toList();
}


