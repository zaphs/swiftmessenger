//
//  Views.swift
//  messenger
//
//  Created by Zarif Safiullin on 21/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        layer.cornerRadius = frame.size.width / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
}
