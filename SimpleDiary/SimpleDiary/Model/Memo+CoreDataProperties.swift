//
//  Memo+CoreDataProperties.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/16.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var state: String?

}

extension Memo : Identifiable {

}
