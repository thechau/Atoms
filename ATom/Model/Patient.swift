//
//  File.swift
//  ATom
//
//  Created by Nguyễn Vương Thành Lộc on 2/10/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit

enum PatientType {
    case alert
    case normal
    case boderLine
}

struct Patient {
    var name: String
    var type: PatientType
    var date: Date
    var info: String
    
}
