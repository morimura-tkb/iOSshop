//
//  Category_ProductViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/27.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class Category_ProductViewController: UIViewController,UIScrollViewDelegate {
    let carts = Carts()
    let product = Products()
    var ok:String = ""
   //受け渡しのための値
    var number_value:Int = 1
    var number_list:[Int] = [0]
    var product_id_list:[Int] = [0]
    var list_count:Int!
    var product_view:[Int] = [0]//商品と何番目のViewかの関係
    
    let max = 2
    var nowpage = 1
   
    @IBOutlet weak var main_scrollView: UIScrollView!
    @IBOutlet weak var main_content: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商品カテゴリー"
        
        let realm = try! Realm()
        let count = realm.objects(Products.self).count
        let output = product.open()
        
        list_count = 1
        
        let main_scrollframe = CGRect(x:0,y:0,width:view.frame.width,height:view.frame.height)
        main_scrollView.frame = main_scrollframe
        let main_contentRect = main_content.bounds
        main_scrollView.contentSize = CGSize(width:main_contentRect.width,height:main_contentRect.height)
        
        if(count>=1){
                   //paging
                   var last = count%max//最後のページの表示数
                   if(last==0){//最後のページが0だとそもそも表示しないから最後もmaxにする
                       last = max
                   }
                   let page = ceil(Double(count)/Double(max))//ページ数
                   var product_content = max//1ページの商品数
                   if(nowpage == Int(page)){//最後のページは商品数をlastにする
                   product_content = last
                   }
                   
                   createPage(main_content:main_content,nowpage:nowpage,last:product_content, output:output)
            
                   for j in 1...Int(page){
                    let PageButton = UIButton(frame:CGRect(x:20+(j-1)*(21+5),y:product_content*420,width:21,height:21))
                       if(nowpage == j){
                       PageButton.backgroundColor = UIColor.blue
                       }else{
                       PageButton.backgroundColor = UIColor.lightGray
                       }
                       PageButton.setTitle(String(j), for: .normal)
                       PageButton.tag = j
                       PageButton.addTarget(self, action:#selector(ChangePage(_:)), for: UIControl.Event.touchUpInside)
                       main_content.addSubview(PageButton)
                   }
               }else{
            let nothingLabel = UILabel(frame:CGRect(x:20,y:85,width:self.view.frame.width,height:21))
                   nothingLabel.text = "カートに商品はありません。"
                  main_content.addSubview(nothingLabel)
               }

    }
    
    func createPage(main_content:UIView,nowpage:Int,last:Int,output:Results<Products>){
        for i in 0..<last{
            let y = i*420
            let item = output[(nowpage-1)*max+i]
            let viewRect = CGRect(x:0,y:y,width:Int(view.frame.width),height:400)
            let pageView = UIView(frame:viewRect)
            pageView.backgroundColor = UIColor.lightGray
            let imageSize = CGSize(width:250,height:250)
               
           let GoA_Product = UIButton(frame:viewRect)
            if(i==last-1){
           GoA_Product.backgroundColor = UIColor.red
            }
           GoA_Product.tag = item.id
           GoA_Product.addTarget(self, action:#selector(GotoAProduct(_:)), for: UIControl.Event.touchUpInside)

           let photoView = UIImageView()
           let left = (pageView.frame.width - imageSize.width)/2
           photoView.frame = CGRect(x:left,y:10,width:imageSize.width,height:imageSize.height)
           photoView.contentMode = .scaleAspectFit
           photoView.image = UIImage(named:item.imagename)
           photoView.clipsToBounds = true
           let nameFrame = CGRect(x:left,y:photoView.frame.maxY+10,width:250,height:21)
           let priceFrame = CGRect(x:left,y:nameFrame.maxY+10,width:250,height:21)
           let numberFrame = CGRect(x:left,y:priceFrame.maxY+10,width:50,height:21)
           let cart_addFrame = CGRect(x:left,y:numberFrame.maxY+10,width:250,height:21)
           let nameLabel = UILabel(frame:nameFrame)
           nameLabel.text = item.name
           let priceLabel = UILabel(frame:priceFrame)
           priceLabel.text = String(item.price) + "円"
           
           let cart_add = UIButton()
                cart_add.frame = cart_addFrame
           cart_add.backgroundColor = UIColor.orange
           cart_add.layer.cornerRadius = 10
           cart_add.setTitle("カートに入れる",for:.normal)
           cart_add.tag = list_count
           cart_add.addTarget(self, action:#selector(add(_:)), for: UIControl.Event.touchUpInside)
           
           //数量
           number_list.append(number_value)
           product_id_list.append(item.id)
           let numberLabel = UILabel(frame:numberFrame)
                  numberLabel.text = "数量:"
           let numberValueLabelFrame = CGRect(x:left+50,y:numberFrame.minY,width:200,height:21)
           let numberValueLabel = UILabel(frame:numberValueLabelFrame)
           numberValueLabel.text = String(number_list[list_count])
           numberValueLabel.layer.borderColor = UIColor.black.cgColor
           numberValueLabel.layer.borderWidth = 1.0
           numberValueLabel.textAlignment = NSTextAlignment.center
           let num_y = Int(numberValueLabelFrame.minY) + 2
           let minusButton = create_button(text:"-",x:Int(left)+50+5,y:num_y,color:UIColor.red,value:-1)
           minusButton.tag = -1*list_count
           let plusButton = create_button(text: "+", x: Int(left)+50+165,y:num_y, color: UIColor.blue, value: 1)
           plusButton.tag = list_count
           list_count += 1

           pageView.addSubview(GoA_Product)
           pageView.addSubview(photoView)
           pageView.addSubview(nameLabel)
           pageView.addSubview(numberLabel)
           pageView.addSubview(numberValueLabel)
           pageView.addSubview(minusButton)
           pageView.addSubview(plusButton)
           pageView.addSubview(priceLabel)
           pageView.addSubview(cart_add)
           main_content.addSubview(pageView)
        }
       }
       
        func create_button(text:String,x:Int,y:Int,color:UIColor,value:Int)->UIButton{
           let numberButton = UIButton(frame:CGRect(x:x,y:y,width:30,height:17))
           numberButton.layer.borderColor = UIColor.black.cgColor
           numberButton.layer.borderWidth = 1.0
           numberButton.layer.cornerRadius = 5
           numberButton.setTitle(text, for:.normal)
           numberButton.backgroundColor = color
           numberButton.tag = value
           numberButton.addTarget(self, action: #selector(change_number(_:)), for: UIControl.Event.touchUpInside)
           return numberButton
       }
    
    @objc func add(_ sender:UIButton){
        let count = sender.tag
        let add_number = number_list[count]
        let product_id = product_id_list[count]
        let Cart = MyCart(user_id:1,product_id:product_id,number:add_number)
        Cart.cart_add()
        number_list[count] = 1
        self.loadView()
        self.viewDidLoad()
    }
    
    @objc func change_number(_ sender:UIButton){
        let change = sender.tag
        let abs_change = abs(change)
        number_list[abs_change] += change/abs_change
        self.loadView()
        self.viewDidLoad()
    }
    
    //A_Productへのproduct_idの受け渡し
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
    
    
}
