//
//  NewsAPIClient.swift
//  News Lite
//
//  Created by Neel Nishant on 06/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit
class NewsAPIClient: NSObject{
    
    
    func taskForGETMethod(sourceId : String , completionHandler : @escaping (_ success: Bool, _ error: String?) -> Void){
        
        let urlString = "https://newsapi.org/v2/top-headlines?sources=\(sourceId)&apiKey=f137ba567de74e9f9166925b2e15bf21"
        print(urlString)
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(false, "Your API key is invalid or incorrect")
                return
            }
            guard let data = data else {
                completionHandler(false, "No data")
                return
            }
            let parsedResult : [String: AnyObject]
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
            }
            catch{
                completionHandler(false, "Unable to parse JSON data")
                return
            }
            
            guard let articles = parsedResult["articles"] as? [[String: AnyObject]] else {
                completionHandler(false, "no articles")
                return
            }
            for article in articles {
                var sourceName = ""
                var sourceId = ""
                if let source = article["source"] as? [String: AnyObject] {
                    sourceId = (source["id"] as? String)!
                    sourceName = (source["name"] as? String)!
                }
                let title = article["title"] as? String ?? ""
                let articleDescription = article["description"] as? String ?? ""
                let url = article["url"] as? String
                let urlToImage = article["urlToImage"] as? String ?? ""
//                print("sourceName = \(sourceName)")
//                print("title:\(title)")
//                print("desc:\(newsDescription)")
//                print("url:\(url)")
//                print("imageUrl:\(urlToImage)")
                
                let articleToCore = Article(sourceId: sourceId, sourceName: sourceName, title: title, articleDescription: articleDescription, url: url!, urlToImage: urlToImage, context: CoreDataStack.sharedInstance().context)
                if articleToCore != nil {
                    CoreDataStack.sharedInstance().context.insert(articleToCore)
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "postsLoaded"), object: nil))
                }
                else {
                    print("object nil found")
                }
                
                
                
                do {
                    try CoreDataStack.sharedInstance().saveContext()
                }
                catch {
                    print("erorrrrrrrr")
                }
                
            }
//            print("ParsedResult:\(parsedResult)")
            
            completionHandler(true, nil)
            
        }
        task.resume()
        
    }
    
    func getImageForCell(urlToImage: String, completionHandler: @escaping(_ image: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imgData = try? Data(contentsOf: URL(string: urlToImage)!) {
                if let image = UIImage(data: imgData) {
                    performUIUpdatesOnMain {
                        completionHandler(image)
                    }
                }
            }
        }
    }
    
    static let sharedInstance = NewsAPIClient()
    
//    override init() {
//        println("AAA");
//    }
//    class func sharedInstance() -> NewsAPIClient {
//        struct Singleton {
//            static var sharedInstance = NewsAPIClient()
//        }
//        return Singleton.sharedInstance
//    }
}
