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
import RxSwift
import RxCocoa

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
  
    var viewModel: ChatViewModel!
    
    var chats: [Chat] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()
        
        viewModel.message
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { $0 }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.showToast(message: text)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.chats
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { owner, chats in
                owner.chats = chats
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.chat
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { owner, chat in
                owner.chats.append(chat)
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.leaveRoom()
    }
    
    func setDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    // MARK: - Messages Delegate Methods
    
    func currentSender() -> SenderType {
        return self.viewModel.currentUser
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
        let newChat = Chat(sender: viewModel.currentUser, messageId: UUID().uuidString, roomId: viewModel.room.roomId, sentDate: Date(), kind: .text(text))
        self.viewModel.sendMessage(newChat: newChat)
        inputBar.inputTextView.text = ""
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 13.0)) {
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height/8, width: self.view.frame.size.width - 60, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.5,
                       options: .curveEaseOut,
                       animations: {
            toastLabel.alpha = 0.0
        },
                       completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
            
        })
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
