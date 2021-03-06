//
//  HeaderReusableView.swift
//  test
//
//  Created by 박형석 on 2021/08/02.
//

import UIKit
import MessageKit

class HeaderReusableView: MessageReusableView {
    // MARK: - Private Properties
    static private let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.white
    ]
    
    static private let insets = UIEdgeInsets(top: 12, left: 80, bottom: 12, right: 80)
    
    private var label: UILabel!
    
    // MARK: - Public Methods
    static var height: CGFloat {
        return insets.top + insets.bottom + 27
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }
    
    /// Setup the receiver with text.
    ///
    /// - Parameter text: The text to be displayed.
    func setup(with text: String) {
        label.attributedText = NSAttributedString(string: text, attributes: HeaderReusableView.attributes)
    }
    
    override func prepareForReuse() {
        label.attributedText = nil
    }
    
    // MARK: - Private Methods
    private func createUI() {
        let insets = HeaderReusableView.insets
        let frame = bounds.inset(by: insets)
        label = UILabel(frame: frame)
        label.preferredMaxLayoutWidth = frame.width
        label.numberOfLines = 1
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        addSubview(label)
    }
}
