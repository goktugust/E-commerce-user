//
//  ProductManager.swift
//  E-commerce
//
//  Created by Göktuğ Üstüner on 29.04.2021.
//

import Foundation
import UIKit

struct ProductManager{
    let productUrl = "https://fakestoreapi.com/products"
    
    func fetchData(productID: Int) {
        let urlString = "\(productUrl)/\(String(productID))"
        performRequest(urlString: urlString)
    }
    
    func allData(){
        let url = "https://fakestoreapi.com/products"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseJSON(productData: safeData)
                }
            }
            task.resume()
            
        }
    }
    
    func parseJSON(productData: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Products].self, from: productData)
            
            for product in decodedData {
                 print(product.image)
                
            }
            
        }catch{
            print(error)
        }
        
    }
    
}


