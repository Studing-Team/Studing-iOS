//
//  UIControl+.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit
import Combine

extension UIControl {
    /// Control Publisher
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
      }
    
    /// Event Publisher
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<T>(subscriber: T) where T: Subscriber, Never == T.Failure, UIControl == T.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    /// Event Subscription
    private class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}
