import 'package:http/http.dart' as http;

class GithubApiHandler {
  final String _baseUrl = 'https://api.github.com';
  final String _token;

  GithubApiHandler(this._token);

  Future<http.Response> get(String path) async {
    return await http.get(Uri.parse('$_baseUrl$path'), headers: {
      'Authorization': 'Bearer $_token',
    });
  }

  Future<http.Response> post(String path, {required String body}) async {
    return await http.post(Uri.parse('$_baseUrl$path'), headers: {
      'Authorization': 'Bearer $_token',
    }, body: body);
  }

  Future<http.Response> patch(String path, {required String body}) async {
    return await http.patch(Uri.parse('$_baseUrl$path'), headers: {
      'Authorization': 'Bearer $_token',
    }, body: body);
  }

  Future<http.Response> delete(String path) async {
    return await http.delete(Uri.parse('$_baseUrl$path'), headers: {
      'Authorization': 'Bearer $_token',
    });
  }
}