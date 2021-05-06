//
//  ViewController.swift
//  NotificationsTest
//
//  Created by Игорь Козлов on 15.02.2021.
//

import UIKit
import UserNotifications
import AVFoundation

class ViewController: UIViewController {
    var player: AVAudioPlayer?
    
   
  //Пишем 2 метода один будет отправлять уведомления в очередь для отправки а второй будет удалять их из очереди

    @IBAction func sendNotification(_ sender: UIButton) {
        scheduleNotification(inSeconds: 5) { (success) in
            if success {
                 print("sended notification is complitly!")
            } else {
                print("I get some trouble")
            }
        }
    }
    //Данное уведомление можно послать ДАЖЕ ЕСЛИ ПРИЛОВЕНИЕ ЗАКРЫТО!!!!!!
    func scheduleNotification(inSeconds seconds: TimeInterval, comletion: (Bool)-> ()) {// передаём время через которое будет отправляться уведомление, комплишн нужен что бы определить удалось отправитть или нет и в случае неудачи или удачи что-то делать
        
        //Если ранее было отправлено такое же уведомление, то более старое нужно удалить
        removeNotifications(withIdentifiers: ["MyUniqueIdentifier"])
        
        let date = Date(timeIntervalSinceNow: seconds)//Дата относительно текущего момента
        print(Date())
        print(date)
        
        
        //Уведомления состоят из нескольких частей:
        //content
        let content = UNMutableNotificationContent()
        content.title = "This is title of NOTIFICATION"
        content.body = "This is body of our notification"//Основной текст уведомления
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "song.caf"))
//
//        //MARK: - TEST
//        do {
//            let path = Bundle.main.path(forResource: "song", ofType: "mp3")
//            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
//        } catch {
//            print("I get some truble")
//        }
//        player?.play()
//        //content.sound = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName("song.mp3"), withAudioVolume: 1.0)
//
//
//        //MARK: - END TEST

        //Так как работаем с компонентами даты, то мы  должны указать календарь, относительно которого будем брать эти компоненты
        let calendar = Calendar(identifier: .gregorian)//грегорианский календарь
        //т.к. дата -набор компонентов - состовной обект( месяц год и т д)
        //так как работаем берём месяц, день, час, минуты, секунды
        let  components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)//От куда берём компоненты - date
        
        //Создаём триггер - обект, который позволяет отправлять уведомление по заданной дате
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        //Создаём запрос в NOtification center
        let request = UNNotificationRequest(identifier: "MyUniqueIdentifier", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)// После добавления ничего делать не будем
        
    }
    
    //Функция удаления запросов на уведомления из очереди NotificationCenter.current
    func removeNotifications(withIdentifiers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}

