//
//  LoginViewController.swift
//  test
//
//  Created by 박형석 on 2022/01/02.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class LoginViewController: UIViewController {
    
    @IBOutlet weak var HSButton: UIButton!
    @IBOutlet weak var SAButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        HSButton.layer.cornerRadius = 10
        SAButton.layer.cornerRadius = 10
    }
    
    @IBAction func HSLoginButtonTapped(_ sender: Any) {
        SocketIOManager.shared.requestUserData(name: "형석")
    }
    @IBAction func SALoginButtonTapped(_ sender: Any) {
        SocketIOManager.shared.requestUserData(name: "선아")
    }
    
}