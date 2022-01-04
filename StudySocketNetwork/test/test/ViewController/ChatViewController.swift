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
import NSObject_Rx

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    var room: Room!
    var currentUser: User!
    var chats: [Chat] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    var viewModel: ChatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        viewModel.chats
            .bind(onNext: { chats in
                self.chats = chats
            })
            .disposed(by: rx.disposeBag)
    }
    
    // MARK: - Messages Delegate Methods
    
    func currentSender() -> SenderType {
        return viewModel.currentUser
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let url = URL(string: message.sender.senderId)!
        let sdImage = UIImageView()
        sdImage.sd_setImage(with: url, placeholderImage: nil, completed: { image, _,_,_ in
            let avatar = Avatar(image: image, initials: message.sender.displayName)
            avatarView.set(avatar: avatar)
        })
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
        return self.chats[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.chats.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.viewModel.sendMessage(user: viewModel.currentUser, room: viewModel.room, content: text)
        inputBar.inputTextView.text = ""
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
