//
//  ListChatViewController.swift
//  Vida
//
//  Created by Vida.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO

protocol ListChatViewDelegate {
    func addMessageHealthProfessionalResponse(json: [String:JSON])
    func chatListHealthProfessionalsResponse(array: [JSON]?)
}

class ListChatViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewListChat: UITableView!
    
    var listChatUser: [ListChatUserViewModel] = []
    var presenter: ChatPresenter!
    
    fileprivate var manager: SocketManager!
    fileprivate var socket: SocketIOClient!
    fileprivate var delegate: ListChatViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = "Chat com especialistas"
        if (Device.isIPhone4() || Device.isIPhone5()) {
            labelTitle.font = labelTitle.font.withSize(16)
        }
        
        presenter = ChatPresenter(view: self)
        
        tableViewListChat.register(UINib(nibName: "ListChatTableViewCell", bundle: nil),
                                     forCellReuseIdentifier: "ListChatTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.connectSocket()
        
        self.tableViewListChat.reloadData()
        
        self.showSideMenu()
        
        socket.on("connection") { (data, ack) in
            //
        }
        
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
        
        self.hideSideMenu()
    }
    
    @IBAction func pressButtonMenu(_ sender: Any) {
        self.openMenuLeft()
    }
}

extension ListChatViewController {
    fileprivate func connectSocket() {
        manager = SocketManager(socketURL: URL(string: appDelegate.environment.urlChat)!,
                                config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        manager.config = SocketIOClientConfiguration (
            arrayLiteral: .connectParams(["userId": "\((self.appDelegate.login?.user!.id)!)"])
        )
        
        socket.on("add-message-health-professional-response") {data, ack in
            guard let obj = data[0] as? NSDictionary else { return }
            
            if (self.delegate != nil) {
                let json = JSON(obj).dictionaryValue
                self.delegate.addMessageHealthProfessionalResponse(json: json)
            }
        }

        socket.on("chat-list-health-professionals-response") {data, ack in
            guard let obj = data[0] as? NSDictionary else {
                return
            }
            
            let chatList = JSON(obj).dictionaryValue["chatList"]?.array
            if (self.delegate != nil && chatList != nil) {
                self.delegate.chatListHealthProfessionalsResponse(array: chatList!)
            }
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            if (self.appDelegate.login != nil && self.appDelegate.login?.user != nil) {
                self.socket.emit("chat-list-health-professionals",
                                 with: ["\((self.appDelegate.login?.user!.id)!)"])
            }
        }
        
        socket.on(clientEvent: .error) {data, ack in
//            self.showAlert(message: "Erro ao conectar no chat.")
        }
        
        socket.on("chat-list-update") {data, ack in
            if (self.appDelegate.login != nil && self.appDelegate.login?.user != nil) {
                self.socket.emit("chat-list-health-professionals",
                                 with: ["\((self.appDelegate.login?.user!.id)!)"])
            }
        }
        
        socket.on("chat-list-health-professionals-response") {data, ack in
            guard let obj = data[0] as? NSDictionary else {
                return
            }
            let chatList = JSON(obj).dictionaryValue["chatList"]?.array
            
            if chatList != nil && chatList!.count > 0 {
                self.listChatUser.removeAll()
                for item in chatList! {
                    
                    let id = item["id"].intValue
                    var name = item["name"].stringValue
                    var healthSpecialty = item["health_specialty"].stringValue
                    let photo = item["photo"].stringValue
                    let online = item["online"].stringValue
                    
                    name = self.treatStringSocketIO(value: name)
                    healthSpecialty = self.treatStringSocketIO(value: healthSpecialty)
                    
                    self.listChatUser.append(ListChatUserViewModel.init(id: id,
                                                                        name: name,
                                                                        healthSpecialty: healthSpecialty,
                                                                        urlPhoto: "https://s3.us-east-2.amazonaws.com/Vida/profissional/\(photo)",
                                                                        online: online == "0" ? false: true
                    ))
                }
                self.tableViewListChat.reloadData()
                // verifica se veio do push
                if (self.appDelegate.fromUserPush != nil) {
                    // percorre a lista de profissionais
                    for item in self.listChatUser {
                        // teste se o profissional está na lista
                        if (String(item.id) == self.appDelegate.fromUserPush) {
                            self.appDelegate.fromUserPush = nil
                            self.showScreenChat(chatUser: item)
                            break
                        }
                    }
                }
            }
        }
        
        socket.connect()
    }
    
    fileprivate func treatStringSocketIO(value: String) -> String {
        let stringDecoding = String(decoding: value.data(using: .windowsCP1252)!, as: UTF8.self)
        for char in stringDecoding {
            if String(char) == "�" {
                return value
            }
        }
        return stringDecoding
    }
    
    fileprivate func showScreenChat(chatUser: ListChatUserViewModel) {
        self.showLoading()
        presenter.getMessages(fromUserId: (self.appDelegate.login?.user!.id)!,
                              toUserId: chatUser.id,
                              chatUserViewModel: chatUser)
    }
}

extension ListChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listChatUser.count == 0) {
            return 3
        }
        return listChatUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListChatTableViewCell",
                                                 for: indexPath) as! ListChatTableViewCell
        
        cell.selectionStyle = .none
        if self.listChatUser.count > 0 {
            cell.setValues(chatUserViewModel: self.listChatUser[indexPath.row])
        } else {
            cell.realoadSkeletonView()
        }
        
        return cell
    }
}

extension ListChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (listChatUser.count > 0) {
            self.showScreenChat(chatUser: self.listChatUser[indexPath.row])
        }
    }
}

extension ListChatViewController: ChatViewProtocol {
    func returnErrorGetMessages(message: String) {
        self.showAlert(message: message)
    }
    
    func returnSuccessGetMessages(chatUserViewModel: ListChatUserViewModel, messages: [ChatUserViewModel]) {
        var messagesReturn: [ChatUserViewModel] = []
        var startDateOld: String?
        for chatUser in messages {
            let arrayDate: [String] = chatUser.createdDate.components(separatedBy: " ")
            if startDateOld == nil || arrayDate[0] != startDateOld {
                // novo item na lista somente com a data.
                messagesReturn.append(ChatUserViewModel.init(createdDate: chatUser.createdDate))
            }
            messagesReturn.append(chatUser)
            startDateOld = arrayDate[0]
        }
        
        self.hideLoading()
        
        let controller: ChatViewController = ChatViewController(nibName: "ChatViewController",
                                                                bundle: nil)
        
        controller.chatUserViewModel = chatUserViewModel
        controller.messages = messages
        delegate = controller
        
        self.appDelegate.navController!.show(controller, sender: nil)
    }
}
