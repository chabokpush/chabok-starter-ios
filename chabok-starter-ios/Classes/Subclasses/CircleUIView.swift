//
//  CircleUIView.swift
//  ChabokTest
//
//  Created by Hussein Habibi Juybari on 9/25/18.
//  Copyright © 2018 Chabok Realtime Solutions. All rights reserved.
//

import UIKit

class CircleUIView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = rect.size.width / 2
    }
}
