//
//  StartViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/15.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let Title = UILabel()
        Title.text="Shopping"
        self.centerLabel(width:100,Title)
        
        let SubTitle = UILabel()
        SubTitle.text = "ログインして買い物をしよう"
        self.centerLabel(width: 300,position:350, SubTitle)
        
    }

 
    func centerLabel(width:Int,position:Int=250,_ Label :UILabel){
        Label.frame = CGRect(x:(Int(self.view.bounds.width)-width)/2,y:position,width:width,height:50)
        Label.textColor = UIColor.black
        Label.backgroundColor = UIColor.lightGray
        Label.textAlignment = .center
        view.addSubview(Label)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
