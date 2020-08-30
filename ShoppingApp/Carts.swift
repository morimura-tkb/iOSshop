//
//  Carts.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/22.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import Foundation
import RealmSwift

class Carts:Object{
    @objc dynamic var id:Int = 0;
    @objc dynamic var product_id:Int = 0;
    @objc dynamic var number:Int = 0;
}

class MyCart{
    let user_id:Int
    let product_id:Int
    let number:Int
    let cart = Carts()
    let realm = try! Realm()
    
    init(user_id:Int){
        self.user_id = user_id
        self.product_id = 0
        self.number = 0
    }
    
    init(user_id:Int,product_id:Int,number:Int){
        self.user_id = user_id
        self.product_id = product_id
        self.number = number
    }
    
    func cart_add(){
        cart.id = 1;//user_id
        cart.product_id = product_id;
        cart.number = number;
        
        let count = realm.objects(Carts.self).filter("(id==%@)AND(product_id==%@)",user_id,product_id).count
        if(count > 0){
            cart_update()
        }else{
            do{
                try realm.write {
                    realm.add(cart)
                }
            }catch{
            }
        }
    }
    
    func cart_update(){
        let data = realm.objects(Carts.self).filter("(id==%@)AND(product_id==%@)",user_id,product_id).first
        try! realm.write {
            data?.number += number
        }
    }
    
    func delete(delete_id:Int){
        let data = realm.objects(Carts.self).filter("(id==%@)AND(product_id==%@)",user_id,delete_id)
        do{
            try realm.write {
              realm.delete(data)
            }
        }catch{
        }
    }
    
}

