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

class ChatController: UICollectionViewController {
    
    // MARK: properties
    let chat:Chat
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    let me:User
    var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
            }
            
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

    init(chat:Chat, me:User) {
        self.chat = chat
        self.me = me
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: helpers
    
    
    // MARK: Selectors
    @objc override func keyboardWillShow(notification: NSNotification) {
        
        
        if iMessageInputBar.inputTextView.isFirstResponder {
            
            if collectionView.contentInset.bottom == 10 {
                // TODO: 정확한 키보드의 사이즈를 구하기가 힘듬
                

                collectionView.contentInset.bottom = 280
                
            }
        }
        
    }

    @objc override func keyboardWillHide(notification: NSNotification) {
        
        
        if collectionView.contentInset.bottom != 10 {
            collectionView.contentInset.bottom = 10
        }
    }
    
    
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissIMessageeKeyboard() {
        iMessageInputBar.inputTextView.resignFirstResponder()
    }
    
    // MARK: APIs
    
    func fetchMessages(){
        MessageService.shared.listenMessages(chatId: chat.id) { (error, message, updatedMessage) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
//                self.messages = messages!
                if let message = message {
                    self.messages.append(message)
                }else if let message = updatedMessage {
                    self.messages.remove(at: self.messages.count - 1)
                    self.messages.append(message)
                }
                
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    
    
    func configure(){
        self.collectionView!.register(MyMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierMyMessage)
        
        self.collectionView!.register(OthersMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierOthersMessage)
        
        collectionView.backgroundColor = .white
        configureNavigation()
        fetchUser()
        configureUI()
        fetchMessages()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissIMessageeKeyboard))
        view.addGestureRecognizer(tap)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override var inputAccessoryView: UIView? {
        return iMessageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureUI(){
        collectionView.contentInset.bottom = 10
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
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
//         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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

        let font = UIFont(name: "BMJUAOTF", size: 14)
        
        let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 250, font: font!)
        
        let calendar = Calendar.current
        
        if message.sender == myId {
            // 내 메시지일때
            
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierMyMessage, for: indexPath) as! MyMessageCell
            myCell.message = message
            myCell.textBubbleViewWidthAnchor?.constant = estimatedFrame.width + 15
            
            // 밑에 메시지가 나의 메시지인데 서로 시간이 같으면 지워주기
            if messages.count - 1 != indexPath.row {
                let nextMessage = messages[indexPath.row + 1]
                if message.sender == nextMessage.sender {
                
                    let date = message.createdAt
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let date2 = nextMessage.createdAt
                    let hour2 = calendar.component(.hour, from: date2)
                    let minute2 = calendar.component(.minute, from: date2)
                    
                    if hour == hour2 && minutes == minute2 {
                        myCell.timeStamp.isHidden = true
                        myCell.timestampWidthAnchor?.constant = 0
                    }else {
                        myCell.timeStamp.isHidden = false
                        myCell.timestampWidthAnchor?.constant = 75
                    }
                    
                }else {
                    myCell.timeStamp.isHidden = false
                    myCell.timestampWidthAnchor?.constant = 75
                }
            }else {
                myCell.timeStamp.isHidden = false
                myCell.timestampWidthAnchor?.constant = 75
            }
            
            return myCell
            
        }else {
           // 내 메시지가 아닐때
            let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 200, font: font!)
            let othersMessage = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierOthersMessage, for: indexPath) as! OthersMessageCell
            othersMessage.message = message
            othersMessage.userId = message.sender
            othersMessage.delegate = self
            othersMessage.textBubbleViewWidthAnchor?.constant = estimatedFrame.width + 15
            
            // 위의 메시지가 내 메시지인데 서로 같은 유저이면 프로필 이미지 안보이게 바꿔주기
            if indexPath.row != 0 {
                let prevMessage = messages[indexPath.row - 1]
                if message.sender == prevMessage.sender {
                    othersMessage.profileImageView.isHidden = true
                }else {
                    othersMessage.profileImageView.isHidden = false
                }
            }else {
                othersMessage.profileImageView.isHidden = false
            }
            
            
            // 밑에 메시지가 나의 메시지인데 서로 시간이 같으면 지워주기
            if messages.count - 1 != indexPath.row {
                let nextMessage = messages[indexPath.row + 1]
                if message.sender == nextMessage.sender {
                
                    let date = message.createdAt
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let date2 = nextMessage.createdAt
                    let hour2 = calendar.component(.hour, from: date2)
                    let minute2 = calendar.component(.minute, from: date2)
                    
                    if hour == hour2 && minutes == minute2 {
                        othersMessage.timeStamp.isHidden = true
                        othersMessage.timestampeWidthAnchor?.constant = 0
                    }else {
                        othersMessage.timeStamp.isHidden = false
                        othersMessage.timestampeWidthAnchor?.constant = 75
                    }
                    
                }else {
                    othersMessage.timeStamp.isHidden = false
                    othersMessage.timestampeWidthAnchor?.constant = 75
                }
            }else {
                othersMessage.timeStamp.isHidden = false
                othersMessage.timestampeWidthAnchor?.constant = 75
            }
            
            
            return othersMessage
        }
    }
    
}

// MARK: Set message cell size
extension ChatController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let messageText = messages[indexPath.row].text
        guard let font = UIFont(name: "BMJUAOTF", size: 14) else {
            
            return CGSize(width: view.frame.width, height: 100)
        }

        
        guard let myId = Auth.auth().currentUser?.uid else { return CGSize(width: collectionView.frame.width, height: 100) }
        
        
        var estimatedFrame:CGRect?
        
        if messages[indexPath.row].sender == myId {
            estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 250, font: font)
        }else {
            estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 200, font: font)
        }
        
        guard estimatedFrame != nil else { return CGSize(width: view.frame.width, height: 100)}
        
        
        return CGSize(width: UIScreen.main.bounds.size.width , height: estimatedFrame!.height + 20)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}


// MARK: InputBarAccessoryViewDelegate
extension ChatController:InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.id else { return }
        MessageService.shared.postMessage(chatId: chat.id, sender: myId, text: text, receiver: userId) { (error) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }
        }
        iMessageInputBar.inputTextView.text = ""
    }
}

// MARK: OthersMessageCellDelegate
extension ChatController:OthersMessageCellDelegate {
    func profileImageTapped(cell: OthersMessageCell) {
        guard let user = cell.user else { return }
        let profileTypeTwoVC = ProfileControllerTypeTwo()
        profileTypeTwoVC.user = user
        profileTypeTwoVC.me = self.me
        profileTypeTwoVC.backButton.setTitle("\(user.username)", for: UIControl.State.normal)
        navigationController?.pushViewController(profileTypeTwoVC, animated: true)
    }
}


extension ChatController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
