//
//  BaseService.swift
//  CurrencyConverter
//
//  Created by Leon on 13/7/21.
//

import Foundation

class BaseService {
    let errorHandler = BaseErrorHandler()
    
    func queryEndPoint(endPoint: String, params: String, completion: @escaping (AnyObject?) -> Void) {
        
        let url = API.baseUrl + endPoint + "?" + ServicesConstants.accessKeyPath + API.accessKey + params
        var request: URLRequest?
        
        if let url = URL(string: url) {
            request = URLRequest(url: url)
        }
        
        request?.httpMethod = API.method.post

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let request = request {
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let _: Data = data, let _: URLResponse = response, error == nil else {
                    return
                }
                
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let dict = json as? NSDictionary {
                        if let status = dict.value(forKey: "success") as? Bool {
                            status ? completion(json as AnyObject) : self.errorHandler.serviceError()
                        }
                    } else {
                        self.errorHandler.displayError()
                        return
                    }
                }
            }
            task.resume()
        } else {
            //return url error
            print("request error")
        }
    }
}
