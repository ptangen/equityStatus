//
//  apiClient.swift
//  EquityStatus
//
//  Created by Paul Tangen on 12/19/16.
//  Copyright © 2016 Paul Tangen. All rights reserved.
//

import Foundation


//
//  CheftyAPIClient.swift
//  Chefty
//
//  Created by Paul Tangen on 11/17/16.
//  Copyright © 2016 com.AppRising.SML. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum AuthResponse {
    
    case authenticated
    case userNameInvalid
    case passwordInvalid
    case noReply
    
}

class apiClient {
    
    class func requestAuth(userName: String, password: String, completion: @escaping (AuthResponse) -> Void) {
        
        guard let userNameSubmitted = userName.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            completion(.userNameInvalid)
            return
        }
        
        guard let passwordSubmitted = password.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) else {
            completion(.passwordInvalid)
            return
        }
        
        let urlString = "\(Secrets.apiURL)auth.php"
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameterString = "userNameSubmitted=\(userNameSubmitted)&passwordSubmitted=\(passwordSubmitted)"
        request.httpBody = parameterString.data(using: .utf8)
       
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : String]
                let results = json["results"]
                
                if results == "authenticated" {
                
                    completion(.authenticated)
                    
                } else if results == "userNameInvalid" {
                    
                    completion(.userNameInvalid)
                    
                } else if results == "passwordInvalid" {
                    
                    completion(.passwordInvalid)
                    
                } else {
                    
                    completion(.noReply)
                    
                }
            }
        
        }).resume()
    }
    
}
