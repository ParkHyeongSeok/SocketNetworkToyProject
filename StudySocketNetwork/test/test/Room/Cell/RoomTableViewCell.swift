//
//  RoomTableViewCell.swift
//  test
//
//  Created by 박형석 on 2022/01/05.
//

import UIKit
import Kingfisher
import RxSwift

class RoomTableViewCell: UITableViewCell {
    static let identifier = "RoomTableViewCell"
    
    @IBOutlet weak var cellBackgroundImage: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var participantCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellBackgroundImage.layer.cornerRadius = 15
    }
    
    func updateUI(room: Room) {
        self.cellBackgroundImage.image = UIImage(named: "cellBackground")
        self.roomTitle.text = room.roomTitle
        self.createDate.text = dateFormmater.string(from: room.createDate)
        self.participantCount.text = "\(room.participant.count)"
    }
    
    private let dateFormmater: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MM월 dd일"
        return format
    }()
    

}
