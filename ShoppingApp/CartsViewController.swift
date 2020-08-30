//
//  CartsViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/15.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class CartsViewController: UIViewController {

    
    var nowpage = 1//現在のページ
    let max = 4//1ページの最大表示数
    var refreshBarButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.title = "カート"
       refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        self.navigationItem.rightBarButtonItems = [refreshBarButton]
        
        
        let realm = try! Realm()
        let carts = realm.objects(Carts.self).filter("id==1")
        let count = carts.count

        if(count>=1){
            //paging
            var last = count%max//最後のページの表示数
            if(last==0){//最後のページが0だとそもそも表示しないから最後もmaxにする
                last = max
            }
            let page = ceil(Double(count)/Double(max))//ページ数
            var cart_content = max//1ページの商品数
            if(nowpage == Int(page)){//最後のページは商品数をlastにする
            cart_content = last
            }
            create_cart_product(count:cart_content, carts: carts)
            for j in 1...Int(page){
                let PageButton = UIButton(frame:CGRectMake(20+(j-1)*(21+5),cart_content*110+75,21,21))
                if(nowpage == j){
                PageButton.backgroundColor = UIColor.blue
                }else{
                PageButton.backgroundColor = UIColor.lightGray
                }
                PageButton.setTitle(String(j), for: .normal)
                PageButton.tag = j
                PageButton.addTarget(self, action:#selector(ChangePage(_:)), for: UIControl.Event.touchUpInside)
                self.view.addSubview(PageButton)
            }
            let purchase = UIButton(frame:CGRectMake(21, cart_content*110+75+21+20, Int(self.view.frame.width)-42,31))
            purchase.backgroundColor = UIColor.orange
            purchase.layer.cornerRadius = 10
            purchase.setTitle("購入する",for:.normal)
            purchase.addTarget(self, action:#selector(GoPurchase(_:)), for: UIControl.Event.touchUpInside)
            self.view.addSubview(purchase)
        }else{
            let nothingLabel = UILabel(frame:CGRectMake(20,85,Int(self.view.frame.width),21))
            nothingLabel.text = "カートに商品はありません。"
            self.view.addSubview(nothingLabel)
        }

    }
    
    func create_cart_product(count:Int,carts:Results<Carts>){
        let realm = try! Realm()
        for i in 0 ..< count{
            let id = carts[(nowpage-1)*max+i].product_id
            let product = realm.objects(Products.self).filter("id==%@",id).first
            let height:Int = 100
            let width = Int(self.view.frame.width)
            let View = UIView(frame:CGRectMake(0,i*(height+10)+75,width,height))
            View.backgroundColor = UIColor.lightGray
            let GoA_Product = UIButton(frame:CGRectMake(0,0,width,height))
            GoA_Product.tag = product!.id
            GoA_Product.addTarget(self, action:#selector(GotoAProduct(_:)), for: UIControl.Event.touchUpInside)

            
            
            let nameLabel = UILabel(frame:CGRectMake(20,10,width-20,21))
            nameLabel.text = "商品名: " + product!.name
            let numberLabel = UILabel(frame:CGRectMake(20, 31, width-20, 21))
            numberLabel.text = "個数: " + String(carts[i].number)
            let priceLabel = UILabel(frame:CGRectMake(20, 52, width-20, 21))
            priceLabel.text = "金額: " + String(product!.price) + "(円/1個)*" + String(carts[i].number) + "個数=" + String(product!.price*carts[i].number) + "円"
            let deleteButton = UIButton(frame:CGRectMake(20,73,80,21))
            deleteButton.backgroundColor = UIColor.white
            deleteButton.setTitle("削除", for: .normal)
            deleteButton.setTitleColor(UIColor.black, for: .normal)
            deleteButton.layer.cornerRadius = 6
            deleteButton.layer.borderColor = UIColor.black.cgColor
            deleteButton.layer.borderWidth = 1.0
            deleteButton.tag = product!.id
            deleteButton.addTarget(self, action: #selector(ProductDelete(_:)), for:UIControl.Event.touchUpInside)
            
            
            View.addSubview(GoA_Product)
            View.addSubview(nameLabel)
            View.addSubview(numberLabel)
            View.addSubview(priceLabel)
            View.addSubview(deleteButton)
            
            self.view.addSubview(View)
        }
    }
    
    func CGRectMake(_ x:Int,_ y:Int,_ width:Int,_ height:Int)->CGRect{
        return CGRect(x:x,y:y,width:width,height:height)
    }
    
    @objc func GotoAProduct(_ sender:UIButton){
      let A_ProductVC = storyboard?.instantiateViewController(withIdentifier: "A_Product") as! A_ProductViewController
        A_ProductVC.product_id = sender.tag
        self.navigationController?.pushViewController(A_ProductVC, animated: true)
    }
    
    @objc func ChangePage(_ sender:UIButton){
        nowpage = sender.tag
        self.loadView()
        self.viewDidLoad()
    }
    
    @objc func GoPurchase(_ sender:UIButton){
        let PurchaseVC = storyboard?.instantiateViewController(withIdentifier: "Purchase") as! PurchaseViewController
        PurchaseVC.ok = "渡ったよ"
        self.navigationController?.pushViewController(PurchaseVC, animated: true)
    }
    
     @objc func ProductDelete(_ sender:UIButton){
        let cart = MyCart(user_id:1)
        cart.delete(delete_id:sender.tag)
        self.loadView()
        self.viewDidLoad()
    }
    
    @objc func refresh(_ sender:UIBarButtonItem){
        self.loadView()
        self.viewDidLoad()
    }


}
