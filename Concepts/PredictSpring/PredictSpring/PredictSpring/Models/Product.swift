//
//  Product.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import Foundation

struct Product: Codable, Identifiable {
    var productId: String
    var title: String
    var listPrice: Double
    var salesPrice: Double
    var color: String
    var size: String
    var id: String { productId}
}
