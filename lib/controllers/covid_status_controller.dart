import 'dart:developer';
import 'dart:isolate';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/response/faq_response.dart';
import '../model/response/vaccine_response.dart';
import '../model/api.dart';
import '../model/response/country_response.dart';
import '../model/response/covid_country_cases_response.dart';
import '../model/response/population_response.dart';

class CovidStatusProvider extends ChangeNotifier {
  bool _callApi = false;
  bool _countryApi = false;
  bool _worldVaccineApi = false;
  bool _vaccineApi = false;
  bool _bannerVisibility = false;
  bool _showSearchBar = false;
  bool _loadFAQ = true;
  bool get showBanner => _bannerVisibility;
  bool get apiCalling => _callApi;
  bool get apiCountry => _countryApi;
  bool get apiVaccine => _vaccineApi;
  bool get apiWorldVaccine => _worldVaccineApi;
  bool get showSearchBar => _showSearchBar;
  bool get loadFAQ => _loadFAQ;

  bool countrySearchTopVisible = false;
  bool faqFABVisible = false;

  fabVisibility() {
    faqFABVisible = faqFABVisible ? false : true;
    notifyListeners();
  }

  adMobVisibility(bool isVisible) {
    _bannerVisibility = isVisible;
    notifyListeners();
  }

  searchBarVisibility(bool isVisible) {
    _showSearchBar = isVisible;
    notifyListeners();
  }

  topVisiblility() {
    countrySearchTopVisible = countrySearchTopVisible ? false : true;
    notifyListeners();
  }

  String vcnResponse = '';
  int sites = 0;
  int sitesGovernment = 0;
  int sitesPrivate = 0;
  String stateVaccineUrl = '';
  late CovidCountryCasesResponse covidResponse;
  late PopulationResponse populationResponse;
  List<int> covidStatusResponse = [0, 0, 0, 0, 0, 0, 0, 0];
  List<CountryResponse> countryResponse = [];
  List<VaccinationResponse> worldVaccineResponse = [];
  List<VaccinationResponse> originalWorldVaccineResponse = [];
  List<CountryResponse> originalCountryResponse = [];
  List<FAQResponse> faqResponse = [];
  List<int> vaccineResponse = [0, 0, 0, 0];
  List<String> vaccineName = [];
  var firebase = FirebaseDatabase.instance;
  var firebaseDatabase = FirebaseDatabase.instance.ref().child('covid_info');

  Future<void> covidStatus(bool isIndicator) async {
    _callApi = isIndicator;
    notifyListeners();
    try {
      var response = await Api.getCountriesCases();
      if (response.statusCode == 200) {
        covidResponse = covidCountryCasesResponseFromJson(response.body);
        covidStatusResponse[0] = covidResponse.population ?? 0;
        covidStatusResponse[1] = covidResponse.cases ?? 0;
        covidStatusResponse[2] = covidResponse.active ?? 0;
        covidStatusResponse[3] = covidResponse.recovered ?? 0;
        covidStatusResponse[4] = covidResponse.deaths ?? 0;
        covidStatusResponse[5] = covidResponse.critical ?? 0;
        covidStatusResponse[6] = covidResponse.todayCases ?? 0;
        covidStatusResponse[7] = covidResponse.todayDeaths ?? 0;
      } else {
        covidStatusResponse = [0, 0, 0, 0, 0, 0, 0, 0];
      }
    } catch (e) {
      covidStatusResponse = [0, 0, 0, 0, 0, 0, 0, 0];
    }
    // await population();
    _callApi = false;
    notifyListeners();
  }

  Future<void> countryCases(bool isIndicator) async {
    _countryApi = isIndicator;
    notifyListeners();
    try {
      var response = await Api.countryCovidList();
      if (response.statusCode == 200) {
        countryResponse.clear();
        originalCountryResponse.clear();
        var temp = List<CountryResponse>.from(json.decode(response.body).map((x) => CountryResponse.fromJson(x)));
        countryResponse.addAll(temp);
        originalCountryResponse.addAll(temp);
        log(countryResponse.length.toString());
      } else {
        countryResponse = [];
      }
    } catch (e) {
      countryResponse = [];
    }
    _countryApi = false;
    notifyListeners();
  }

  Future<void> worldVaccineCases(bool isIndicator) async {
    _worldVaccineApi = isIndicator;
    notifyListeners();
    List<VaccinationResponse> data = [];
    if(kIsWeb){
      try {
        var response = await Api.worldVaccineCases();
        if (response.statusCode == 200) {
          var temp = List<VaccinationResponse>.from(json.decode(response.body).map((x) => VaccinationResponse.fromJson(x)));
          data = temp;
        }
      } catch (e) {
        log('Something went wrong');
      }
    }else{
      final port = ReceivePort();
      await Isolate.spawn(getVaccineData, port.sendPort);
      data = await port.first;
    }
    if(data.isNotEmpty){
      worldVaccineResponse.clear();
      originalWorldVaccineResponse.clear();
      worldVaccineResponse.addAll(data);
      originalWorldVaccineResponse.addAll(data);
    }else{
      worldVaccineResponse = [];
    }
    _worldVaccineApi = false;
    notifyListeners();
  }

  searchCountry(String input) {
    countryResponse.clear();
    if (input.isEmpty) {
      countryResponse.addAll(originalCountryResponse);
    } else {
      for (var i = 0; i < originalCountryResponse.length; i++) {
        if (originalCountryResponse[i]
            .country
            .toLowerCase()
            .contains(input.toLowerCase())) {
          countryResponse.add(originalCountryResponse[i]);
        }
      }
    }
    notifyListeners();
  }

  searchCountryVaccine(String input) {
    worldVaccineResponse.clear();
    if (input.isEmpty) {
      worldVaccineResponse.addAll(originalWorldVaccineResponse);
    } else {
      for (var i = 0; i < originalWorldVaccineResponse.length; i++) {
        if (originalWorldVaccineResponse[i]
            .country
            .toLowerCase()
            .contains(input.toLowerCase())) {
          worldVaccineResponse.add(originalWorldVaccineResponse[i]);
        }
      }
    }
    notifyListeners();
  }

  vaccineList() async {
    await firebaseDatabase.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        sites = data['sites'];
        sitesGovernment = data['government'];
        sitesPrivate = data['private'];
        vaccineName = data['vaccine'].split('-');
        stateVaccineUrl = data['stateVaccineUrl'];
        var strAr = data['vaccination'].split(' ');
        vaccineResponse[0] = int.parse(strAr[0]);
        vaccineResponse[1] = int.parse(strAr[1]);
        vaccineResponse[2] = int.parse(strAr[2]);
        vaccineResponse[3] = int.parse(strAr[3]);
      }
    });
  }

  population() async {
    await firebaseDatabase.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        covidStatusResponse[0] = data['population'];
        // var coronaCase = snapshot.value['corona'].split(' ');
        // covidStatusResponse[1] = int.parse(coronaCase[0]);
        // covidStatusResponse[2] = int.parse(coronaCase[1]);
        // covidStatusResponse[3] = int.parse(coronaCase[2]);
        // covidStatusResponse[4] = int.parse(coronaCase[3]);
        // covidStatusResponse[5] = int.parse(coronaCase[4]);
        // covidStatusResponse[6] = int.parse(coronaCase[5]);
        // covidStatusResponse[7] = int.parse(coronaCase[6]);
        // covidStatusResponse[8] = int.parse(coronaCase[7]);
      } else {
        covidStatusResponse[0] = 0;
      }
    });
  }

  // userCount(bool isOnline) async {
  //   var deviceId = "";
  //   if (Platform.isAndroid) {
  //     var deviceInfo = await DeviceInfoPlugin().androidInfo;
  //     deviceId = deviceInfo.androidId;
  //   } else {
  //     var deviceInfo = await DeviceInfoPlugin().iosInfo;
  //     deviceId = deviceInfo.identifierForVendor;
  //   }
  //   if (isOnline) {
  //     firebaseDatabase.child('Users').child(deviceId).set({'status': 'Online'});
  //   } else {
  //     firebaseDatabase
  //         .child('Users')
  //         .child(deviceId)
  //         .set({'status': 'Offline'});
  //   }
  // }

  Future<void> vaccination(bool isIndicator) async {
    _vaccineApi = isIndicator;
    notifyListeners();
    // try {
    //   if (vcnResponse.isEmpty)
    //     vcnResponse = await http.read(Uri.parse('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/country_data/India.csv'));
    //   vcnResponse = vcnResponse.split(',').reversed.join(',');
    //   var strAr = vcnResponse.split(',');
    //   vaccineResponse[1] = int.parse(strAr[2]);
    //   vaccineResponse[2] = int.parse(strAr[1]);
    //   vaccineResponse[3] = int.parse(strAr[0]);
    // } catch (e) {
    //   vaccineResponse = [0, 0, 0, 0];
    // }
    await vaccineList();
    _vaccineApi = false;
    notifyListeners();
  }

  Future<void> loadFAQData() async {
    _loadFAQ = true;
    notifyListeners();
    try {
      var data = await rootBundle.loadString('assets/jsonAsset/faqs.json');
      faqResponse = List<FAQResponse>.from(
          jsonDecode(data).map((x) => FAQResponse.fromJson(x)));
    } catch (e) {
      faqResponse = [];
    }
    _loadFAQ = false;
    notifyListeners();
  }
}
//#0B3054

Future getVaccineData(SendPort port) async {
  try {
    var response = await Api.worldVaccineCases();
    if (response.statusCode == 200) {
      var temp = List<VaccinationResponse>.from(json.decode(response.body).map((x) => VaccinationResponse.fromJson(x)));
      Isolate.exit(port, temp);
    } else {
      Isolate.exit(port, []);
    }
  } catch (e) {
    Isolate.exit(port, []);
  }
}
