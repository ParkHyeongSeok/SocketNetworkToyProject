//
//  RoomsTableViewController.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import UIKit

class RoomsTableViewController: UITableViewController {
    
    var rooms = [Room]()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRooms(_:)), name: NSNotification.Name("roomsUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: NSNotification.Name("userUpdate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createRoom))
    }
    
    @objc func updateUser(_ notification: Notification) {
        let user = notification.object as! User
        self.title = "\(user.displayName)님, 환영합니다!"
        self.currentUser = user
    }
    
    @objc func updateRooms(_ notification: Notification) {
        self.rooms = notification.object as! [Room]
        self.tableView.reloadData()
    }
    
    @objc func createRoom() {
        print("create Room")
        
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
            vc.currentUser = self.currentUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomsCell", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.roomTitle
        cell.detailTextLabel?.text = dateToString(date: Date())
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        guard let user = self.currentUser else { return }
        let room = rooms[indexPath.row]
        vc.room = room
        vc.currentUser = self.currentUser
        SocketIOManager.shared.joinRoom(room: room, user: user)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
