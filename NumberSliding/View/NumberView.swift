//
//  NumberView.swift
//  NumberSliding
//
//  Created by zhouxueyun on 2019/3/18.
//  Copyright © 2019 zhouxueyun. All rights reserved.
//

import UIKit

class NumberView: UIView {

    var num: Int = 0 {
        didSet {
            label.text = String(num)
        }
    }
    
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.text = String(num)
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        addSubview(label)
        layoutNumberLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNumberLabel()
    }
    
    func layoutNumberLabel() {
        let margin: CGFloat = 4
        var labelFrame = self.bounds
        labelFrame.origin.x += margin
        labelFrame.origin.y += margin
        labelFrame.size.width -= margin * 2
        labelFrame.size.height -= margin * 2
        label.frame = labelFrame
        label.font = UIFont.systemFont(ofSize: labelFrame.width / 2)
    }
}
