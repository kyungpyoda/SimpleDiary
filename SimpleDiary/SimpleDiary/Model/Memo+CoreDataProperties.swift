//
//  Memo+CoreDataProperties.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/12.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?

}

extension Memo : Identifiable {

}
