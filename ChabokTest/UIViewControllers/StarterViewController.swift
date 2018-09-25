//
//  StarterViewController.swift
//  ChabokTest
//
//  Created by Hussein Habibi Juybari on 9/25/18.
//  Copyright © 2018 Chabok Realtime Solutions. All rights reserved.
//

import UIKit
import AdpPushClient

class StarterViewController: UIViewController, PushClientManagerDelegate {

    var manager = PushClientManager.default()
    
    @IBOutlet weak var messageLogTextView: UITextView!
    @IBOutlet weak var userIdUITextField: UITextField!
    @IBOutlet weak var channelUITextField: UITextField!
    @IBOutlet weak var tagNamesUITextField: UITextField!
    @IBOutlet weak var connectionStatusUILabel: UILabel!
    @IBOutlet weak var messageTextUITextField: UITextField!
    @IBOutlet weak var connectionStatusUIView: CircleUIView!
    @IBOutlet weak var messageUserIdUITextField: UITextField!
    @IBOutlet weak var messageChannelUITextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager?.addDelegate(self)
        pushClientManagerDidChangedServerConnectionState()
        self.userIdUITextField.text = self.manager?.userId ?? ""
    }
    
    // MARK: - Register Section -- UIButton delegate methods
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userId = self.userIdUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (userId?.count)! > 0 {
            self.manager?.registerUser(userId, registrationHandler: { (isRegistered, userId, error) in
                if (error != nil) {
                    self.showErrorAlert(message: "Could not register user for reason \(String(describing: error))")
                }
            })
        } else {
            self.showErrorAlert(message: "User id is empty. Please, enter a user id to register user.")
        }
    }
    
    @IBAction func unregisterButtonTapped(_ sender: Any) {
        self.manager?.unregisterUser()
        self.userIdUITextField.text = ""
    }
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        let channel = self.channelUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (channel?.count)! > 0 {
            self.manager?.subscribe(channel)
        }
    }
    
    @IBAction func unsubscribeButtonTapped(_ sender: Any) {
        let channel = self.channelUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (channel?.count)! > 0 {
            self.manager?.unsubscribe(channel)
        }
    }
    
    // MARK: - Publish Section -- UIButton delegate methods
    
    @IBAction func publishButtonTapped(_ sender: Any) {
        var message = self.messageTextUITextField.text
        let userId = self.messageUserIdUITextField.text?.trimmingCharacters(in: .whitespaces)
        var channel = self.messageChannelUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (userId?.count)! > 0 {
            if message == "" {
                message = "Hello world! :)"
            }
            if (channel?.count)! == 0 {
                channel = "default"
            }
            let chabokMessage = PushClientMessage.init(message: message, toUserId: userId, channel: channel)
            self.manager?.publish(chabokMessage)
        } else {
            self.showErrorAlert(message: "User id is empty. Please, enter a user id to publish message.")
        }
    }
    
    @IBAction func publishEventButtonTapped(_ sender: Any) {
        var message = self.messageTextUITextField.text
        let eventName = self.messageChannelUITextField.text?.trimmingCharacters(in: .whitespaces)

        if (eventName?.count)! > 0 {
            if message == "" {
                message = "Hello world :)"
            }
            let data = ["msg":message!, "lat" :52 , "lng":35] as [String : Any]
            
            self.manager?.publishEvent(eventName, data: data)
        } else {
            self.showErrorAlert(message: "Eventname is empty. Please, enter a eventnName (channel) to publish event.")
        }
    }
    
    // MARK: - Tag Section -- UIButton delegate methods
    
    @IBAction func removeTagButtonTapped(_ sender: Any) {
        let tagNames = self.tagNamesUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (tagNames?.count)! > 0 {
            let tags = tagNames?.split(separator: ",")
            if tags?.count == 0 {
                self.manager?.removeTag(tagNames, success: { (count) in
                    self.showInfoAlert(message: "Tag is removed from \(count) devices")
                }, failure: { (error) in
                    self.showErrorAlert(message: "Could not removing tag for reason : \(String(describing: error))")
                })
            } else {
                self.manager?.removeTags(tags, success: { (count) in
                    self.showInfoAlert(message: "Tags are removed to \(count) devices")
                }, failure: { (error) in
                    self.showErrorAlert(message: "Could not removing tags for reason : \(String(describing: error))")
                })
            }
        }
    }
    
    @IBAction func addTagButtonTapped(_ sender: Any) {
        let tagNames = self.tagNamesUITextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (tagNames?.count)! > 0 {
            let tags = tagNames?.split(separator: ",")
            if tags?.count == 0 {
                self.manager?.addTag(tagNames, success: { (count) in
                    self.showInfoAlert(message: "Tag is added to \(count) devices")
                }, failure: { (error) in
                    self.showErrorAlert(message: "Could not adding tag for reason : \(String(describing: error))")
                })
            } else {
                self.manager?.addTags(tags, success: { (count) in
                    self.showInfoAlert(message: "Tags are added to \(count) devices")
                }, failure: { (error) in
                    self.showErrorAlert(message: "Could not adding tags for reason : \(String(describing: error))")
                })
            }
        }
    }
    
    // MARK: - Track Section -- UIButton delegate methods

    @IBAction func addToCartButtonTapped(_ sender: Any) {
        self.manager?.track("AddToCart", data: ["capId":12345])
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        self.manager?.track("Purchase", data: ["capId":1234567])
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        self.manager?.track("Like", data: ["postId":54321])
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        self.manager?.track("Comment", data: ["postId":543214])
    }
    
    // MARK: - Chabok delegate methods
    
    func pushClientManagerDidChangedServerConnectionState() {
        let status = self.manager?.connectionState
        
        if status == PushClientServerConnectionState.connectedState {
            self.connectionStatusUILabel.text = "Connected"
            self.connectionStatusUIView.backgroundColor = UIColor.green
        } else if status == PushClientServerConnectionState.connectingState ||
            status == PushClientServerConnectionState.connectingStartState {
            self.connectionStatusUILabel.text = "Connecting"
            self.connectionStatusUIView.backgroundColor = UIColor.yellow
        } else if status == PushClientServerConnectionState.disconnectedState {
            self.connectionStatusUILabel.text = "Disconnected"
            self.connectionStatusUIView.backgroundColor = UIColor.red
        } else {
            self.connectionStatusUILabel.text = "Error"
            self.connectionStatusUIView.backgroundColor = UIColor.red
        }
    }
    
    func pushClientManagerDidFail(inSubscribe error: Error!) {
        if error != nil {
            self.showErrorAlert(message: "Could not subscribe on channel for reaseon : \(String(describing: error))")
        }
    }
    
    func pushClientManagerDidSubscribed(_ channel: String!) {
        self.showInfoAlert(message: "Subscribed on \(String(describing: channel))")
    }
    
    func pushClientManagerDidUnsubscribed(_ channel: String!) {
        self.showInfoAlert(message: "Unsubscribe to \(String(describing: channel))")
    }
    
    func pushClientManagerDidFail(inUnsubscribe error: Error!) {
        if error != nil {
            self.showErrorAlert(message: "Could not unsubscribe to channel for reaseon : \(String(describing: error))")
        }
    }
    
    func pushClientManagerDidFail(inPublish error: Error!) {
        if error != nil {
            self.showErrorAlert(message: "Could not publish for reaseon : \(String(describing: error))")
        }
    }
    
    func pushClientManagerDidReceivedMessage(_ message: PushClientMessage!) {
        if let dict = message.toDict(){
            self.messageLogTextView.text.append("\(dict) \n\n ---------------------- \n")
        }
    }
}
