//
//  CHSMiMyBlacklistViewController.swift
//  ChallengeHighSalary
//
//  Created by zhang on 2016/9/28.
//  Copyright © 2016年 北京校酷网络科技公司. All rights reserved.
//

import UIKit

class CHSMiMyBlacklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView()
    
    var blackListDataArray = [BlackListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.loadData()
    }
    
    // MARK: - 加载数据
    func loadData() {
        
        PublicNetUtil().getBlackList(CHSUserInfo.currentUserInfo.userid, type: "1") { (success, response) in
            if success {
                self.blackListDataArray = response as! [BlackListData]
                self.rootTableView.reloadData()
            }
        }
        
    }
    
    // MARK: popViewcontroller
    func popViewcontroller() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_返回_white"), style: .done, target: self, action: #selector(popViewcontroller))
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "我的黑名单"
        
        // tableView
        rootTableView.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height-20-44)
        rootTableView.register(UINib.init(nibName: "CHSMiMyBlacklistTableViewCell", bundle: nil), forCellReuseIdentifier: "CHSMiMyBlacklistCell")
        rootTableView.rowHeight = 89
        rootTableView.dataSource = self
        rootTableView.delegate = self
        self.view.addSubview(rootTableView)
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blackListDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let blacks = self.blackListDataArray[indexPath.row].blacks?.first
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CHSMiMyBlacklistCell") as! CHSMiMyBlacklistTableViewCell
        cell.selectionStyle = .none
        
        cell.companyNameLab.text = blacks?.company_name
        cell.industryLab.text = ""
        cell.addressLab.text = blacks?.industry
        cell.cancelBlacklistBtn.addTarget(self, action: #selector(deleteBlackList), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: 取消黑名单
    func deleteBlackList(){
        let checkCodeHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        checkCodeHud.removeFromSuperViewOnHide = true
        
        PublicNetUtil().delBlackList(CHSUserInfo.currentUserInfo.userid, type: "1", blackid: "") { (success, response) in
            if success {
                checkCodeHud.mode = .text
                checkCodeHud.label.text = "取消黑名单成功"
                checkCodeHud.hide(animated: true, afterDelay: 1)
                self.loadData()
            }else{
                checkCodeHud.mode = .text
                checkCodeHud.label.text = "取消黑名单失败"
                checkCodeHud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
