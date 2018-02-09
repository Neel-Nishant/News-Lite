//
//  Article+CoreDataProperties.swift
//  News Lite
//
//  Created by Neel Nishant on 08/02/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var articleDescription: String?
    @NSManaged public var sourceId: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}
