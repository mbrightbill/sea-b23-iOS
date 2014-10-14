//
//  Filter.swift
//  PhotoFilters
//
//  Created by Bradley Johnson on 10/14/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var favorited: NSNumber

}
