//
//  Instantiatable.swift
//  test
//
//  Created by 박형석 on 2022/01/04.
//

import UIKit

protocol Instantiatable {
    func instantiate(_ storyboardName: String) -> Self
}

extension Instantiatable where Self: UIViewController {
    /// before using this method, should set storyboard viewcontroller identifier equal ro viewconttoller class name
    static func instantiate(_ storyboardName: String) -> Self {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let vc = sb.instantiateViewController(withIdentifier: className) as! Self
        return vc
    }
}
