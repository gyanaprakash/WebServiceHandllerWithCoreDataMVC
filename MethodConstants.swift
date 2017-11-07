//
//  MethodConstants.swift
//  Mihtra
//
//  Created by Gyan on 16/01/17.
//  Copyright © 2017 Gyana. All rights reserved.
//

import Foundation
import UIKit

/************************************************************/
/* ================== METHOD NAMES ======================= */
/************************************************************/
// MARK: Method Names
enum URLTYPE {
    case LOGIN
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
