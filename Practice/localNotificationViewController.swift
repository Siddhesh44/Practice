//
//  localNotificationViewController.swift
//  Practice
//
//  Created by Siddhesh jadhav on 29/05/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import UserNotifications

class localNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "test"
        content.title = "Local Notification"
        content.body = "Received 1 Local Notification"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let url = Bundle.main.url(forResource: "AnimeX_596887", withExtension: "jpeg")
        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        content.attachments = [attachment]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testIdentifire", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let like = UNNotificationAction(identifier: "Like", title: "Like", options: .foreground)
        let delete = UNNotificationAction(identifier: "Delete", title: "Delete", options: .destructive)
        
        let category = UNNotificationCategory(identifier: content.categoryIdentifier, actions: [like,delete], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

}
