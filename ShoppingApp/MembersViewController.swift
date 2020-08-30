//
//  MembersViewController.swift
//  ShoppingApp
//
//  Created by 森村洸生 on 2020/06/15.
//  Copyright © 2020 森村洸生. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    let members = ["アカウントサービス","カート","注文履歴","ログアウト","設定"]
  
    @IBOutlet weak var MemberTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "会員情報"
        MemberTable.delegate = self
        MemberTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return members.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel!.text = members[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let targetViewController = self.storyboard!.instantiateViewController(withIdentifier: "memberInfo")
        self.present(targetViewController, animated: true, completion: nil)
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
