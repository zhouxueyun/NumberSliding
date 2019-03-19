//
//  NumberPadView.swift
//  NumberSliding
//
//  Created by zhouxueyun on 2019/3/18.
//  Copyright © 2019 zhouxueyun. All rights reserved.
//

import UIKit

protocol NumberPadViewDelegate: NSObjectProtocol {
    
    func numberPadViewDidFinishSliding(_ view: NumberPadView)
    
}

class NumberPadView: UIView {

    enum SwipeDirection {
        case up
        case down
        case left
        case right
    }
    
    weak var delegate: NumberPadViewDelegate?
    
    var numberViewGrid: [[NumberView?]] = []
    
    var raw: Int = 0 {
        didSet {
            numberViewGrid.forEach { (numberViews) in
                numberViews.forEach({ (view) in
                    view?.removeFromSuperview()
                })
            }
            numberViewGrid = [[NumberView?]](repeating: [NumberView?](repeating: nil, count: raw), count: raw)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeAllNumberView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeAllNumberView()
        generateRandomNumber()
    }
    
    func removeAllNumberView() {
        for i in 0..<numberViewGrid.count {
            for j in 0..<numberViewGrid[i].count {
                numberViewGrid[i][j]?.removeFromSuperview()
                numberViewGrid[i][j] = nil
            }
        }
    }
    
    func generateRandomNumber() {
        let subwidth = bounds.width / CGFloat(raw)
        let subheight = bounds.height / CGFloat(raw)
        var randomSeq = (1..<raw*raw).map({ $0 })
        for i in 0..<numberViewGrid.count {
            for j in 0..<numberViewGrid[i].count {
                if randomSeq.isEmpty {
                    break // 没有更多了
                }
                
                let randomIndex = Int(arc4random()) % randomSeq.count
                let randomNum = randomSeq[randomIndex]
                randomSeq.remove(at: randomIndex)
                
                let view = NumberView()
                view.num = randomNum
                view.frame = CGRect(x: CGFloat(j) * subwidth,
                                    y: CGFloat(i) * subheight,
                                    width: subwidth,
                                    height: subheight)
                
                addSubview(view)
                numberViewGrid[i][j] = view
            }
        }
    }
    
    func refresh() {
        removeAllNumberView()
        generateRandomNumber()
    }
    
    func swipe(_ direction: SwipeDirection) {
        var emptyI = 0
        var emptyJ = 0
        for i in 0..<numberViewGrid.count {
            for j in 0..<numberViewGrid[i].count {
                if numberViewGrid[i][j] == nil {
                    emptyI = i
                    emptyJ = j
                    break
                }
            }
        }
        
        let subwidth = bounds.width / CGFloat(raw)
        let subheight = bounds.height / CGFloat(raw)
        switch direction {
        case .up:
            if emptyI < raw - 1 {
                let targetView = numberViewGrid[emptyI+1][emptyJ]!
                numberViewGrid[emptyI][emptyJ] = targetView
                numberViewGrid[emptyI+1][emptyJ] = nil
                validate()
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = CGRect(x: CGFloat(emptyJ) * subwidth,
                                              y: CGFloat(emptyI) * subheight,
                                              width: subwidth,
                                              height: subheight)
                }
            }
        case .down:
            if emptyI > 0 {
                let targetView = numberViewGrid[emptyI-1][emptyJ]!
                numberViewGrid[emptyI][emptyJ] = targetView
                numberViewGrid[emptyI-1][emptyJ] = nil
                validate()
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = CGRect(x: CGFloat(emptyJ) * subwidth,
                                              y: CGFloat(emptyI) * subheight,
                                              width: subwidth,
                                              height: subheight)
                }
            }
        case .left:
            if emptyJ < raw - 1 {
                let targetView = numberViewGrid[emptyI][emptyJ+1]!
                numberViewGrid[emptyI][emptyJ] = targetView
                numberViewGrid[emptyI][emptyJ+1] = nil
                validate()
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = CGRect(x: CGFloat(emptyJ) * subwidth,
                                              y: CGFloat(emptyI) * subheight,
                                              width: subwidth,
                                              height: subheight)
                }
            }
        case .right:
            if emptyJ > 0 {
                let targetView = numberViewGrid[emptyI][emptyJ-1]!
                numberViewGrid[emptyI][emptyJ] = targetView
                numberViewGrid[emptyI][emptyJ-1] = nil
                validate()
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = CGRect(x: CGFloat(emptyJ) * subwidth,
                                              y: CGFloat(emptyI) * subheight,
                                              width: subwidth,
                                              height: subheight)
                }
            }
        }
    }
    
    func validate() {
        for i in 0..<numberViewGrid.count {
            for j in 0..<numberViewGrid[i].count {
                if i == raw - 1 && j == raw - 1 {
                    delegate?.numberPadViewDidFinishSliding(self)
                } else if numberViewGrid[i][j] == nil ||
                    numberViewGrid[i][j]!.num != (i * raw + j + 1) {
                    break
                }
            }
        }
    }
}
