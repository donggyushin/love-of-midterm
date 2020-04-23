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

protocol ChatControllerDelegate {
    func userLeave(chatController:ChatController)
}

class ChatController: UICollectionViewController {
    
    // MARK: properties
    let chat:Chat
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    var delegate:ChatControllerDelegate?
    
    var loading = true
    
    let me:User
    var messages = [Message]() 
    
    var chatContainerViewHeightAnchor:NSLayoutConstraint?
    var chatContainerViewConstraint:NSLayoutConstraint?
    var keyboardHeight:CGFloat?
    var menuViewWidthContraint:NSLayoutConstraint?
    var menuViewHeightConstraint:NSLayoutConstraint?
    
    // MARK: UIKits
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: .normal)
        }else {
            button.setTitleColor(UIColor.black, for: .normal)
        }
        
        button.addTarget(self, action: #selector(backbuttonTapped), for: .touchUpInside)
    
        return button
    }()
    
    lazy var threeDotsButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let origImage = #imageLiteral(resourceName: "threedots")
        let tintedImage = origImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        button.setImage(#imageLiteral(resourceName: "threedots"), for: UIControl.State.normal)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.tintColor = .white
        }else {
            button.tintColor = .black
        }
        
        button.addTarget(self, action: #selector(threeDotsButtonTapped), for: UIControl.Event.touchUpInside)
        
        
        
        return button
    }()
    
    lazy var exitChatButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("대화방 나가기", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.bold)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }else {
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
        
        button.addTarget(self, action: #selector(exitChatButtonTapped), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    lazy var menuView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .spaceGray
        view.addSubview(self.exitChatButton)
        exitChatButton.translatesAutoresizingMaskIntoConstraints = false
        exitChatButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        exitChatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var chatInputTextView:GrowingTextView = {
        let tv = GrowingTextView()
        tv.maxLength = 225
        tv.trimWhiteSpaceWhenEndEditing = true
        tv.minHeight = 28
        tv.maxHeight = 50
        tv.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        tv.autocorrectionType = .no
        tv.layer.cornerRadius = 4
        tv.delegate = self
        
        if self.traitCollection.userInterfaceStyle == .dark {
            tv.backgroundColor = .spaceGray
            tv.textColor = .white
        }else {
            tv.backgroundColor = .veryLightGray
            tv.textColor = .black
        }
        
        
        return tv
    }()
    
    lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("전송", for: UIControl.State.normal)
        button.setTitleColor(.gray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendButtonTapped), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var chatContainerView:UIView = {
        let view = UIView()
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .spaceGray
        }else {
            view.backgroundColor = .veryLightGray
        }
        
        
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            self.loading = false
        }
        configure()
        listenChatDisappear()
        

        
        if var textAttributes = self.navigationController?.navigationBar.titleTextAttributes {
            textAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
//    @objc func hideKeyboard(){
//        if chatInputTextView.isFirstResponder {
//            self.view.endEditing(true)
//        }
//    }
    
    // MARK: 테마가 변경될때
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if let previousTraitCollection = previousTraitCollection {
            
            // 어두운 테마일때
            if previousTraitCollection.userInterfaceStyle == .light {
                self.chatInputTextView.backgroundColor = .spaceGray
                self.chatInputTextView.textColor = .white
                self.chatContainerView.backgroundColor = .spaceGray
                self.backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self.collectionView.backgroundColor = .black
                self.navigationController?.navigationBar.barTintColor = .black
                threeDotsButton.tintColor = .white
                menuView.backgroundColor = .spaceGray
                exitChatButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                
                if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
                    textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
                    navigationController?.navigationBar.titleTextAttributes = textAttributes
                }
                
                navigationController?.navigationBar.barStyle = .black
                
            }else {
                // 밝은 테마일때
                self.chatInputTextView.backgroundColor = .veryLightGray
                self.chatInputTextView.textColor = .black
                self.chatContainerView.backgroundColor = .veryLightGray
                self.backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                self.collectionView.backgroundColor = .white
                self.navigationController?.navigationBar.barTintColor = .white
                threeDotsButton.tintColor = .black
                menuView.backgroundColor = .lightGray
                exitChatButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
                
                if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
                    textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
                    navigationController?.navigationBar.titleTextAttributes = textAttributes
                }
                
                navigationController?.navigationBar.barStyle = .default
            }
        }
    }
    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        tabBarController?.tabBar.isHidden = true
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        }else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tabBarController?.tabBar.isHidden = false

        
    }
    
    // MARK: helpers
    
    
    
    func makeSendButtonEnable(){
        
        self.sendButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.sendButton.backgroundColor = .systemBlue
        self.sendButton.isEnabled = true
        
    }
    
    func makeSendButtonUnabled(){
        
        self.sendButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        self.sendButton.backgroundColor = .lightGray
        self.sendButton.isEnabled = false
    
    }
    
    // MARK: Selectors
    
    @objc func exitChatButtonTapped(){
        
        
        guard let user = self.user else { return }
        
        
        let alert = UIAlertController(title: "정말로 \(user.username)님과의 채팅에서 나가시겠습니까?", message: "채팅방에서 나가시면 이전의 대화 기록들은 모두 삭제되어지며 복구되어질 수 없습니다. \(user.username)님과 다시 매칭 될 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (action) in
            
            ChatService.shared.removeChat(chat: self.chat, me: self.me, user: user) { (error) in
                if let error = error {
                    self.popupDialog(title: "죄송합니다!", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
                }else {
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
            
        }
        
        let noAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel) { (action) in
            print("cancle button tapped")
        }
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func myTapMethod(sender:UITapGestureRecognizer) {
        
        guard let menuViewHeight = self.menuViewHeightConstraint?.constant else { return }
        
        
        if menuViewHeight != 0 {
            
            self.menuViewHeightConstraint?.constant = 0
        } else if chatInputTextView.isFirstResponder == true {
            self.chatInputTextView.resignFirstResponder()
        }
    }
    
    @objc func threeDotsButtonTapped(){
        guard let menuViewHeight = self.menuViewHeightConstraint?.constant else { return }
        if menuViewHeight != 50 {
            self.menuViewHeightConstraint?.constant = 50
        }else {
            self.menuViewHeightConstraint?.constant = 0
        }
        
    }
    
    @objc func sendButtonTapped(){
        print("send button tapped")
        guard let user = user else { return }
        guard let message = chatInputTextView.text else { return }
        chatInputTextView.text = ""
        makeSendButtonUnabled()
        
        MessageService.shared.postMessage(chatId: chat.id, sender: me, text: message, receiver: user) { (error) in
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
                
                let height = collectionView.frame.height
                let contentYoffset = collectionView.contentOffset.y
                let distanceFromBottom = collectionView.contentSize.height - contentYoffset
                
                if height > distanceFromBottom + 50 {
                    self.scrollToBottom()
                }
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
    
    func listenChatDisappear(){
        // 채팅방이 사라지는지 계속 주의를 기울이기
        ChatService.shared.listenChatDisappear(chat: chat) { (error, bool) in
            if let error = error {
                self.popupDialog(title: "죄송합니다!", message: error.localizedDescription, image: #imageLiteral(resourceName: "logo"))
            }else {
                guard let bool = bool else { return }
                
                if bool {
                    // 채팅창 사라짐. 현재 뷰에서 나가버리기
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.userLeave(chatController: self)
                }
            }
        }
    }
    
    func fetchMessages(){
        MessageService.shared.listenMessages(chatId: chat.id) { (error, message, updatedMessage) in
            if let error = error {
                self.popupDialog(title: "죄송해요", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
            }else {
//                self.messages = messages!
                if let message = message {
                    self.messages.append(message)
                    
                }else if let message = updatedMessage {
                    // 모든 메시지를 다 읽음 처리 해야하나?
                    if message.read == true {
                        var index = 0
                        for item in self.messages {
                            if message.id == item.id {
                                break;
                            }
                            index += 1
                        }
                        self.messages.remove(at: index)
                        self.messages.insert(message, at: index)
                    }
                }
                
                self.collectionView.reloadData()
                let height = self.collectionView.frame.height
                let contentYoffset = self.collectionView.contentOffset.y
                let distanceFromBottom = self.collectionView.contentSize.height - contentYoffset
                
                if height > distanceFromBottom + 50 {
                    self.scrollToBottom()
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
        if self.traitCollection.userInterfaceStyle == .dark {
            return .lightContent
        }else {
            return .darkContent
        }
    }
    
    
    
    func configure(){
        
        self.collectionView!.register(MyMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierMyMessage)
        
        self.collectionView!.register(OthersMessageCell.self, forCellWithReuseIdentifier: reuseIdentifierOthersMessage)
        
        configureNavigation()
        fetchUser()
        configureUI()
        fetchMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
        singleTapRecognizer.numberOfTouchesRequired = 1
        singleTapRecognizer.isEnabled = true
        singleTapRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(singleTapRecognizer)
        
    }

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func configureUI(){
        
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.collectionView.backgroundColor = .black
        }else {
            self.collectionView.backgroundColor = .white
        }
        
        
        
        
        
        
        collectionView.contentInset.bottom = 50
        view.addSubview(chatContainerView)
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        chatContainerViewConstraint = chatContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        chatContainerViewConstraint?.isActive = true
        chatContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatContainerViewHeightAnchor = chatContainerView.heightAnchor.constraint(equalToConstant: 50)
        chatContainerViewHeightAnchor?.isActive = true
        
        view.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        menuView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        menuViewWidthContraint = menuView.widthAnchor.constraint(equalToConstant: 100)
        menuViewWidthContraint?.isActive = true
        menuViewHeightConstraint = menuView.heightAnchor.constraint(equalToConstant: 0)
        menuViewHeightConstraint?.isActive = true
        
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
        
        self.navigationItem.title = "\(user.username)"
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            
            if self.traitCollection.userInterfaceStyle == .dark {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
                navigationController?.navigationBar.titleTextAttributes = textAttributes
            }else {
                textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
                navigationController?.navigationBar.titleTextAttributes = textAttributes
            }
            
        }
        
    }
    
    func configureNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: threeDotsButton)
        
//        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loading == false {
            if scrollView.contentOffset.y < -80 {
                loading = true
                // 새로운 데이터를 추가로 불러온다.
                
                
                if let lastMessage = self.messages[0] as Message? {
                    MessageService.shared.fetchOldMessages(chatId: self.chat.id, lastMessage: lastMessage) { (error, messages) in
                        if let error = error {
                            self.popupDialog(title: "죄송합니다", message: error.localizedDescription, image: #imageLiteral(resourceName: "loveOfMidterm"))
                        }else {
                            self.messages.insert(contentsOf: messages!, at: 0)
                            self.collectionView.reloadData()
                            let indexPath = IndexPath(row: messages!.count, section: 0)
                            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
                            self.loading = false
                        }
                    }
                }
                
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myId = Auth.auth().currentUser!.uid
        
        let message = messages[indexPath.row]
        
        let messageText = messages[indexPath.row].text

        let font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        
        let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 250, font: font)
        
        let calendar = Calendar.current
        
        if message.sender == myId {
            // 내 메시지일때
            
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierMyMessage, for: indexPath) as! MyMessageCell
            myCell.message = message
            myCell.textBubbleViewWidthAnchor?.constant = estimatedFrame.width + 25
            
            let date = message.createdAt
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            
            
            // TODO: Get length of timestamp texts
            var timestampText = ""
            if hour == 12 {
                timestampText = "오후 12시 \(minutes)분"
            }else if hour > 12 {
                timestampText = "오후 \(hour - 12)시 \(minutes)분"
            }else {
                timestampText = "오전 \(hour)시 \(minutes)분"
            }
            
            let timestampTextEstimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: timestampText, width: 100, font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium))
            
            // 밑에 메시지가 나의 메시지인데 서로 시간이 같으면 지워주기
            if messages.count - 1 != indexPath.row {
                let nextMessage = messages[indexPath.row + 1]
                let date2 = nextMessage.createdAt
                let hour2 = calendar.component(.hour, from: date2)
                let minute2 = calendar.component(.minute, from: date2)
                if message.sender == nextMessage.sender {
                
                    
                    
                    if hour == hour2 && minutes == minute2 {
                        myCell.timeStamp.isHidden = true
                        myCell.timestampWidthAnchor?.constant = 0
                    }else {
                        myCell.timeStamp.isHidden = false
                        myCell.timestampWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
                    }
                    
                }else {
                    myCell.timeStamp.isHidden = false
                    myCell.timestampWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
                }
            }else {
                myCell.timeStamp.isHidden = false
                myCell.timestampWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
            }
            
            return myCell
            
        }else {
           // 내 메시지가 아닐때
            let estimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: messageText, width: 200, font: font)
            let othersMessage = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierOthersMessage, for: indexPath) as! OthersMessageCell
            othersMessage.message = message
            othersMessage.userId = message.sender
            othersMessage.delegate = self
            othersMessage.textBubbleViewWidthAnchor?.constant = estimatedFrame.width + 25
            
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
            
            let date = message.createdAt
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            var timestampText = ""
            if hour == 12 {
                timestampText = "오후 12시 \(minutes)분"
            }else if hour > 12 {
                timestampText = "오후 \(hour - 12)시 \(minutes)분"
            }else {
                timestampText = "오전 \(hour)시 \(minutes)분"
            }
            
            let timestampTextEstimatedFrame = EstimatedFrame.shared.getEstimatedFrame(messageText: timestampText, width: 100, font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium))
            
            
            // 밑에 메시지가 나의 메시지인데 서로 시간이 같으면 지워주기
            if messages.count - 1 != indexPath.row {
                let nextMessage = messages[indexPath.row + 1]
                if message.sender == nextMessage.sender {
                
                    
                    let date2 = nextMessage.createdAt
                    let hour2 = calendar.component(.hour, from: date2)
                    let minute2 = calendar.component(.minute, from: date2)
                    
                    
                    
                    if hour == hour2 && minutes == minute2 {
                        
                        othersMessage.timestampeWidthAnchor?.constant = 0
                        othersMessage.timeStamp.isHidden = true
            
                    }else {
                        othersMessage.timestampeWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
                        othersMessage.timeStamp.isHidden = false
            
                    }
                    
                }else {
                    othersMessage.timestampeWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
                    othersMessage.timeStamp.isHidden = false
        
                }
            }else {
                othersMessage.timestampeWidthAnchor?.constant = timestampTextEstimatedFrame.width + 5
                othersMessage.timeStamp.isHidden = false
    
            }
            
            
            return othersMessage
        }
    }
    
}

// MARK: Set message cell size
extension ChatController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let messageText = messages[indexPath.row].text

        
        let font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)

        
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
        let profileTypeThreeVC = ProfileControllerTypeThree(user: user)
        navigationController?.pushViewController(profileTypeThreeVC, animated: true)
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
        chatContainerViewHeightAnchor?.constant = height + 20
    }
}
