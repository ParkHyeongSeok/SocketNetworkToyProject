//
//  LoginViewController.swift
//  test
//
//  Created by 박형석 on 2022/01/02.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var HSButton: UIButton!
    @IBOutlet weak var SAButton: UIButton!
    
    private let socket = SocketIOManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSButton.layer.cornerRadius = 10
        SAButton.layer.cornerRadius = 10
    }
    
    @IBAction func HSLoginButtonTapped(_ sender: Any) {
        socket.loginUser(senderID: "1")
    }
    @IBAction func SALoginButtonTapped(_ sender: Any) {
        socket.loginUser(senderID: "2")
    }
    
}
