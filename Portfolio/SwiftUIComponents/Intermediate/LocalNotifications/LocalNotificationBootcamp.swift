//
//  LocalNotificationBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/10.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error { print("Error: \(error)") } else { print("Success") }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목" // 알림의 제목
        content.subtitle = "알림 소제목" // 알림의 제목으로 모두 표현하지 못할 때는 소제목도 추가
        content.sound = .default // 알림이 발동됐을 때 들려줄 소리, 치명적인 경우의 소리 등의 옵션이 있음
        content.badge = 1 // 뱃지 노출, 뱃지는 NSNumber 타입이기 때문에 숫자 1로 표시해주었음.
        
        /**
         
         */
        let request = UNNotificationRequest(identifier: <#T##String#>, content: <#T##UNNotificationContent#>, trigger: <#T##UNNotificationTrigger?#>)
    }
}

struct LocalNotificationBootcamp: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Request Permission") {
                NotificationManager.shared.requestAuthorization()
            }
        }
    }
}

struct LocalNotificationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationBootcamp()
    }
}
