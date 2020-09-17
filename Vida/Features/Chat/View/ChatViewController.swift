//
//  ChatViewController.swift
//  Vida
//
//  Created by Vida.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO
import Kingfisher

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var textFieldMessage: UITextField!
    @IBOutlet weak var constraintBottonViewTextField: NSLayoutConstraint!
    @IBOutlet weak var buttonSendMessage: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecialty: UILabel!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    
    var chatUserViewModel: ListChatUserViewModel!
    var messages: [ChatUserViewModel] = []
    
    fileprivate var manager: SocketManager!
    fileprivate var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.imageView?.tintColor = Color.primary.value
        
        labelName.textColor = Color.primary.value
        buttonSendMessage.imageView!.tintColor = UIColor.white
        buttonSendMessage.backgroundColor = Color.second.value
        buttonSendMessage.layer.cornerRadius = buttonSendMessage.frame.width / 2
        
        let sizeImageViewLogged: CGSize = imageViewPhoto.frame.size
        imageViewPhoto.layer.cornerRadius = sizeImageViewLogged.width / 2

        self.remoteIsOnline(isOnline: chatUserViewModel.online)
        
        if (Device.isIPhone4() || Device.isIPhone5()) {
            labelName.font = labelName.font.withSize(13)
            labelSpecialty.font = labelSpecialty.font.withSize(9)
        }
        
        self.tableViewChat.register(UINib(nibName: "ChatLocalTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "ChatLocalTableViewCell")
        self.tableViewChat.register(UINib(nibName: "ChatRemoteTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "ChatRemoteTableViewCell")
        self.tableViewChat.register(UINib(nibName: "ChatDateTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "ChatDateTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)),
                                               name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)),
                                               name: UIWindow.keyboardWillHideNotification, object: nil)
        tableViewChat.reloadData()
        
        tableViewChat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboad(_:))))
        
        getValues()
        
        ChatPresenter.init().registerAccessProfessionalChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.connectSocket()
        
        self.scrollToBottom()

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on(clientEvent: .error) {data, ack in
            print("socket error")
        }

        socket.on(clientEvent: .reconnect) {data, ack in
            print("socket reconnect")
        }

        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnect")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        socket.disconnect()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.appDelegate.navController?.popViewController(animated: true)
    }
    
    @IBAction func pressButtomSendMessage(_ sender: Any) {
        let message: String = textFieldMessage.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if message != "" {
            let dict: Dictionary = ["message": textFieldMessage.text!,
                                    "fromUserId": (self.appDelegate.login?.user!.id)!,
                                    "toUserId": chatUserViewModel!.id] as [String : Any]
            
            if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                if let content = String(data: json, encoding: String.Encoding.ascii) {
                    // envia mensagem
                    socket.emit("add-message-health-professional", content)
                    
                    let dateToday: String = Util.convertFromDateToString(date: Date(), format: "dd/MM/yyyy HH:mm")
                    let chatUser: ChatUserViewModel! = ChatUserViewModel.init(createdDate: dateToday,
                                                      message: textFieldMessage.text!,
                                                      isLocal: true,
                                                      fromUserId: (self.appDelegate.login?.user!.id)!,
                                                      toUserId: chatUserViewModel.id)
                    if messages.count > 0 {
                        let lastItem: ChatUserViewModel = messages.last!
                        let arrayDateToday: [String] = dateToday.components(separatedBy: " ")
                        let arrayCreatedDate: [String] = lastItem.createdDate.components(separatedBy: " ")
                        if arrayDateToday[0] != arrayCreatedDate[0] {
                            // novo item na lista somente com a data.
                            messages.append(ChatUserViewModel.init(createdDate: dateToday))
                        }
                    } else {
                        messages.append(ChatUserViewModel.init(createdDate: dateToday))
                    }
                    messages.append(chatUser)
                    textFieldMessage.text = ""
                    tableViewChat.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }
}

extension ChatViewController {
    
    @objc func closeKeyboad(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    fileprivate func remoteIsOnline(isOnline: Bool) {
        imageViewPhoto.layer.borderWidth = 3
        if isOnline {
            imageViewPhoto.layer.borderColor = UIColor(red: 41.0/255.0, green: 144.0/255.0, blue: 52.0/255.0, alpha: 1.0).cgColor
        } else {
            imageViewPhoto.layer.borderColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
        }
    }
    
    fileprivate func getValues() {
        labelName.text = chatUserViewModel.name
        labelSpecialty.text = chatUserViewModel.healthSpecialty.uppercased()
        imageViewPhoto.kf.setImage(
            with: URL(string: chatUserViewModel.urlPhoto),
            placeholder: UIImage(named: "iconMenuLogged"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(Constrants.kTransitionFadeImage)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Sucesso: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func connectSocket() {

        manager = SocketManager(socketURL: URL(string: appDelegate.environment.urlChat)!,
                                config: [.log(true), .compress])
        socket = manager.defaultSocket

        manager.config = SocketIOClientConfiguration (
            arrayLiteral: .connectParams(["userId": "\((self.appDelegate.login?.user!.id)!)"])
        )

        socket.connect()
    }
    
    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.constraintBottonViewTextField.constant = keyBoardHeight
                self.scrollToBottom()
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification){
        self.keyBoardWillHide()
    }
    
    fileprivate func keyBoardWillHide() {
        self.constraintBottonViewTextField.constant = 0.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func scrollToBottom() {
        if messages.count > 0 {
            tableViewChat.scrollToBottom()
        }
    }
}

extension ChatViewController: ListChatViewDelegate {
    
    func addMessageHealthProfessionalResponse(json: [String : JSON]) {
        self.messages.append(ChatUserViewModel.init(createdDate: json["createdDate"]!.stringValue,
                                                    message: json["message"]!.stringValue,
                                                    isLocal: false,
                                                    fromUserId: json["fromUserId"]!.intValue,
                                                    toUserId: json["toUserId"]!.intValue))
        self.tableViewChat.reloadData()
        self.scrollToBottom()
    }
    
    func chatListHealthProfessionalsResponse(array: [JSON]?) {
        if array != nil && array!.count > 0 {
            for item in array! {
                let id = item["id"].intValue
                let online = item["online"].stringValue

                if self.chatUserViewModel.id == id {
                    if online == "1" {
                        self.remoteIsOnline(isOnline: true)
                    } else {
                        self.remoteIsOnline(isOnline: false)
                    }
                    break
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatUser: ChatUserViewModel = messages[indexPath.row]
        let arrayDate: [String] = chatUser.createdDate.components(separatedBy: " ")
        if chatUser.newSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatDateTableViewCell",
                                                     for: indexPath) as! ChatDateTableViewCell
            
            cell.labelDate.text = arrayDate[0]
            return cell
        } else {
            if chatUser.isLocal {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLocalTableViewCell",
                                                         for: indexPath) as! ChatLocalTableViewCell
                
                cell.labelMessage.text = chatUser.message
                cell.labelHour.text = arrayDate[1]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRemoteTableViewCell",
                                                         for: indexPath) as! ChatRemoteTableViewCell
                
                cell.labelMessage.text = chatUser.message
                cell.labelHour.text = arrayDate[1]
                return cell
            }
        }
    }
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pressButtomSendMessage(self)
        return true
    }
}

extension UITableView {
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
