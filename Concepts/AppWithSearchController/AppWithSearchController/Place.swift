//
//  Place.swift
//  AppWithSearchController
//
//  Created by Madhumitha Loganathan on 25/10/23.
//
//    {
//      capital: "Kabul",
//      code: "AF",
//      currency: {
//          code: "AFN",
//          name: "Afghan afghani",
//          symbol: "؋"
//       },
//      flag: "https://restcountries.eu/data/afg.svg",
//      language: {
//          code: "ps",
//          name: "Pashto"
//      },
//      name: "Afghanistan",
//      region: "AS"
//    }
    
//
//


import Foundation

struct Place : Codable, Equatable {
    var capital : String
    var code : String
    var flag: String
    var currency : Currency
    var language : Language
    var name: String
    var region: String
}

struct Currency : Codable, Equatable {
    var code : String
    var symbol: String?
    var name: String
}

struct Language : Codable, Equatable {
    var code : String?
    var name: String
}


