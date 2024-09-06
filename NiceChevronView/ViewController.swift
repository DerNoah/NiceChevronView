//
//  ViewController.swift
//  NiceChevronView
//
//  Created by Noah Plützer on 06.09.24.
//

import UIKit

class ViewController: UIViewController {
    private let chevronView = ChevronView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        chevronView.lineWidth = 12
        chevronView.tintColor = .orange
        
        view.addSubview(chevronView)
        
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevronView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chevronView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 100),
            chevronView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        chevronView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChevronTapped(_:))))
    }
    
    @objc
    private func onChevronTapped(_ sender: UITapGestureRecognizer) {
        if chevronView.direction == .left {
            chevronView.direction = .right
        } else {
            chevronView.direction = .left
        }
    }
}

