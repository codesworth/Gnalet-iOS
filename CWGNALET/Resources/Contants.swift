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
    
    @objc class func createDefaultAlert(title:String, message:String, actionTitle:String)-> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let def_ac = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(def_ac)
        return alert
    }

}
