//
//  Contants.swift
//  CWGNALET
//
//  Created by Mensah Shadrach on 10/22/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit


@objc class CS:NSObject{
    
    private static let _c = CS()
    static var C:CS{
        return _c
    }
    
    @objc public static func unix_epoch_ts()->Double{
        return NSDate().timeIntervalSince1970 * 1000
    }
    
    public static  let ABANDONED_ACCIDENT = "ABANDONED/ACCIDENT VEHICLE";
    public static  let SANITATION = "SANITATION"
    public static let  POTHOLES = "POTHOLES";
    public static let  ECG = "ELECTRICAL/ECG";
    public static let  OTHERS = "OTHERS";
    public static let LOCATION = "location"
    let CASE_ID = "id"
    let CASE_NAME = "name"
    let CASE_DESC = "description"
    let CASE_IMGLNK = "link"
    let CASE_SUP_BODY = "supBody"
    let CASE_STATUS = "status"
    let CASE_UP_VOTES = "ups"
    let CASE_DOWN_VOTES = "downs"
    let USER_UID__ = "uid"
    let DID_LOG_IN_ = "LoggedIn"
    let REF_ID_USERNAME = "username"
    let REF_ID_IMG_LNK = "link"
    let REF_GC_POINTS = "gcpoints"
    let REF_DATE = "date"
    let FIRST_RUN = "firstRun"
    let REF_XTRAS = "extras"
    let REF_REPORTER = "Reporter"
    let REF_REPORTS = "Reports"
    let REF_VEHICLE_TYPE = "VehicleType"
    let REF_VEHICLE_COL = "VehicleColor"
    let REF_VEHICLE_NO = "VehicleNumber"
    let REF_SUP_BODY = "SUP_BODIES"
    let REF_AMA_ = "AMA"
    let REF_TMA_ = "TMA"
    public static let LONGITUDE = "longitude"
    public static let LATITUDE = "latitude"
    let REF_SUP_UNSOLVED = "Unsolved"
    let USER_ANONYMOX = "Anonymous"
    let ID_CASE_ANNO = "CaseAnno"
    @objc class func createDefaultAlert(title:String, message:String, actionTitle:String)-> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let def_ac = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(def_ac)
        return alert
    }
    
    @objc static func createAlert(_ title:String, _ message:String,actions:[UIAlertAction])->UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);

        for action in actions {
            alert.addAction(action)
        }
        return alert
    }

}


extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.setContentOffset(CGPoint(x:0, y:childStartPoint.y),animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}




extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
