//
//  LocalNotificationBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/10.
//

import SwiftUI
import UserNotifications
import CoreLocation

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
        content.body = "이것은 무슨 알림이고 왜 발생되었고 그래서 어떻게 해야하고...등" // 알림의 내용
        content.sound = .default // 알림이 발동됐을 때 들려줄 소리, 치명적인 경우의 소리 등의 옵션이 있음
        content.badge = 1 // 뱃지 노출, 뱃지는 NSNumber 타입이기 때문에 숫자 1로 표시해주었음.
        
        // Time-Based Trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        // Calendar-Based
//        let dateComponents = DateComponents(hour: 00, minute: 00, second: 00)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Location-Based
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: 37.5425, longitude: 126.9669),
            radius: CLLocationDistance(100),
            identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 발동되기를 기다리며 보류 중인 알림 제거
        UNUserNotificationCenter.current().removeAllDeliveredNotifications() // 발동되어 표시된 알림 제거
    }
}

struct LocalNotificationBootcamp: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Request Permission") {
                NotificationManager.shared.requestAuthorization()
            }
            
            Button("Schedule Notification") {
                NotificationManager.shared.scheduleNotification()
            }
            
            Button("Cancel Notification") {
                NotificationManager.shared.cancelNotification()
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

struct LocalNotificationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationBootcamp()
    }
}
