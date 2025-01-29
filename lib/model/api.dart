import 'package:http/http.dart' as http;

class Api {

  static Future<http.Response> getCountriesCases({String country = 'india'}) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    var uri = Uri.parse('https://disease.sh/v3/covid-19/countries/$country');
    try {
      var response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<dynamic> countryCovidList() async {
    Map<String, String> headers = {'Accept': 'application/json'};
    var uri = Uri.parse('https://coronavirus-19-api.herokuapp.com/countries');
    try {
      var response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> worldVaccineCases() async{
    Map<String, String> headers = {'Accept': 'application/json'};
    var uri = Uri.parse('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json');
    try {
      var response = await http.get(uri,headers: headers);
      return response;
    } catch (e) {
      return e;
    }
  }
  
}
