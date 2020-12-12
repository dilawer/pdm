//
//  Video.swift
//
//  Created by Dilawer Hussain on 12/10/20.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

import UIKit

let kcategory_name = "category_name"
let kcategory_icon = "category_icon"

class Category{

    var categoryId: String
    var category_name: String
    var category_icon : String
    var created_at: String
    var updated_at: String
    
    // MARK: init methods
    init() {
        self.categoryId = ""
        self.category_name = ""
        self.category_icon = ""
        self.created_at = ""
        self.updated_at = ""
    }
    
    func setCategoryData(data : NSDictionary) {
        self.categoryId = "\(data[kId] ?? "")"
        self.category_name = data[kcategory_name] as? String ?? ""
        self.category_icon = "\(data[kcategory_icon] ?? "")"
        self.created_at = data[kcreated_at] as? String ?? ""
        self.updated_at = data[updated_at] as? String ?? ""
    }
}

