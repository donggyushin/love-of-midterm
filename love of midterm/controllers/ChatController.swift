//
//  ChatController.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/25.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase
import InputBarAccessoryView


private let reuseIdentifierMyMessage = "Cell1"
private let reuseIdentifierOthersMessage = "Cell2"
private let reuseIdentifierOthersMessageTypeTwo = "Cell3"

class ChatController: UICollectionViewController {
    
    // MARK: properties
    let chat:Chat
    var user:User? {
        didSet {
            configureUser()
        }
    }
    var messages = [Message]() {
        didSet {
            collectionView.reloadData()
            let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
            let lastItemIndex = NSIndexPath(item: item, section: 0)
            self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
        }
    }
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var iMessageInputBar:IMeessageInputBar = {
        let iMessage = IMeessageInputBar()
        iMessage.delegate = self
        return iMessage
    }()
    
    
    // MARK: Life styles

    init(chat:Chat) {
        self.chat = chat
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

    }
    
    // MARK: helpers
    
    
    // MARK: Selectors
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissIMessageeKeyboard() {
        print("here")
        iMessageInputBar.inputTextView.resignFirstResponder()
    }
    
    // MARK: APIs
    
    func fetchMessages(){
        MessageService.shared.listenMessages(chatId: chat.id) { (error, message) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
//                self.messages = messages!
                self.messages.append(message!)
            }
        }
    }
    
    func fetchUser(){
        guard let myId = Auth.auth().currentUser?.uid else { return }
        var userIdImFinding:String?
        for userId in chat.users {
            if userId != myId {
                userIdImFinding = userId
            }
        }
        
        guard userIdImFinding != nil else { return }
        UserService.shared.fetchUserWithId(id: userIdImFinding!) { (error, user) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
                self.user = user!
            }
        }
        
    }
    
    
    // MARK: configures
    func configure(){
        self.collectionView!.register(MyMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierMyMessage)
        
        self.collectionView!.register(OthersMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierOthersMessage)
        
        self.collectionView!.register(OtherMessageCellTypeTwo.self, forCellWithReuseIdentifier: reuseIdentifierOthersMessageTypeTwo)
        
        collectionView.backgroundColor = .white
        configureNavigation()
        fetchUser()
        configureUI()
        fetchMessages()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissIMessageeKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override var inputAccessoryView: UIView? {
        return iMessageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureUI(){
        
    }
    
    
    func configureUser(){
        guard let user = user else { return }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BMJUAOTF", size: 18)!,
                                                                        NSAttributedString.Key.foregroundColor:UIColor.tinderColor
        ]
        self.navigationItem.title = "\(user.username)"
    }
    
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myId = Auth.auth().currentUser!.uid
        
        let message = messages[indexPath.row]
        
        let messageText = messages[indexPath.row].text
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: "BMJUAOTF", size: 16) as Any], context: nil)
        
        
        if message.sender == myId {
            
            
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierMyMessage, for: indexPath) as! MyMessageCell
            
            myCell.messageTextView.text = message.text
            
            var timestampText = ""
            let date = message.createdAt
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            if hour == 12 {
                timestampText = "오후 12시 \(minutes)분"
            }else if hour > 12 {
                timestampText = "오후 \(hour - 12)시 \(minutes)분"
            }else {
                timestampText = "오전 \(hour)시 \(minutes)분"
            }
            
            myCell.timeStamp.text = timestampText
            
            myCell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 25 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            myCell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 40, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            myCell.timeStamp.frame = CGRect(x: view.frame.width - estimatedFrame.width - 40 - 69, y: estimatedFrame.height + 7, width: 75, height: 10)
            
            if messages.count - 1 != indexPath.row {
                
                if message.sender == messages[indexPath.row + 1].sender {
                    let currentMessageDate = message.createdAt
                    let currentHour = calendar.component(.hour, from: currentMessageDate)
                    let currentMinute = calendar.component(.minute, from: currentMessageDate)
                    
                    let nextMessageDate = messages[indexPath.row + 1].createdAt
                    let nextHour = calendar.component(.hour, from: nextMessageDate)
                    let nextMinute = calendar.component(.minute, from: nextMessageDate)
                    
                    if nextHour == currentHour && nextMinute == currentMinute {
                        myCell.timeStamp.isHidden = true
                    }
                }
                
            }
            
            return myCell
            
            
        }else {
            
            if indexPath.row == 0 {
                let othersCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierOthersMessage, for: indexPath) as! OthersMessageCell
                
                othersCell.messageTextView.text = message.text
                othersCell.userId = message.sender
                othersCell.profileImageView.frame = CGRect(x: 8, y: 0, width: 40, height: 40)
                othersCell.messageTextView.frame = CGRect(x: 60 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                othersCell.textBubbleView.frame = CGRect(x: 60, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                return othersCell
            }else {
                
                let previousMessage = self.messages[indexPath.row - 1]
                
                if previousMessage.sender == message.sender {
                    
                    let othersCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierOthersMessageTypeTwo, for: indexPath) as! OtherMessageCellTypeTwo
                    
                    othersCell.messageTextView.text = message.text
                    othersCell.messageTextView.frame = CGRect(x: 60 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    othersCell.textBubbleView.frame = CGRect(x: 60, y: 0, width: estimatedFrame.width + 16 + 8 , height: estimatedFrame.height + 20)
                    
                    return othersCell
                    
                }else {
                    let othersCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierOthersMessage, for: indexPath) as! OthersMessageCell
                    
                    othersCell.messageTextView.text = message.text
                    othersCell.userId = message.sender
                    othersCell.profileImageView.frame = CGRect(x: 8, y: 0, width: 40, height: 40)
                    othersCell.messageTextView.frame = CGRect(x: 60 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                    othersCell.textBubbleView.frame = CGRect(x: 60, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                    
                    return othersCell
                }
                
            }
            
        }
        
    }
    
}

// MARK: Set message cell size
extension ChatController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let messageText = messages[indexPath.row].text
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: "BMJUAOTF", size: 16) as Any], context: nil)
        
        
        return CGSize(width: UIScreen.main.bounds.size.width , height: estimatedFrame.height + 20)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}


// MARK: InputBarAccessoryViewDelegate
extension ChatController:InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        MessageService.shared.postMessage(chatId: chat.id, sender: myId, text: text) { (error) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }
        }
        iMessageInputBar.inputTextView.text = ""
    }
}
