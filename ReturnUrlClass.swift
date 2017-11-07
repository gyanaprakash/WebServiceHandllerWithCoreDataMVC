//
//  ReturnUrlClass.swift
//  Mihtra
//
//  Created by Gyan on 16/01/17.
//  Copyright © 2017 Gyana. All rights reserved.
//

import UIKit

class ReturnUrlClass: NSObject {

    func returnUrlForMethod(methodName : URLTYPE, param : NSDictionary!) -> NSURL {
        switch (methodName) {
        case .LOGIN :
            return NSURL(string: self.createUrlForMihtraLogin())!
        }
    }
    
    private func createUrlForMihtraLogin() -> String {
        return MIHRTA_BASE_URL + MIHTRA_API_VERSION + MIHRTA_LOGIN_URL
    }

}

