import 'package:http/http.dart' as http;

abstract class BaseRequest {
  String url;
  HttpMethod method;
  dynamic body;
  Map<String, String> headers;

  Future<http.Response> consturctAndExcuteRequest(
      {HttpMethod method,
      String endpoint,
      bool authenticated,
      Map<String,String> header,
      dynamic body}) async {
    await constructRequest(
        method: method,
        endpoint: endpoint,
        authenticated: authenticated,
        header: headers,
        body: body);
  }

  constructRequest(
      {HttpMethod method,
      String endpoint,
      bool authenticated,
      Map<String,String> header,
      dynamic body}) async {
    this.method = method;
    this.url = await getBaseUrl() + endpoint;
    this.body = body;
    await setRequestHeaders();
  }

  executeRequest() async {
    switch (method) {
      case HttpMethod.get:
        return http.get(Uri.parse(url), headers: headers);
      case HttpMethod.post:
        return http.post(Uri.parse(url), headers: headers, body: body);
      case HttpMethod.put:
        return http.put(Uri.parse(url), headers: headers, body: body);
      case HttpMethod.delete:
        return http.delete(Uri.parse(url), headers: headers);
    }
  }

  setRequestHeaders() async {
    headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
  }

  Future<String> getBaseUrl() async {
    return 'http://ec2-13-233-32-142.ap-south-1.compute.amazonaws.com/api';
  }
}

enum HttpMethod { get, post, put, delete }
