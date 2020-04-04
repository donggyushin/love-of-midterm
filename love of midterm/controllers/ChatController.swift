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
import GrowingTextView

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
    
    var chatContainerViewHeightAnchor:NSLayoutConstraint?
    var chatContainerViewConstraint:NSLayoutConstraint?
    var keyboardHeight:CGFloat?
    
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화", for: .normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 16)
        button.setTitleColor(UIColor.tinderColor, for: .normal)
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
    
        return button
    }()
    
    lazy var chatInputTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.maxLength = 225
        tv.trimWhiteSpaceWhenEndEditing = true
        tv.minHeight = 28
        tv.maxHeight = 45
        tv.font = UIFont(name: "BMJUAOTF", size: 14)
        tv.textColor = .black
        tv.backgroundColor = .white
        tv.autocorrectionType = .no
        tv.layer.cornerRadius = 4
        tv.delegate = self
        return tv
    }()
    
    lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitle("전송", for: UIControl.State.normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "BMJUAOTF", size: 15)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(sendButtonTapped), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var chatContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGray
        
        return view
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: helpers
    func makeSendButtonEnable(){
        
        self.sendButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.sendButton.isEnabled = true
        
    }
    
    func makeSendButtonUnabled(){
        
        self.sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        self.sendButton.isEnabled = false
    
    }
    
    // MARK: Selectors
    
    @objc func sendButtonTapped(){
        print("send button tapped")
        guard let user = user else { return }
        guard let message = chatInputTextView.text else { return }
        chatInputTextView.text = ""
        makeSendButtonUnabled()
        
        MessageService.shared.postMessage(chatId: chat.id, sender: me.id, text: message, receiver: user.id) { (error) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {

        
        
        if chatInputTextView.isFirstResponder {
            
            
            // keyboard height 구하기
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
                collectionView.contentInset.bottom = keyboardHeight! + chatContainerView.frame.height
                self.chatContainerViewConstraint?.constant = -self.keyboardHeight!
                self.view.layoutIfNeeded()
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
            }
        }


    }

    @objc override func keyboardWillHide(notification: NSNotification) {

        collectionView.contentInset.bottom = 50
        self.chatContainerViewConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
    @objc func backbuttonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissIMessageeKeyboard() {
        chatInputTextView.resignFirstResponder()
        
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
        collectionView.addGestureRecognizer(tap)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureUI(){
        
        collectionView.contentInset.bottom = 50
        view.addSubview(chatContainerView)
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        chatContainerViewConstraint = chatContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        chatContainerViewConstraint?.isActive = true
        chatContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatContainerViewHeightAnchor = chatContainerView.heightAnchor.constraint(equalToConstant: 50)
        chatContainerViewHeightAnchor?.isActive = true
        
        chatContainerView.addSubview(chatInputTextView)
        chatInputTextView.translatesAutoresizingMaskIntoConstraints = false
        chatInputTextView.topAnchor.constraint(equalTo: chatContainerView.topAnchor, constant: 10).isActive = true
        chatInputTextView.leftAnchor.constraint(equalTo: chatContainerView.leftAnchor, constant: 8).isActive = true
        chatInputTextView.rightAnchor.constraint(equalTo: chatContainerView.rightAnchor, constant: -70).isActive = true
        
        chatContainerView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: chatContainerView.topAnchor, constant: 10).isActive = true
        sendButton.rightAnchor.constraint(equalTo: chatContainerView.rightAnchor, constant: -6).isActive = true
        sendButton.leftAnchor.constraint(equalTo: chatInputTextView.rightAnchor, constant: 6).isActive = true
        chatInputTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
extension ChatController:UITextViewDelegate, GrowingTextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            makeSendButtonEnable()
        }else {
            makeSendButtonUnabled()
        }
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        print(view.frame.height - keyboardHeight! - height - 20)
        print(height)
        chatContainerViewHeightAnchor?.constant = height + 20
    }
}
