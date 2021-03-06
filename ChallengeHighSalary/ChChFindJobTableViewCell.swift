//
//  ChChFindJobTableViewCell.swift
//  ChallengeHighSalary
//
//  Created by zhang on 16/9/5.
//  Copyright © 2016年 北京校酷网络科技公司. All rights reserved.
//

import UIKit

class ChChFindJobTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var company_nameLab: UILabel!
    
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var realnameLab: UILabel!
    
    @IBOutlet weak var myjobLab: UILabel!
    
    @IBOutlet weak var countLab: UILabel!
    
    @IBOutlet weak var company_scoreLab: UILabel!
    
    @IBOutlet weak var salaryLab: UILabel!
    
    @IBOutlet weak var distanceLab: UILabel!
 
    @IBOutlet weak var cityLab: UILabel!
    
    @IBOutlet weak var experienceLab: UILabel!
    
    @IBOutlet weak var educationLab: UILabel!
    
    @IBOutlet weak var work_propertyLab: UILabel!
    
    @IBOutlet weak var topLine: UIImageView!
    
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var companyBtn: UIButton!
    
    
    var jobInfo:JobInfoDataModel? {
        didSet {
            self.titleLab.text = jobInfo?.title
            self.company_nameLab.text = jobInfo?.company_name
            self.logoImg.sd_setImage(with: URL(string: kImagePrefix+(jobInfo?.logo ?? "")!), placeholderImage: #imageLiteral(resourceName: "ic_默认头像"))
            self.realnameLab.text = jobInfo?.realname
            self.myjobLab.text = jobInfo?.myjob
            self.countLab.text = "公司规模"+(jobInfo?.count ?? "")!
            self.company_scoreLab.text = "综合评分"+(jobInfo?.company_score ?? "")!
            self.salaryLab.text = "￥ "+(jobInfo?.salary ?? "")!+"K"
            self.distanceLab.text = jobInfo?.distance
            self.cityLab.text = jobInfo?.city?.components(separatedBy: "-").last
            self.experienceLab.text = jobInfo?.experience
            self.educationLab.text = jobInfo?.education
//            self.work_propertyLab.text = jobInfo?.work_property ?? "待补充"
            self.work_propertyLab.text = jobInfo?.work_property

        }
    }
    
//    var applyJobData:MyApplyJobData? {
//        didSet {
//            self.titleLab.text = applyJobData?.applys?.title
//            self.company_nameLab.text = applyJobData?.applys?.company_name
//            self.logoImg.sd_setImage(with: URL(string: kImagePrefix+(applyJobData?.applys?.logo)!), placeholderImage: nil)
//            self.realnameLab.text = applyJobData?.applys?.realname
//            self.myjobLab.text = applyJobData?.applys?.myjob
//            self.countLab.text = "公司规模"+(applyJobData?.applys?.count ?? "0")!
//            self.company_scoreLab.text = "综合评分"+(applyJobData?.applys?.company_score ?? "")!
//            self.salaryLab.text = "￥ "+(applyJobData?.applys?.salary)!
//            self.distanceLab.text = jobInfo?.distance
//            self.cityLab.text = applyJobData?.applys?.city?.components(separatedBy: "-").last
//            self.experienceLab.text = applyJobData?.applys?.experience
//            self.educationLab.text = applyJobData?.applys?.education
//            //            self.work_propertyLab.text = jobInfo?.work_property ?? "待补充"
//            self.work_propertyLab.text = applyJobData?.applys?.work_property
//            
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.drawDashed(topLine, color: UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1), fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: topLine.frame.size.width, y: 0), lineWidth: 1)
        
        self.drawDashed(bottomLine, color: UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1), fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: screenSize.width, y: 0), lineWidth: 1)
    }
    
    func drawDashed(_ onView:UIView, color:UIColor, fromPoint:CGPoint, toPoint:CGPoint, lineWidth:CGFloat) {
        
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
        dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = color.cgColor
        dotteShapLayer.lineWidth = lineWidth
        mdotteShapePath.move(to: fromPoint)
        mdotteShapePath.addLine(to: toPoint)
//        CGPathMoveToPoint(mdotteShapePath, nil, fromPoint.x, fromPoint.y)
//        CGPathAddLineToPoint(mdotteShapePath, nil, toPoint.x, toPoint.y)
        //        CGPathAddLineToPoint(mdotteShapePath, nil, 200, 200)
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [10,5])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        onView.layer.addSublayer(dotteShapLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
