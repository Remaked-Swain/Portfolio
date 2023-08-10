#  Local Notifications
앱 내에서 사용될 푸시 알림을 만들 수 있다. 다른 사용자가 누른 좋아요 반응이나 댓글이 달렸을 때 알림 등은 서버를 거쳐서 오는 외부 알림이기 때문에 더욱 복잡한 로직으로 구성된다.
그러나 이 문서에서는 앱 내에서 사용될 푸시 알림에 대해서 설명하고, 이 기술에 익숙해지면 서버를 통한 외부 알림을 구현하는 방법으로 넘어가자.

## UserNotification
알림 기능을 활용하기 위한 프레임워크.

```Swift
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error { print("Error: \(error)") } else { print("Success") }
        }
    }
}
```
    * 알림 수신 동의
    1. 알림 기능을 도맡아줄 NotificationManager 클래스를 생성하고, 알림 기능을 활용하기 위해 UserNotification을 import 했다.
    2. UNUserNotificationCenter.current()에 접근하여 앱에서 사용하게 될 알림의 종류와 핸들링 처리를 어떻게 할지 선언해주는 requestAuthorization 메서드이다.
> 이 메서드를 작동시키면 앱에서 사용자에게 알림을 보내도 되는지 허가를 요청하게 된다.
> 이때 허용 또는 허용 안함의 응답에 대하여 분기가 이루어지게 되므로 이에 따라 적절한 처리를 위해서는 핸들링 클로저를 작성하면 된다.

----------------------------------------------------------------------

## 로컬 알림을 발동하는 장치
* 1. Time-Based
이벤트 발생 후 특정 시간이 경과하면 로컬 알림을 발동할 수 있다.

```Swift
class NotificationManager {
    // 생략...
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목" // 알림의 제목
        content.subtitle = "알림 소제목" // 알림의 제목으로 모두 표현하지 못할 때는 소제목도 추가
        content.body = "이것은 무슨 알림이고 왜 발생되었고 그래서 어떻게 해야하고...등" // 알림의 내용
        content.sound = .default // 알림이 발동됐을 때 들려줄 소리, 치명적인 경우의 소리 등의 옵션이 있음
        content.badge = 1 // 뱃지 노출, 뱃지는 NSNumber 타입이기 때문에 숫자 1로 표시해주었음.
        
        // Time-Based Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
```
    * 알림 설정
    1. UNMutableNotificationContent() 객체를 생성하고 알림의 각 요소를 채워준다.
    2. UNTimeIntervalNotificationTrigger 객체에 이벤트 발생 후 발동 시간과 반복 여부를 지정한다. 이 예제에서는 이벤트 발생 후 5초 뒤, 반복 없음 조건으로 트리거를 생성하였다.
    3. UNNotifictionRequest 객체에 요소를 담는다. 특정 알림에 대해 추적하고 관리하기 위해서 identifier 매개변수가 필요한데, 우리 예제에서는 특별한 동작을 원하는게 아니기 때문에 그냥 uuidString을 주었다.
    4. UNUserNotificationCenter에 알림을 등록한다. 알림이 발동된 후 뭔가를 작업하고 싶으면 역시 핸들러를 작성하면 된다.

* 2. Calendar-Based
캘린더를 사용하여 특정 시간이나 날짜를 기준으로 로컬 알림을 발동할 수 있다.

```Swift
class NotificationManager {
    // 생략...
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목" // 알림의 제목
        content.subtitle = "알림 소제목" // 알림의 제목으로 모두 표현하지 못할 때는 소제목도 추가
        content.body = "이것은 무슨 알림이고 왜 발생되었고 그래서 어떻게 해야하고...등" // 알림의 내용
        content.sound = .default // 알림이 발동됐을 때 들려줄 소리, 치명적인 경우의 소리 등의 옵션이 있음
        content.badge = 1 // 뱃지 노출, 뱃지는 NSNumber 타입이기 때문에 숫자 1로 표시해주었음.
        
        // Calendar-Based
        let dateComponents = DateComponents(hour: 00, minute: 00, second: 00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
```

    * 알림 설정
    1. 위와 동일
    2. UNCalendarNotificationTrigger 객체에 특정 날짜, 시간과 반복 여부를 지정한다. 이 예제에서는 매일 0시 정각에 반복되도록 트리거를 생성하였다.
    3. 위와 동일
    4. 위와 동일

* 3. Location-Based
위치를 기준으로 로컬 알림을 발동할 수 있다.

```Swift
import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager {
    // 생략...
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목" // 알림의 제목
        content.subtitle = "알림 소제목" // 알림의 제목으로 모두 표현하지 못할 때는 소제목도 추가
        content.body = "이것은 무슨 알림이고 왜 발생되었고 그래서 어떻게 해야하고...등" // 알림의 내용
        content.sound = .default // 알림이 발동됐을 때 들려줄 소리, 치명적인 경우의 소리 등의 옵션이 있음
        content.badge = 1 // 뱃지 노출, 뱃지는 NSNumber 타입이기 때문에 숫자 1로 표시해주었음.
        
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
}
```

    * 알림 설정
    1. 위치 정보를 다루기 위하여 CoreLocation 프레임워크를 import 한다. 다른 것은 위와 동일.
    2. UNLocationNotificationTrigger 객체에 위치와 반복 여부를 지정한다. 이 예제에서는 나의 모교의 경, 위도 값으로 위치를 지정하였다.
        2-1. 특히 위치는 좌표 값과 주변 범위, 식별자로 구성되며 범위는 미터 단위이다.
        2-2. 이렇게 설정된 위치에 들어갈 때, 나갈 때에 따라 알림을 발동시킬지 결정할 수 있다.
    3. 위와 동일
    4. 위와 동일

----------------------------------------------------------------------

## 로컬 알림을 취소하는 장치
알림을 취소할 수 있다.

```Swift
class NotificationManager {
    // 생략...
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 발동되기를 기다리며 보류 중인 알림 제거
        UNUserNotificationCenter.current().removeAllDeliveredNotifications() // 발동되어 표시된 알림 제거
    }
}
```

    * 알림 제거
    1. removeAllPendingNotificationRequests() 메서드는 로컬 알림이 발동되지 않은 상황에서 대기열에 있는 알림을 제거한다.
    2. removeAllDeliveredNotifications() 메서드는 발동되어 표시된 알림을 제거한다.
> 알림을 제거하는 메서드는 상황 별로 다양하게 구비되어 있으니 필요할 때 적절한 메서드를 호출하여 알림을 취소하면 된다.

----------------------------------------------------------------------

## View
NotificationManager 를 사용하여 각종 알림 코드를 테스트 해볼 수 있는 뷰이다.

```Swift
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
```

> .onAppear() 메서드를 사용하여 알림이 발동됐을 때 앱 아이콘에 나타난 뱃지를 사라지게 했다.
