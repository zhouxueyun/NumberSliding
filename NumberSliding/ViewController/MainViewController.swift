//
//  MainViewController.swift
//  NumberSliding
//
//  Created by zhouxueyun on 2019/3/18.
//  Copyright © 2019 zhouxueyun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func numberButtonAction(_ sender: UIButton) {
        let vc = NumberSlidingViewController(nibName: "NumberSlidingViewController", bundle: nil)
        vc.raw = sender.tag
        present(vc, animated: true, completion: nil)
    }

}
