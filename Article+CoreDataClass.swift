//
//  Article+CoreDataClass.swift
//  News Lite
//
//  Created by Neel Nishant on 08/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Article)
public class Article: NSManagedObject {

    convenience init(sourceId: String, sourceName: String, title: String, articleDescription: String, url: String, urlToImage: String, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Article", in: context) {
            self.init(entity: entity, insertInto: context)
            self.sourceId = sourceId
            self.sourceName = sourceName
            self.title = title
            self.articleDescription = articleDescription
            self.url = url
            self.urlToImage = urlToImage
            
        }
        else {
            fatalError("unable to find entity name")
        }
    }
    
    var image: UIImage? {
        if imageData != nil {
            return UIImage(data: imageData! as Data)
        }
        return nil
    }
}
