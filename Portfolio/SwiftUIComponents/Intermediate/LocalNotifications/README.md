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
    * 알림 기능을 도맡아줄 NotificationManager 클래스를 생성하고, 알림 기능을 활용하기 위해 UserNotification을 import 했다.
    * UNUserNotificationCenter.current()에 접근하여 앱에서 사용하게 될 알림의 종류와 핸들링 처리를 어떻게 할지 선언해주는 requestAuthorization 메서드이다.
> 이 메서드를 작동시키면 앱에서 사용자에게 알림을 보내도 되는지 허가를 요청하게 된다.
> 이때 허용 또는 허용 안함의 응답에 대하여 분기가 이루어지게 되므로 이에 따라 적절한 처리를 위해서는 핸들링 클로저를 작성하면 된다.

----------------------------------------------------------------------

## 로컬 알림을 발동하는 장치
* 1. Time-Based
특정 시간에 맞춰 로컬 알림을 발동할 수 있다.

* 2. Calendar-Based
캘린더를 사용하여 날짜를 기준으로 로컬 알림을 발동할 수 있다.

* 3. Location-Based
위치를 기준으로 로컬 알림을 발동할 수 있다.

----------------------------------------------------------------------



----------------------------------------------------------------------
