//
//  GPSeparateParam.swift
//  Mihtra
//
//  Created by Gyan on 16/01/17.
//  Copyright © 2017 Gyana. All rights reserved.
//


import UIKit

class GPSeparateParam: NSObject {

    func sepearteParameterForMethod(methodName : URLTYPE, parameters : AnyObject) -> AnyObject {
        switch (methodName) {
        case .LOGIN :
            return self.returnAccessTokeModelObject(parameters: parameters as! [String : AnyObject]) as GetAccessTokenModel
        }
    }
    
    /**
     this will return the LoginModel object.
     */
    private func returnAccessTokeModelObject(parameters : [String : AnyObject]!) -> GetAccessTokenModel {
        let model = GetAccessTokenModel(getOtpData: parameters)
        return model
    }
   
}

