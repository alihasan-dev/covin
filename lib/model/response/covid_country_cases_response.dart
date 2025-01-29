// To parse this JSON data, do
//
//     final covidCountryCasesResponse = covidCountryCasesResponseFromJson(jsonString);

import 'dart:convert';

CovidCountryCasesResponse covidCountryCasesResponseFromJson(String str) => CovidCountryCasesResponse.fromJson(json.decode(str));


class CountryInfo {
  final int? id;
  final String? iso2;
  final String? iso3;
  final double? lat;
  final double? long;
  final String? flag;

  CountryInfo({
    this.id,
    this.iso2,
    this.iso3,
    this.lat,
    this.long,
    this.flag,
  });

  factory CountryInfo.fromJson(Map<String, dynamic> json) => CountryInfo(
        id: json["_id"],
        iso2: json["iso2"],
        iso3: json["iso3"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        flag: json["flag"],
      );
}

class CovidCountryCasesResponse {
  final int? updated;
  final String? country;
  final CountryInfo? countryInfo;
  final int? cases;
  final int? todayCases;
  final int? deaths;
  final int? todayDeaths;
  final int? recovered;
  final int? todayRecovered;
  final int? active;
  final int? critical;
  final int? casesPerOneMillion;
  final int? deathsPerOneMillion;
  final int? tests;
  final int? testsPerOneMillion;
  final int? population;
  final String? continent;
  final int? oneCasePerPeople;
  final int? oneDeathPerPeople;
  final int? oneTestPerPeople;
  final double? activePerOneMillion;
  final int? recoveredPerOneMillion;
  final int? criticalPerOneMillion;

  CovidCountryCasesResponse({
    this.updated,
    this.country,
    this.countryInfo,
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
    this.casesPerOneMillion,
    this.deathsPerOneMillion,
    this.tests,
    this.testsPerOneMillion,
    this.population,
    this.continent,
    this.oneCasePerPeople,
    this.oneDeathPerPeople,
    this.oneTestPerPeople,
    this.activePerOneMillion,
    this.recoveredPerOneMillion,
    this.criticalPerOneMillion,
  });

  factory CovidCountryCasesResponse.fromJson(Map<String, dynamic> json) => CovidCountryCasesResponse(
        updated: json["updated"],
        country: json["country"],
        countryInfo: json["countryInfo"] == null
            ? null
            : CountryInfo.fromJson(json["countryInfo"]),
        cases: json["cases"],
        todayCases: json["todayCases"],
        deaths: json["deaths"],
        todayDeaths: json["todayDeaths"],
        recovered: json["recovered"],
        todayRecovered: json["todayRecovered"],
        active: json["active"],
        critical: json["critical"],
        casesPerOneMillion: json["casesPerOneMillion"],
        deathsPerOneMillion: json["deathsPerOneMillion"],
        tests: json["tests"],
        testsPerOneMillion: json["testsPerOneMillion"],
        population: json["population"],
        continent: json["continent"],
        oneCasePerPeople: json["oneCasePerPeople"],
        oneDeathPerPeople: json["oneDeathPerPeople"],
        oneTestPerPeople: json["oneTestPerPeople"],
        activePerOneMillion: json["activePerOneMillion"]?.toDouble(),
        recoveredPerOneMillion: json["recoveredPerOneMillion"],
        criticalPerOneMillion: json["criticalPerOneMillion"],
      );
}