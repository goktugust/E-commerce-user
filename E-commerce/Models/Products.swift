//
//  Model.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//
import Foundation
 
struct Products: Decodable {
    let id: Int
    let title: String
    let price: Float
    let description: String
    let category: String
    let image: String
}
