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
    
    private let socket = SocketIOManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSButton.layer.cornerRadius = 10
        SAButton.layer.cornerRadius = 10
        MockSocketIOManager.shared.allRooms
            .bind(onNext: { rooms in
                if let room = rooms.first {
                    print(room.roomTitle)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func HSLoginButtonTapped(_ sender: Any) {
        socket.loginUser(senderID: "형석")
    }
    @IBAction func SALoginButtonTapped(_ sender: Any) {
        socket.loginUser(senderID: "선아")
    }
    
}
