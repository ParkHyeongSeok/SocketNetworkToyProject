//
//  ChatViewController.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    var room: Room?
    var currentUser: User?
    var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChats(_:)), name: NSNotification.Name("chatsUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: NSNotification.Name("userUpdate"), object: nil)
    }
    
    // MARK: - Action
    
    @objc func updateChats(_ notification: Notification) {
        self.chats =  notification.object as? [Chat] ?? []
        messagesCollectionView.reloadData()
    }
    
    @objc func updateUser(_ notification: Notification) {
        let user = notification.object as! User
        self.currentUser = user
    }
    
    // MARK: - Messages Delegate Methods
    
    func currentSender() -> SenderType {
        guard let currentUser = self.currentUser else { return DummyData.shared.currentUser }
        return currentUser
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let url = URL(string: message.sender.senderId)!
        let sdImage = UIImageView()
        sdImage.sd_setImage(with: url, placeholderImage: UIImage(named: "img"), completed: nil)
        let avatar = Avatar(image: sdImage.image, initials: "default")
        avatarView.set(avatar: avatar)
    }
    
//    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
//        let header = messagesCollectionView.dequeueReusableHeaderView(HeaderReusableView.self, for: indexPath)
//        let message = messageForItem(at: indexPath, in: messagesCollectionView)
//        header.setup(with: "love")
//        return header
//    }
//
//    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//
//        return CGSize(width: messagesCollectionView.bounds.width, height: HeaderReusableView.height)
//
//    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chats[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chats.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let room = room else { return }
        guard let user = self.currentUser else { return }
        let newChat = Chat(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        SocketIOManager.shared.sendMessage(room: room, chat: newChat, user: user)
        inputBar.inputTextView.text = ""
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
