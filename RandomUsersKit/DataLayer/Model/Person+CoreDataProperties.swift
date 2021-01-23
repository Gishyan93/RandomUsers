//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Tigran Gishyan on 1/24/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var firstname: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var lastname: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var phone: String?
    @NSManaged public var picture: String?
    @NSManaged public var street: String?
    @NSManaged public var streetnumber: Int16

}
