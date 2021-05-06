//
//  ProductManager.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import Foundation
import UIKit

struct ProductManager {
    
    func fetchProduct(onCompletion: @escaping ([Products]) -> () ){
        let url = URL(string: "https://fakestoreapi.com/products")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            do{
                let productList = try decoder.decode([Products].self, from: data)
                onCompletion(productList)
            }catch {
                let error = error
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
