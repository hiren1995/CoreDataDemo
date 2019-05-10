//
//  UserData+CoreDataProperties.swift
//  CoreData_Demo
//
//  Created by LogicalWings Mac on 25/10/18.
//  Copyright © 2018 LogicalWings Mac. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "Users")
    }

    @NSManaged public var age: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}
