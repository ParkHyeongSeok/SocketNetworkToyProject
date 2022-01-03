////
////  ToastMessage.swift
////  test
////
////  Created by 박형석 on 2022/01/03.
////
//
//import UIKit
//
//class ToastMessage: UIView {
//
//    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds = true
//
//        self.view.addSubview(toastLabel)
//
//        UIView.animate(withDuration: 10.0,
//                       delay: 0.1,
//                       options: .curveEaseOut,
//                       animations: {
//                        toastLabel.alpha = 0.0
//                       },
//                       completion: { (isCompleted) in
//                        toastLabel.removeFromSuperview()
//
//                       })
//    }
//
//
//}
