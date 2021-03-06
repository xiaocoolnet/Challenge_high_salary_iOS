//
//  ChChHomeViewController.swift
//  ChallengeHighSalary
//
//  Created by zhang on 16/9/5.
//  Copyright © 2016年 北京校酷网络科技公司. All rights reserved.
//

import UIKit
import MJRefresh

class ChChHomeViewController: UIViewController, LFLUISegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate, AMapLocationManagerDelegate {
    
    let cityBtn = ImageBtn()
    
    let rootScrollView = UIScrollView()
    
    var jobList = [JobInfoDataModel]()
    
    var companyList = [Company_infoDataModel]()
    
    var salaryDrop = DropDown()
    var redEnvelopeDrop = DropDown()
    let findJobTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-20-44-49-37), style: .grouped)
    
    var scaleDrop = DropDown()
    var nearbyDrop = DropDown()
    let findEmployerTableView = UITableView(frame: CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: screenSize.height-20-44-49-37), style: .plain)
    
    var locationManager = AMapLocationManager()
    
    var sort = "1"
    var sorttype = Int()
    var segChoose = LFLUISegmentedControl()
    var red_job = ""
    var red_interview = ""
    var red_induction = ""
    var redEnvelopeBtn = ImageBtn()

    override func viewDidLoad() {
        super.viewDidLoad()

//        // TODO:
//        UserDefaults.standard.removeObject(forKey: myCity_key)

        // Do any additional setup after loading the view.
        
//        let num = String(typeNum)
        
        // 红包
        redEnvelopeBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: (screenSize.width)/6, height: 37))
        redEnvelopeBtn.resetdataCenter("红包", #imageLiteral(resourceName: "ic_下拉"))

        
        if typeNum <= 5 {
            sort = String(typeNum)
            sorttype = typeNum - 1
        }else if typeNum == 6{
            sorttype = 5
            self.redEnvelopeBtn.resetdataCenter("职位红包", #imageLiteral(resourceName: "ic_下拉"))
            self.red_job = "1"
            self.red_interview = ""
            self.red_induction = ""
        }else if typeNum == 7{
            sorttype = 5
            self.redEnvelopeBtn.resetdataCenter("面试红包", #imageLiteral(resourceName: "ic_下拉"))
            self.red_job = ""
            self.red_interview = "1"
            self.red_induction = ""
        }else if typeNum == 8{
            sorttype = 5
            self.redEnvelopeBtn.resetdataCenter("就职红包", #imageLiteral(resourceName: "ic_下拉"))
            self.red_job = ""
            self.red_interview = ""
            self.red_induction = "1"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMyName(notification:)), name:NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        self.view.backgroundColor = UIColor.white
        
        setNavigationBar()
        print(sorttype)
        setSubviews()
        
    }
    
    func getMyName(notification:NSNotification){
        
        //获取词典中的值
        print(notification)
        let name = (notification.object as! NSDictionary)["num"] as! String
        sorttype = Int(name)!
        print(sorttype)
        if sorttype <= 4{
            segChoose.selectTheSegument(sorttype)
        }else{
            segChoose.selectTheSegument(5)
            if sorttype == 5 {
                self.redEnvelopeBtn.resetdataCenter("职位红包", #imageLiteral(resourceName: "ic_下拉"))
                self.red_job = "1"
                self.red_interview = ""
                self.red_induction = ""
            }else if sorttype == 6{
                self.redEnvelopeBtn.resetdataCenter("面试红包", #imageLiteral(resourceName: "ic_下拉"))
                self.red_job = ""
                self.red_interview = "1"
                self.red_induction = ""
            }else if sorttype == 7{
                self.redEnvelopeBtn.resetdataCenter("就职红包", #imageLiteral(resourceName: "ic_下拉"))
                self.red_job = ""
                self.red_interview = ""
                self.red_induction = "1"
            }
            getRed_job()
            redEnvelopeDrop.hide()
        }
    }
    
    var hud = MBProgressHUD()
    var hudShowFlag = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false

        // 自定义下拉列表样式
        customizeDropDown()
        
        if UserDefaults.standard.string(forKey: myCity_key) == nil {
            
            hud.hide(animated: false)
            
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "正在获取当前位置"
            hud.removeFromSuperViewOnHide = true
            
            self.loadLocation()

        }else{
            
            myCity = UserDefaults.standard.string(forKey: myCity_key)!
            
            cityBtn.resetdata(myCity, #imageLiteral(resourceName: "城市下拉箭头"))

//            cityBtn.setTitle(myCity, for: UIControlState())
//            adjustBtnsTitleLabelAndImgaeView(cityBtn)
        }

    }
    
    // MARK: 加载数据 - 招聘列表
    func loadJobListData() {
        
        CHSNetUtil().getjoblist("",sort:"1") { (success, response) in
            if success {
                self.jobList = (response as! [JobInfoDataModel]?)!
                self.findJobTableView.reloadData()
                
            }else{
                
            }
            
            if self.findJobTableView.mj_header.isRefreshing() {
                self.findJobTableView.mj_header.endRefreshing()
            }
        }
        PublicNetUtil.getDictionaryList(parentid: "5") { (success, response) in
            if success {
                self.salaryDrop.dataSource = []
                self.salaryDrop.dataSource.append("全部")
                let dicData = response as! [DicDataModel]
                for dic in dicData {
                    self.salaryDrop.dataSource.append(dic.name!)
                }
            }
        }
        
        PublicNetUtil.getDictionaryList(parentid: "13") { (success, response) in
            if success {
                self.redEnvelopeDrop.dataSource = []
                self.redEnvelopeDrop.dataSource.append("全部")
                let dicData = response as! [DicDataModel]
                for dic in dicData {
                    self.redEnvelopeDrop.dataSource.append(dic.name!)
                }
            }
        }
        
    }
    
    // MARK: 加载数据 - 公司列表
    func loadCompanyListData() {
        
        CHSNetUtil().getCompanyList(pager: "1") { (success, response) in
            if success {
                self.companyList = (response as! [Company_infoDataModel]?)!
                self.findEmployerTableView.reloadData()
            }else{
                
            }
            
            if self.findEmployerTableView.mj_header.isRefreshing() {
                self.findEmployerTableView.mj_header.endRefreshing()
            }
        }
        PublicNetUtil.getDictionaryList(parentid: "18") { (success, response) in
            if success {
                self.scaleDrop.dataSource = []
                self.scaleDrop.dataSource.append("全部")
                let dicData = response as! [DicDataModel]
                for dic in dicData {
                    self.scaleDrop.dataSource.append(dic.name!)
                }
            }
        }
        
        
    }
    
    // MARK: 数据解析（招聘列表）
    func latelyLoadData(){
        print(self.sort)
        CHSNetUtil().getjoblist("",sort:self.sort) { (success, response) in
            if success {
                self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                self.hud.label.text = "加载中"
                self.hud.removeFromSuperViewOnHide = true
                self.hud.hide(animated: true, afterDelay: 1)
                self.jobList = (response as! [JobInfoDataModel]?)!
                self.findJobTableView.reloadData()
                
            }else{
                
            }
            
            if self.findJobTableView.mj_header.isRefreshing() {
                self.findJobTableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARk: 获取有红包公司列表
    func getRed_job(){
        CHSNetUtil().getRedenvelopeList(pager: "1", red_job: self.red_job, red_interview: self.red_interview, red_induction: self.red_induction) { (success, response) in
            if success {
                self.jobList = (response as! [JobInfoDataModel]?)!
                self.findJobTableView.reloadData()
                
            }else{
                
            }
            if self.findJobTableView.mj_header.isRefreshing() {
                self.findJobTableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARK: 设置 NavigationBar
    func setNavigationBar() {
        
        // 城市按钮
        cityBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        cityBtn.resetdata(myCity, #imageLiteral(resourceName: "城市下拉箭头"))
        cityBtn.lb_titleColor = UIColor.white
        cityBtn.addTarget(self, action: #selector(cityBtnClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityBtn)
        
        // rightBarButtonItems
        let retrievalBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        retrievalBtn.setImage(UIImage(named: "ic_筛选"), for: UIControlState())
        retrievalBtn.addTarget(self, action: #selector(retrievalBtnClick), for: .touchUpInside)
        let retrievalItem = UIBarButtonItem(customView: retrievalBtn)
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        searchBtn.setImage(UIImage(named: "ic_搜索"), for: UIControlState())
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: searchBtn)

        self.navigationItem.rightBarButtonItems = [searchItem,retrievalItem]
        
        
        // Init views with rects with height and y pos
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        
        // Use autoresizing to restrict the bounds to the area that the titleview allows
        titleView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue|UIViewAutoresizing.flexibleLeftMargin.rawValue|UIViewAutoresizing.flexibleRightMargin.rawValue)
        
        titleView.autoresizesSubviews = true
        
        
        let seg = UISegmentedControl(items: ["找工作","找雇主"])
        seg.frame = CGRect(x: 0, y: 10, width: 120, height: 24)
        seg.addTarget(self, action: #selector(self.segValueChanged(_:)), for: .valueChanged)
        seg.selectedSegmentIndex = 0
        
        seg.autoresizingMask = titleView.autoresizingMask
        
        
        
        let leftViewbounds = self.navigationItem.leftBarButtonItem?.customView?.bounds
        
        let rightViewbounds = self.navigationItem.rightBarButtonItem?.customView?.bounds
        
        var maxWidth = (leftViewbounds?.size.width)! > (rightViewbounds?.size.width)! ? (leftViewbounds?.size.width)! : (rightViewbounds?.size.width)!
        
        maxWidth += 15//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
        
        var frame = seg.frame
        
        frame.size.width = min(screenSize.width - maxWidth * 2, seg.frame.width)
        
        seg.frame = frame
        
        frame = titleView.frame
        
        frame.size.width = min(screenSize.width - maxWidth * 2, seg.frame.width)
        
        titleView.frame = frame
        
        // Add as the nav bar's titleview
        
        titleView.addSubview(seg)
        
        self.navigationItem.titleView = titleView
    }
    
    // MARK: 城市按钮点击事件
    func cityBtnClick() {
        self.navigationController?.pushViewController(ChChCityViewController(), animated: true)
    }
    
    // MARK: 检索按钮点击事件
    func retrievalBtnClick() {
        print("ChChHomeViewController searchBtnClick")
        
        let retrievalController = CHSChRetrievalViewController()
        retrievalController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(retrievalController, animated: true)
    }
    
    // MARK: 搜索按钮点击事件
    func searchBtnClick() {
        print("ChChHomeViewController searchBtnClick")
        
        let searchController = ChChSearchViewController()
        searchController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    // MARK: seg 点击事件
    func segValueChanged(_ seg:UISegmentedControl) {
        print(seg.selectedSegmentIndex)
        
        self.rootScrollView.contentOffset = CGPoint(x: CGFloat(seg.selectedSegmentIndex)*screenSize.width, y: 0)
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        rootScrollView.frame = CGRect(x: 0, y: 64,width: screenSize.width ,height: screenSize.height-49-64)
        rootScrollView.contentSize = CGSize(width: screenSize.width*2, height: screenSize.height-49-64)
        rootScrollView.isScrollEnabled = false
        self.view.addSubview(rootScrollView)
        
        setSubviews_findJob()
        setSubviews_findEmployer()
    }
    
    // MARK: 设置子视图_找工作
    func setSubviews_findJob() {
        
        
        // 薪资
        let salaryBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: (screenSize.width)/6, height: 37))
        salaryBtn?.resetdataCenter("薪资", #imageLiteral(resourceName: "ic_下拉"))

        // 薪资 下拉
        salaryDrop.anchorView = salaryBtn
        
        salaryDrop.bottomOffset = CGPoint(x: 0, y: 37)
        salaryDrop.width = screenSize.width
        salaryDrop.direction = .bottom
        
//        salaryDrop.dataSource = ["不限","1万以下","1~2万","2~3万","3~4万","4~5万","5万以上"]
        
        // 下拉列表选中后的回调方法
        salaryDrop.selectionAction = { (index, item) in
            salaryBtn?.resetdataCenter(item, #imageLiteral(resourceName: "ic_下拉"))
            
        }
        
        
        // 红包 下拉
        redEnvelopeDrop.anchorView = redEnvelopeBtn
        
        redEnvelopeDrop.bottomOffset = CGPoint(x: 0, y: 37)
        redEnvelopeDrop.width = screenSize.width
        redEnvelopeDrop.direction = .bottom
        
        redEnvelopeDrop.dataSource = ["全部","职位红包","面试红包","就职红包"]
        
        // 下拉列表选中后的回调方法
        redEnvelopeDrop.selectionAction = { (index, item) in
            print(index)
            self.redEnvelopeBtn.resetdataCenter(item, #imageLiteral(resourceName: "ic_下拉"))
            if index == 0 {
                self.red_job = ""
                self.red_interview = ""
                self.red_induction = ""
            }else if index == 1{
                self.red_job = "1"
                self.red_interview = ""
                self.red_induction = ""
            }else if index == 2{
                self.red_job = ""
                self.red_interview = "1"
                self.red_induction = ""
            }else if index == 3{
                self.red_job = ""
                self.red_interview = ""
                self.red_induction = "1"
            }
            
            self.getRed_job()

        }
        
        // 选择菜单
        segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: 0, y: 0,width: screenSize.width ,height: 37), titleArray: ["最新","最热","最近","评价","薪资",redEnvelopeBtn as Any], defaultSelect: 0)!
        segChoose.tag = 101
        segChoose.selectTheSegument(sorttype)
        segChoose.lineColor(baseColor)
        segChoose.titleColor(UIColor.black, selectTitleColor: baseColor, backGroundColor: UIColor.white, titleFontSize: 14)
        segChoose.delegate = self
        self.rootScrollView.addSubview(segChoose)
        
        // tableView
        findJobTableView.frame = CGRect(x: 0, y: segChoose.frame.maxY, width: screenSize.width, height: screenSize.height-20-44-49-37)
        findJobTableView.register(UINib.init(nibName: "ChChFindJobTableViewCell", bundle: nil), forCellReuseIdentifier: "ChChFindJobTableViewCell")
        findJobTableView.separatorStyle = .none
        findJobTableView.rowHeight = 140
        findJobTableView.tag = 101
        findJobTableView.dataSource = self
        findJobTableView.delegate = self
        self.rootScrollView.addSubview(findJobTableView)
        
        if typeNum <= 5 {
            
            findJobTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(latelyLoadData))
        }else{
            findJobTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getRed_job))
        }
        findJobTableView.mj_header.beginRefreshing()
    }
    
    // MARK: 设置子视图_找雇主
    func setSubviews_findEmployer() {
        
        // 规模
        let scaleBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: (screenSize.width)/3, height: 37))
        scaleBtn?.resetdataCenter("规模", #imageLiteral(resourceName: "ic_下拉"))
        
        // 规模 下拉
        scaleDrop.anchorView = scaleBtn
        
        scaleDrop.bottomOffset = CGPoint(x: 0, y: 37)
        scaleDrop.width = screenSize.width
        scaleDrop.direction = .bottom
        
//        scaleDrop.dataSource = ["不限","一人","2人","3人"]
        
        // 下拉列表选中后的回调方法
        scaleDrop.selectionAction = { (index, item) in
            
            scaleBtn?.resetdataCenter(item, #imageLiteral(resourceName: "ic_下拉"))
            
        }
        
        // 附近
        let nearbyBtn = ImageBtn(frame: CGRect(x: 0, y: 0, width: (screenSize.width)/3, height: 37))
        nearbyBtn?.resetdataCenter("附近", #imageLiteral(resourceName: "ic_下拉"))
        
        // 附近 下拉
        nearbyDrop.anchorView = nearbyBtn
        
        nearbyDrop.bottomOffset = CGPoint(x: 0, y: 37)
        nearbyDrop.width = screenSize.width
//        nearbyDrop.maxHeight = screenSize.height*0.3
        nearbyDrop.direction = .bottom
        
//        nearbyDrop.dataSource = ["测试用","一米","两米","三米"]
        
        // 下拉列表选中后的回调方法
        nearbyDrop.selectionAction = { (index, item) in
            
            nearbyBtn?.resetdataCenter(item, #imageLiteral(resourceName: "ic_下拉"))

//            nearbyBtn.setTitle(item, for: UIControlState())
//            
//            adjustBtnsTitleLabelAndImgaeView(nearbyBtn)

        }
        
        // 选择菜单
        let segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: screenSize.width, y: 0,width: screenSize.width ,height: 37), titleArray: ["最新",scaleBtn as Any,nearbyBtn as Any], defaultSelect: 0)!
        segChoose.tag = 102
        segChoose.lineColor(baseColor)
        segChoose.titleColor(UIColor.black, selectTitleColor: baseColor, backGroundColor: UIColor.white, titleFontSize: 14)
        segChoose.delegate = self
        self.rootScrollView.addSubview(segChoose)
        
        // tableView
        findEmployerTableView.frame = CGRect(x: screenSize.width, y: segChoose.frame.maxY, width: screenSize.width, height: screenSize.height-20-44-49-37)
        findEmployerTableView.register(UINib.init(nibName: "ChChFindEmployerTableViewCell", bundle: nil), forCellReuseIdentifier: "ChChFindEmployerTableViewCell")
        findEmployerTableView.separatorStyle = .none
        findEmployerTableView.rowHeight = 250
        findEmployerTableView.tag = 102
        findEmployerTableView.dataSource = self
        findEmployerTableView.delegate = self
        self.rootScrollView.addSubview(findEmployerTableView)
        
        findEmployerTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadCompanyListData))
        findEmployerTableView.mj_header.beginRefreshing()
    }
    
    // MARK:自定义下拉列表样式
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 45
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadiu = 0
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 0
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        appearance.textFont = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: LFLUISegmentedControlDelegate
    func uisegumentSelectionChange(_ selection: Int, segmentTag: Int) {
        print("ChChHomeViewController click \(selection) item")
        
        if segmentTag == 101 {
            
            if selection == 4 {
//                _ = salaryDrop.show()
                self.sort = "5"
                latelyLoadData()
            }else if selection == 5 {
                _ = redEnvelopeDrop.show()
            }else if selection == 2 {
                self.sort = "3"
                latelyLoadData()
            }else if selection == 1{
                self.sort = "2"
                latelyLoadData()
                
            }else if selection == 3 {
                self.sort = "4"
                latelyLoadData()
            }else if selection == 0 {
                self.sort = "1"
                latelyLoadData()
            }
        }else if segmentTag == 102 {
            
            if selection == 1 {
                _ = scaleDrop.show()
            }else if selection == 2 {
                
                let areaDic = NSDictionary.init(contentsOfFile: Bundle.main.path(forAuxiliaryExecutable: "area.plist")!)!  as! [String:[String:Array<String>]]
                var provinceArray = Array(areaDic.keys)
                provinceArray = provinceArray.sorted(by: { (str1, str2) -> Bool in
                    str1 < str2
                })
                
                var qu = [String]()
                for province in provinceArray {
                    let cityArray = Array(areaDic[province]!.keys)

                    for city in cityArray {
                        
                        if changeCityName(cityName: city) == myCity {
                            qu = areaDic[province]![city]!
                            break
                        }
                    }
                    
                    if qu != [] {
                        break
                    }
                }
                
                nearbyDrop.dataSource = qu
                _ = nearbyDrop.show()
            }
        }
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101 {
            return 1
        }else{
            return self.companyList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 101 {
            return self.jobList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 101 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChChFindJobTableViewCell") as! ChChFindJobTableViewCell
            cell.selectionStyle = .none
            
            cell.jobInfo = self.jobList[(indexPath as NSIndexPath).section]
            cell.companyBtn.tag = (indexPath as NSIndexPath).section
            cell.companyBtn.addTarget(self, action: #selector(companyBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChChFindEmployerTableViewCell") as! ChChFindEmployerTableViewCell
            cell.selectionStyle = .none
            
            cell.companyInfo = self.companyList[(indexPath as NSIndexPath).row]
            cell.jobsCountBtn.tag = (indexPath as NSIndexPath).row
            cell.jobsCountBtn.addTarget(self, action: #selector(jobsCountBtnClick(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 101 {
            let personalInfoVC = CHSChPersonalInfoViewController()
            personalInfoVC.jobInfo = self.jobList[(indexPath as NSIndexPath).section]
            
            self.navigationController?.pushViewController(personalInfoVC, animated: true)
        }else{
            let btn = UIButton()
            btn.tag = (indexPath as NSIndexPath).row
            self.companyButtonClick(sender: btn)
        }
    }
    
    // MARK:- companyBtnClick
    func companyBtnClick(_ companyBtn:UIButton) {
        
        let companyHomeVC = CHSChCompanyHomeViewController()
        companyHomeVC.jobInfoUserid = self.jobList[companyBtn.tag].userid ?? ""
        self.navigationController?.pushViewController(companyHomeVC, animated: true)
    }
    
    // MARK:- jobsCountBtnClick
    func jobsCountBtnClick(_ jobsCountBtn:UIButton) {
        
        let companyPositionListVC = CHSChCompanyPositionListViewController()
        companyPositionListVC.company_infoJobs = self.companyList[jobsCountBtn.tag].jobs!
        self.navigationController?.pushViewController(companyPositionListVC, animated: true)
    }
    
    // MARk: companyButtonClick
    func companyButtonClick(sender:UIButton){
        
        let vc = CHSChCompanyHomeViewController()
        vc.jobInfoUserid = self.companyList[sender.tag].userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - 定位
    func loadLocation() {
        
        self.locationManager.delegate = self
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.allowsBackgroundLocationUpdates = false
        
        
        // 如果需要持续定位返回逆地理编码信息，（自 V2.2.0版本起支持）需要做如下设置：
        self.locationManager.locatingWithReGeocode = true
        self.locationManager.startUpdatingLocation()
        
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        
        print("location:", location)
        
        
        if let location = location {
            
            if let regeocode = reGeocode {
                
                if  !AMapLocationDataAvailableForCoordinate(location.coordinate) {
                    
                    self.locationManager.stopUpdatingLocation()
                    
                    hud.mode = .text
                    hud.label.text = "不支持的位置"
                    hud.detailsLabel.text = "该软件仅支持中国,请手动选择一个城市"
                    hud.hide(animated: true, afterDelay: 1)
                    
                    let time: TimeInterval = 1.0
                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        
                        self.navigationController?.pushViewController(ChChCityViewController(), animated: true)
                        
                    }
                }
                
                self.locationManager.stopUpdatingLocation()
                
                UserDefaults.standard.set(changeCityName(cityName: regeocode.city ?? regeocode.province), forKey: positioningCity_key)
                UserDefaults.standard.set(changeCityName(cityName: regeocode.city ?? regeocode.province), forKey: myCity_key)
                positioningCity = UserDefaults.standard.string(forKey: positioningCity_key)!
                myCity = positioningCity
                cityBtn.resetdata(myCity, #imageLiteral(resourceName: "城市下拉箭头"))
                
                //                self.cityBtn.setTitle(myCity, for: UIControlState())
                //                adjustBtnsTitleLabelAndImgaeView(self.cityBtn)
                
                UserDefaults.standard.set(changeCityName(cityName: regeocode.city ?? regeocode.province), forKey: positioningCity_key)
                positioningCity = UserDefaults.standard.string(forKey: positioningCity_key)!
                
                if UserDefaults.standard.string(forKey: myCity_key) == nil {
                    
                    UserDefaults.standard.set(changeCityName(cityName: regeocode.city ?? regeocode.province), forKey: myCity_key)
                    
                    myCity = UserDefaults.standard.string(forKey: myCity_key)!
                }
                
                cityBtn.resetdata(myCity, #imageLiteral(resourceName: "城市下拉箭头"))
                hud.hide(animated: true)

                
            }
            else {
                print("lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)m")
                
            }
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        
        self.locationManager.stopUpdatingLocation()
        
        hud.mode = .text
        hud.label.text = "定位失败"
        hud.hide(animated: true, afterDelay: 1)
        
        let time: TimeInterval = 1.0
        let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            self.navigationController?.pushViewController(ChChCityViewController(), animated: true)
            
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


