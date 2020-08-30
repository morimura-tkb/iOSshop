//
//  Products.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/13.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import Foundation
import RealmSwift

class Products:Object{
    @objc dynamic var id:Int = 0;
    @objc dynamic var name:String = "";
    @objc dynamic var price:Int = 0;
    @objc dynamic var stock:Int = 0;
    @objc dynamic var imagename:String = "";
    @objc dynamic var explain:String = ""


    func open()->Results<Products>{
        let realm = try! Realm()
        let output:Results<Products> = realm.objects(Products.self)
        return output
    }
}
    
