//
//  NumberSlidingViewController.swift
//  NumberSliding
//
//  Created by zhouxueyun on 2019/3/18.
//  Copyright © 2019 zhouxueyun. All rights reserved.
//

import UIKit

class NumberSlidingViewController: UIViewController {

    var raw: Int = 0
    
    private var isPlaying: Bool = false
    private var playStartTime: TimeInterval = 0
    private var timer: Timer?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tipLabel: UILabel!
    
    @IBOutlet var numberPadContainer: UIView!
    
    var numberPadView: NumberPadView!
    
    deinit {
        stopTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(raw > 0, "raw should > 0")
        titleLabel.text = "\(raw) x \(raw)"
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(numberPadSwipeAction(_:)))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(numberPadSwipeAction(_:)))
        swipeDown.direction = .down
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(numberPadSwipeAction(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(numberPadSwipeAction(_:)))
        swipeRight.direction = .right
        
        numberPadContainer.addGestureRecognizer(swipeUp)
        numberPadContainer.addGestureRecognizer(swipeDown)
        numberPadContainer.addGestureRecognizer(swipeLeft)
        numberPadContainer.addGestureRecognizer(swipeRight)
        
        numberPadView = NumberPadView()
        numberPadView.raw = raw
        numberPadView.delegate = self
        numberPadContainer.addSubview(numberPadView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numberPadView.frame = numberPadContainer.bounds
    }
    
}

// MARK: - Action
extension NumberSlidingViewController {
    
    @IBAction func exitAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        stopTimer()
        numberPadView.refresh()
    }
    
    @objc func numberPadSwipeAction(_ gesture: UISwipeGestureRecognizer) {
        let direction = gesture.direction
        print("numberPadSwipeAction", direction)
        if !isPlaying {
            startTimer()
        }
        switch direction {
        case .up:
            numberPadView.swipe(.up)
        case .down:
            numberPadView.swipe(.down)
        case .left:
            numberPadView.swipe(.left)
        case .right:
            numberPadView.swipe(.right)
        default:
            ()
        }
    }
    
}


// MARK: - Timer
extension NumberSlidingViewController {
    
    func startTimer() {
        stopTimer()
        playStartTime = Date().timeIntervalSince1970
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fire()
        isPlaying = true
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
        tipLabel.text = "00:00.00"
    }
    
    @objc func timerAction(_ timer: Timer) {
        let now = Date().timeIntervalSince1970
        let diff = now - playStartTime
        tipLabel.text = String(format: "%02d:%02d.%02d",
                               Int(diff) / 60,
                               Int(diff) % 60,
                               Int(diff * 100) % 100)
    }
    
}


// MARK: Number Pad
extension NumberSlidingViewController: NumberPadViewDelegate {
    
    func numberPadViewDidFinishSliding(_ view: NumberPadView) {
        stopTimer()
        tipLabel.text = "Finished"
    }
    
}
