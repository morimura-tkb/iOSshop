//
//  A_ProductViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/27.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class A_ProductViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    let carts = Carts()
    
    var product_id:Int = 0
    var number_value:Int = 1
    var pickerView: UIPickerView = UIPickerView()
    var list:[Int] = []
    var number = UITextField()
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "商品詳細"
        
        let realm = try! Realm()
        let product = realm.objects(Products.self).filter("id == %@",product_id).first!
        if(product.stock != 0){
            for i in 1 ... product.stock{
                if(i==100){
                    break
                }
                list.append(i)
            }
        }
        let View = create_product(product: product)
        self.view.addSubview(View)
        
    }
    
    func create_product(product:Products)->UIView{
        let ProductView = UIView(frame:CGRect(x:25,y:75,width:self.view.frame.width-50,height:self.view.frame.height-50))
        ProductView.backgroundColor = UIColor.lightGray
       
        let photoViewSize = CGSize(width:250,height:250)
        let left = (ProductView.frame.width - photoViewSize.width)/2
        
        let name = UILabel(frame:CGRect(x:left,y:10,width:100,height:21))
        name.text = product.name
        let photoView = UIImageView(frame:CGRect(x:left,y:name.frame.maxY+10,width:photoViewSize.width,height:photoViewSize.height))
        photoView.contentMode = .scaleAspectFit
        photoView.image = UIImage(named:product.imagename)
        photoView.clipsToBounds = true
        
        let price = UILabel(frame:CGRect(x:left,y:photoView.frame.maxY+10,width:2500,height:21))
        price.text = String(product.price)+"円"
        //数量
        let numberLabel = UILabel(frame:CGRect(x:left,y:price.frame.maxY+10,width:50,height:31))
        numberLabel.text = "数量:"
        let numberFrame = CGRect(x:left+50,y:price.frame.maxY+10,width:100,height:31)
        create_number(ProductView:ProductView,frame:numberFrame)
        
        //カートボタン
        let cart_add = UIButton(frame:CGRect(x:left,y:numberFrame.maxY+10,width:250,height:30))
        cart_add.layer.cornerRadius = 10
        cart_add.backgroundColor = UIColor.orange
        cart_add.setTitle("カートに入れる", for:.normal)
//        cart_add.setTitleColor(UIColor.white, for:.normal)
        cart_add.addTarget(self, action:#selector(add(_:)), for: UIControl.Event.touchUpInside)
        
        let explain = UILabel(frame:CGRect(x:left,y:cart_add.frame.maxY+10,width:0,height:0))
        explain.text = product.explain
        explain.lineBreakMode = .byWordWrapping
        explain.numberOfLines = 0
        explain.sizeToFit()
        
        if(explain.frame.maxY+10<self.view.frame.height-50){
            ProductView.frame.size = CGSize(width:self.view.frame.width-50,height:explain.frame.maxY+10)
        }
  
        ProductView.addSubview(name)
        ProductView.addSubview(photoView)
        ProductView.addSubview(price)
        ProductView.addSubview(numberLabel)
        ProductView.addSubview(cart_add)
        ProductView.addSubview(explain)

        return ProductView
    }
    
     @objc func add(_ sender:UIButton){
        let Cart = MyCart(user_id:1,product_id:product_id,number:number_value)
        Cart.cart_add()
        number_value = 1
        self.viewDidLoad()
       }
    
    func create_number(ProductView:UIView,frame:CGRect){
        number.frame = frame
        number.layer.borderColor = UIColor.black.cgColor
        number.layer.borderWidth = 1.0
        number.text = String(number_value)
        number.textAlignment = NSTextAlignment.center
        ProductView.addSubview(number)
        
        pickerView.delegate = self
        pickerView.dataSource = self

        let toolbar = UIToolbar(frame: CGRect(x:0,y:0,width:0,height:35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        self.number.inputView = pickerView
        self.number.inputAccessoryView = toolbar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(list[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.number.text = String(list[row])
        number_value = list[row]
    }

    @objc func cancel() {
        self.number.text = String(number_value)
        self.number.endEditing(true)
    }

    @objc func done() {
        self.number.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}
