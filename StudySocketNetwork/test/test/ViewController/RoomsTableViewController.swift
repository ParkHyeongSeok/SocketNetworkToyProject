//
//  RoomsTableViewController.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class RoomsTableViewController: UITableViewController {
    
    @IBOutlet weak var createRoomButton: UIBarButtonItem!
    
    let viewModel = RoomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func bindViewModel() {
        viewModel.currentUser
            .drive(onNext: { user in
                self.title = "\(user.displayName)님, 환영합니다!"
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.rooms
            .drive(self.tableView.rx.items(cellIdentifier: "roomsCell")) { index, item, cell in
                cell.textLabel?.text = item.roomTitle
                cell.detailTextLabel?.text = self.dateToString(date: Date())
            }
            .disposed(by: rx.disposeBag)
        
        Observable.zip(
            viewModel.currentUser.asObservable(),
            tableView.rx.modelSelected(Room.self))
            .bind { (user: User, room: Room) in
                let vc = ChatViewController()
                vc.room = room
                vc.currentUser = user
                SocketIOManager.shared.joinRoom(room: room, user: user)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: rx.disposeBag)
        
        createRoomButton.rx.tap
            .withLatestFrom(viewModel.currentUser.asObservable())
            .bind { user in
                let alert = UIAlertController(title: "룸 만들기", message: "룸의 이름을 기록해주세요!", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "룸 이름을 적어주세요!"
                }
                let okAction = UIAlertAction(title: "생성", style: .default) { (action) in
                    guard let text = alert.textFields?[0].text else { return }
                    let newRoom = Room(roomID: UUID().uuidString, roomTitle: text, createDate: Double(Date().timeIntervalSince1970), chats: [])
                    SocketIOManager.shared.createRoom(room: newRoom)
                    let vc = ChatViewController()
                    vc.room = newRoom
                    vc.currentUser = user
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            .disposed(by: rx.disposeBag)
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
}
