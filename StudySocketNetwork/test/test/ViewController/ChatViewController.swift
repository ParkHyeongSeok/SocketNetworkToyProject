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
    
    var room: Room!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
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
        return self.room.chats[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.room.chats.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newChat = Chat(sender: self.currentUser, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        self.room.addChat(chat: newChat)
        self.messagesCollectionView.reloadData()
        
        SocketIOManager.shared.sendMessage(room: self.room, chat: newChat, user: self.currentUser)
        inputBar.inputTextView.text = ""
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
