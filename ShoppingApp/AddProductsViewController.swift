//
//  ViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/13.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class AddProdcutsViewController: UIViewController{

 
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var Stock: UITextField!
    @IBOutlet weak var Photo: UITextField!
    @IBOutlet weak var explain: UITextField!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func Products_Register(_ sender: Any) {
        let product = Products()
        product.id = Int(ID.text!)!
        product.name = String(Name.text!)
        product.imagename = Photo.text!
        product.price = Int(Price.text!)!
        product.stock = Int(Stock.text!)!
        product.explain = String(explain.text!)
        self.save(product)
        ID.text = ""
        Name.text = ""
        Price.text = ""
        Stock.text = ""
        Photo.text = ""
        explain.text = ""
    }

    @IBAction func deleteAll(_ sender: Any) {
        do {
          let realm = try! Realm()
          try realm.write {
            realm.deleteAll()
          }
        } catch {

        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Price.keyboardType = UIKeyboardType.numberPad
        self.Stock.keyboardType = UIKeyboardType.numberPad
//        let cart = Carts()
//        cart.cart_add(product_id:2,number:3)
    }

    
    func save(_ product:Object) {
      do {
        let realm = try! Realm()
        try realm.write {
          realm.add(product)
        }
      } catch {

      }
    }

    
    
}

