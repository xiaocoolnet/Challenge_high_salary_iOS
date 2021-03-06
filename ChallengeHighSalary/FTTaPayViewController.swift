//
//  FTTaPayViewController.swift
//  ChallengeHighSalary
//
//  Created by 高扬 on 2017/1/13.
//  Copyright © 2017年 北京校酷网络科技公司. All rights reserved.
//

import UIKit

class FTTaPayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let rootTableView = UITableView()
    
    let nameArray = [["12个月 360元","6个月 200元","3个月 120元","单次购买 10元"],["支付宝支付","微信支付"]]
    let imageArray = [[nil,nil,nil,nil],[#imageLiteral(resourceName: "ic_支付宝"),#imageLiteral(resourceName: "ic_微信")]]
    var selectedArray = [[true,false,false,false],[true,false]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        //        self.rootTableView.reloadData()
        self.setHeaderView()
        self.loadData()
    }
    
    // MARK: 加载数据
    func loadData() {
        
        
    }
    
    // MARK: popViewcontroller
    func popViewcontroller() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- 设置子视图
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_返回_white"), style: .done, target: self, action: #selector(popViewcontroller))
        
        self.title = "支付确认"
        
        rootTableView.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: screenSize.height-64-44)
        rootTableView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        rootTableView.register(FTTaPayTableViewCell.self, forCellReuseIdentifier: "FTTaPayCell")
        
        rootTableView.rowHeight = 44
        rootTableView.dataSource = self
        rootTableView.delegate = self
        rootTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.addSubview(rootTableView)
        
        setHeaderView()
        
        let openingBtn = UIButton(frame: CGRect(x: 0, y: screenSize.height-44, width: screenSize.width, height: 44))
        openingBtn.backgroundColor = baseColor
        openingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        openingBtn.setTitleColor(UIColor.white, for: UIControlState())
        openingBtn.setTitle("立即开通", for: UIControlState())
        openingBtn.addTarget(self, action: #selector(openingBtnClick), for: .touchUpInside)
        self.view.addSubview(openingBtn)
    }
    
    // MARK: - 点击立即开通按钮
    func openingBtnClick() {
        print("点击立即开通按钮")
        
        for (i,selectedArr) in selectedArray.enumerated() {
            for (j,selected) in selectedArr.enumerated() {
                if selected {
                    print(nameArray[i][j])
                }
            }
        }
    }
    
    // MARK:- 设置tableview 头视图
    func setHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
        headerView.backgroundColor = UIColor.white
        
        let headerImg = UIImageView(frame: CGRect(x: 10, y: 0, width: 50, height: 50))
        headerImg.image = UIImage(named: "")
        headerImg.backgroundColor = baseColor
        headerImg.layer.cornerRadius = 25
        headerImg.clipsToBounds = true
        headerView.addSubview(headerImg)
        
        let nameLab = UILabel(frame: CGRect(x: headerImg.frame.maxX+10, y: 10, width: screenSize.width-(headerImg.frame.maxX+10)-10, height: UIFont.systemFont(ofSize: 16).lineHeight))
        nameLab.font = UIFont.systemFont(ofSize: 16)
        nameLab.textColor = UIColor.black
        nameLab.text = "北京校酷网络科技有限公司"
        headerView.addSubview(nameLab)
        
        let jobLab = UILabel(frame: CGRect(x: nameLab.frame.minX, y: nameLab.frame.maxY+8, width: screenSize.width-(nameLab.frame.minX)-10, height: UIFont.systemFont(ofSize: 14).lineHeight))
        jobLab.font = UIFont.systemFont(ofSize: 14)
        jobLab.textColor = UIColor.lightGray
        jobLab.text = "开通会员查看人才更多信息"
        
        headerView.addSubview(jobLab)
        
        headerView.frame.size.height = jobLab.frame.maxY+10
        
        headerImg.center.y = headerView.center.y
        
        self.rootTableView.tableHeaderView = headerView
    }
    
    // MARK:- tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FTTaPayCell") as! FTTaPayTableViewCell
        
        cell.selectionStyle = .none
        
        let str = nameArray[indexPath.section][indexPath.row]
        
        let nsStr = NSString(string: str)
        let attStr = NSMutableAttributedString(string: str)
        
        if str.contains(" ") {
            
            attStr.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSMakeRange(nsStr.range(of: " ").location, nsStr.length-nsStr.range(of: " ").location))
        }
        
        cell.setInfo(with: imageArray[indexPath.section][indexPath.row], text: attStr, selectedDot: selectedArray[indexPath.section][indexPath.row])
        
        
        return cell
    }
    
    // MARK:- tableview delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 25))
        let headerLab = UILabel(frame: CGRect(x: 20, y: 0, width: screenSize.width-40, height: 25))
        headerLab.font = UIFont.systemFont(ofSize: 14)
        headerLab.textColor = UIColor.gray
        
        
        if section == 0 {
            headerLab.text = "会员套餐"
        }else{
            headerLab.text = "支付方式"
        }
        
        headerView.addSubview(headerLab)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.selectedArray[indexPath.section] = [false,false,false,false]
            self.selectedArray[indexPath.section][indexPath.row] = true
        }else{
            self.selectedArray[indexPath.section] = [false,false]
            self.selectedArray[indexPath.section][indexPath.row] = true
        }
        
        self.rootTableView.reloadData()

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
