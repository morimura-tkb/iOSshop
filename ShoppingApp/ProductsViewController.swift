//
//  ProductsViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/15.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class ProductsViewController: UIViewController,UIScrollViewDelegate{

     let carts = Carts()
     let product = Products()
    
    //受け渡しのための値
    var number_value:Int = 1
    var number_list:[Int] = [0]
    var product_id_list:[Int] = [0]
    var list_count:Int!
    var product_view:[Int] = [0]//商品と何番目のViewかの関係
    
    
    @IBOutlet weak var main_scrollView: UIScrollView!
    @IBOutlet weak var main_content: UIView!
    var pageControl_list:[UIPageControl]!
    var pageControl_count:Int = 0
    var ViewCount:Int!
    var currentPage:[Int] = [0,0]
//    var product1_pageControl:UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商品一覧"
            //DBを全件取得
        let realm = try! Realm()
        let count = realm.objects(Products.self).count
        let output = product.open()
    
        list_count = 1//数量のカウントに必要
        ViewCount = 1//ビューのカウント初期化
        pageControl_list = []//初期化
        
        let main_scrollframe =  CGRect(x:0,y:0,width:view.frame.width,height:view.frame.height)
        main_scrollView.frame = main_scrollframe
        let main_contentRect = main_content.bounds
        main_scrollView.contentSize = CGSize(width:main_contentRect.width,height:main_contentRect.height)
        
        
        create_category(ViewCount:ViewCount)
        let product1_scrollView = create_scrollView(ViewCount: ViewCount)
        let product1_pageControl = create_pageControl(ViewCount: ViewCount)
        let product1_subView = createContentView(scrollView:product1_scrollView,contentList:output,count:count)
        product1_scrollView.addSubview(product1_subView)
        scroll_page(scrollView:product1_scrollView,pageControl:product1_pageControl,count:count,subView:product1_subView,ViewCount:ViewCount)
        ViewCount += 1//次のViewへ
        
        create_category(ViewCount:ViewCount)
        let product2_scrollView = create_scrollView(ViewCount: ViewCount)
        let product2_pageControl = create_pageControl(ViewCount: ViewCount)
        let product2_subView = createContentView(scrollView:product2_scrollView,contentList:output,count:count)
        product2_scrollView.addSubview(product2_subView)
        scroll_page(scrollView:product2_scrollView,pageControl:product2_pageControl,count:count,subView:product2_subView,ViewCount:ViewCount)
        ViewCount += 1//次のViewへ
        

        
        }
    //height450で固定、View_countは何個目のViewかを確認する(初めは1)
    func create_scrollView(ViewCount:Int)->UIScrollView{
        var scrollView:UIScrollView!
        let y = (ViewCount-1)*550 + 50
        scrollView = UIScrollView(frame: CGRect(x: 0, y:y , width: Int(self.view.frame.width), height: 450))
        return scrollView
    }
    
    func create_pageControl(ViewCount:Int)->UIPageControl{
        var pageControl: UIPageControl!
        let y = (ViewCount-1)*550 + 500
        pageControl = UIPageControl(frame: CGRect(x: 0, y: y, width: Int(self.view.frame.size.width), height: 30))
        pageControl_list.append(pageControl)
        pageControl_count += 1
        return pageControl
    }
    
    //カテゴリー名とそこをクリックするとcategory_productへ移動
    func create_category(ViewCount:Int){
        let width = Int(self.view.frame.width)
        let y = (ViewCount-1)*550
        let categoryLabel = UILabel(frame:CGRect(x:0,y:y,width:width,height:50))
        categoryLabel.text = "カテゴリー"
        categoryLabel.backgroundColor = UIColor.cyan
        let GoCategpryProduct = UIButton(frame:CGRect(x:0,y:y,width:width,height:50))
        GoCategpryProduct.addTarget(self, action:#selector(GotoCategoryProduct(_:)), for: UIControl.Event.touchUpInside)
        main_content.addSubview(GoCategpryProduct)
        main_content.addSubview(categoryLabel)
        
    }
    //ページ等の設定
    func scroll_page(scrollView:UIScrollView,pageControl:UIPageControl,count:Int,subView:UIView,ViewCount:Int){
        let current_page:Int = currentPage[ViewCount-1]//ViewCountは1からだから0からに直
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = subView.frame.size
        let x = current_page * Int(scrollView.frame.width)
        scrollView.contentOffset = CGPoint(x:x,y:0)//
        scrollView.delegate = self
        
        pageControl.numberOfPages = count
        pageControl.currentPage = current_page
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
        main_content.addSubview(scrollView)
        main_content.addSubview(pageControl)
    }
    
    //横スクロールの作成
    func createContentView(scrollView:UIScrollView,contentList:Results<Products>,count:Int)->UIView{
        let contentView = UIView()
        let pageWidth = self.view.frame.width
        let pageHeight = scrollView.frame.height
        let pageViewRect = CGRect(x:0,y:0,width:pageWidth,height:pageHeight)
        contentView.frame = CGRect(x:0,y:0,width:pageWidth*CGFloat(count),height:pageHeight)
        let photoSize = CGSize(width:250,height:250)
        
        for i in 0..<count{
            let contentItem = contentList[i]
            let pageView = createPage(viewRect:pageViewRect,imageSize:photoSize,item:contentItem)
            let left = pageViewRect.width * CGFloat(i)
            let xy = CGPoint(x:left,y:0)
            pageView.frame = CGRect(origin:xy,size:pageViewRect.size)
            pageView.backgroundColor = UIColor.lightGray
            contentView.addSubview(pageView)
        }
        return contentView
    }
    
    //横スクロール内の1ページの作成
    func createPage(viewRect:CGRect,imageSize:CGSize,item:Products)->UIView{
    let pageView = UIView(frame:viewRect)
        
    let GoA_Product = UIButton(frame:viewRect)
    GoA_Product.addTarget(self, action:#selector(GotoAProduct(_:)), for: UIControl.Event.touchUpInside)
    GoA_Product.tag = item.id
    
        
    
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
        let y = Int(numberValueLabelFrame.minY) + 2
        let minusButton = create_button(text:"-",x:Int(left)+50+5,y:y,color:UIColor.red,value:-1)
        minusButton.tag = -1*list_count
        let plusButton = create_button(text: "+", x: Int(left)+50+165,y:y, color: UIColor.blue, value: 1)
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
        return pageView
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

    @objc func GotoCategoryProduct(_ sender:UIButton){
      let CategoryProductVC = storyboard?.instantiateViewController(withIdentifier: "Category_Product") as! Category_ProductViewController
        CategoryProductVC.ok = "渡ったよ"
        self.navigationController?.pushViewController(CategoryProductVC, animated: true)
    }
 
    //スクロールされた時の設定
    func scrollViewDidScroll(_ scrollView:UIScrollView){
        let pageNo = Int(scrollView.contentOffset.x/scrollView.frame.width)
        let whichView = (scrollView.frame.minY-50)/550//ViewCount-1->pageControl_listの番号と関係している
        pageControl_list[Int(whichView)].currentPage = pageNo
        currentPage[Int(whichView)] = pageNo
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



    
    
}
