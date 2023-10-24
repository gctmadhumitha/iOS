//
//  Fact.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.
//
//
// API :https://uselessfacts.jsph.pl/api/v2/facts/random
//
/*
    {
        id: "017e12a12972b700a050091e6e84130d",
        text: "Barbie's full name is Barbara Millicent Roberts.",
        source: "djtech.net",
        source_url: "http://www.djtech.net/humor/useless_facts.htm",
        language: "en",
        permalink: "https://uselessfacts.jsph.pl/api/v2/facts/017e12a12972b700a050091e6e84130d"
    }

*/

import UIKit
struct Fact : Decodable {
    private(set) var id : String
    private(set) var text : String
    private(set) var source : String
    private(set) var source_url : String
    private(set) var language: String
    private(set) var permalink : String
}
