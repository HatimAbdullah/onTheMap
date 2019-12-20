//
//  API.swift
//  Map boy
//
//  Created by Fish on 14/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import Foundation

class API {

    private static var user = User()
    private static var token: String?
       
       static func login(username: String, password: String, completion: @escaping (String?)->Void) {
           
           var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
           let session = URLSession.shared
           let task = session.dataTask(with: request) { data, response, error in
               var error: String?
               if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                   if statusCode >= 200 && statusCode < 300 {
                       
                       let newData = data?.subdata(in: 5..<data!.count)
                       if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                           let book = json as? [String:Any],
                           let sessionDict = book["session"] as? [String: Any],
                           let accountDict = book["account"] as? [String: Any]  {
                           
                           self.user.key = accountDict["key"] as? String
                           self.token = sessionDict["id"] as? String
                    
                       } else {
                           error = "can't read what they said"
                       }
                   } else {
                       error = "you are lying"
                   }
               } else {
                   error = "i can't move"
               }
               DispatchQueue.main.async {
                   completion(error)
               }
               
           }
           task.resume()
       }
    
    static func logout(completion: @escaping (String?)->Void) {
    
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        task.resume()
    }
    
    static func getLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsList?)->Void) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=\(limit)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var studentLocations: [StudentLocation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode < 400 {
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let book = json as? [String:Any],
                        let results = book["results"] as? [Any] {
                        
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                            studentLocations.append(studentLocation)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(LocationsList(studentLocations: studentLocations))
            }
            
        }
        task.resume()
    }
    
    static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        guard let userID = user.key else {
            completion("not authorized")
            return
        }

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userID)\", \"firstName\": \"\(location.firstName ?? "John")\", \"lastName\": \"\(location.lastName ?? "Doe")\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var error: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 400 {
                    error = "can't talk"
                }
            } else {
                error = "can't move"
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
        task.resume()
    }
    
}
