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
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var titleStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.titleStackView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.titleStackView.alpha = 1
        }
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
