//
//  Model.swift
//  Browser-App
//
//  Created by Eldor Makkambaev on 01.05.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import Foundation

struct Website {
    var websiteName: String?
    var websiteUrl: String?
    var isFav: Bool?
    init(_ websiteName: String, _ websiteUrl: String, _ isFav: Bool) {
        self.websiteName = websiteName
        self.websiteUrl = websiteUrl
        self.isFav = isFav
    }
}
