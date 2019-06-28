//
//  SobreViewController.swift
//  ALudjinha
//
//  Created by Filipe Merli on 26/06/19.
//  Copyright © 2019 Filipe Merli. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navTopItem = self.navigationController!.navigationBar.topItem {
            navTopItem.titleView = .none
            navTopItem.title = "Sobre"
        }
        
    }

}

