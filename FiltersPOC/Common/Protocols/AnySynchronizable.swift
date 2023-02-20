//
//  AnySynchronizable.swift
//  Dior Retail App
//
//  Created by Itay Gervash on 27/12/2022.
//  Copyright © 2022 Balink. All rights reserved.
//

import Foundation
import Combine

///Conforms to both ``AnySubscribable`` & ``AnyPublishable``
protocol AnySynchronizable: AnySubscribable, AnyPublishable { }

//MARK: - Any Subscribable

///Implements the ability to subscribe to an object that conforms to AnyPublishable, or any other publisher
protocol AnySubscribable: ObservableObject {
    associatedtype SubscribableValueType
    
    ///New value changes from publisher will be sinked into this variable after calling the subscribe(to:) method
    var updatableValue: SubscribableValueType? { get set }
    
    ///Subscriptions to ``AnyPublishable`` objects and other publishers will be stored in this variable
    var updatableValueSubscribers: Set<AnyCancellable> { get set }
    
    ///Handles new values sent from the publisher that the object is subscrbed to
    /// - Parameter value: The object that is received overtime from a publisher
    func onReceive(newValue value: SubscribableValueType?)
}

extension AnySubscribable {
    
    ///Subscribes to an agendaPublishable, and writes value updates to ``updatableValue``. Calls ``onReceive(newValue:)`` on each value update.
    /// - Parameter anyPublishable: an AnyPublishable object that will send value updates
    ///
    /// - Important: Only works with ``AnyPublishable`` objects that declared their ``AnyPublishable/PublishableValueType`` to be the same as declared in ``SubscribableValueType``
    func subscribe<T: AnyPublishable>(to anyPublishable: T, dropsFirst: Bool = false)
        where T.PublishableValueType == SubscribableValueType {
        
        anyPublishable.updatableValuePublisher
            .receive(on: DispatchQueue.main)
            .dropFirst(dropsFirst ? 1 : 0)
            .sink(receiveValue: { [weak self] newValue in

                self?.updatableValue = newValue
                self?.onReceive(newValue: newValue)
            }).store(in: &updatableValueSubscribers)
    }
    
    
    /// Subscribes to a provided publisher, and writes value updates to ``updatableValue``. Calls ``onReceive(newValue:)`` on each value update.
    /// - Parameter publisher: The publisher that sends value updates
    ///
    /// - Important: Only works with publishers that publish value updates of the same type as declared in  ``SubscribableValueType``
    func subscribe(toChangesOf publisher: Published<SubscribableValueType?>.Publisher, dropsFirst: Bool = false) {
        
            publisher
                .receive(on: DispatchQueue.main)
                .dropFirst(dropsFirst ? 1 : 0)
                .sink(receiveValue: { [weak self] newValue in
                    self?.updatableValue = newValue
                    self?.onReceive(newValue: newValue)
                }).store(in: &updatableValueSubscribers)
    }
    
    func onReceive(newValue value: SubscribableValueType?) { }
    
}

//MARK: - Any Publishable

///Implements the ability to publish value changes to an AnySubscribable object
protocol AnyPublishable: ObservableObject {
    associatedtype PublishableValueType
    
    ///Value changes in this variable will be published to AnySubscribable objects after calling ``publishValue(to:)``
    var publishableValue: PublishableValueType? { get set }

    ///Publishes object changes of ``publishableValue`` over-time
    var updatableValuePublisher: Published<PublishableValueType?>.Publisher { get }
    
}

extension AnyPublishable {
    
    /// Publishes publishableValue object changes over-time to the specified ``AnySubscribable`` object
    ///
    /// - Parameter anySubscribable: an AnySubscribable Object that will receive updates from ``publishableValue``
    ///
    /// - Important: Only works with ``AnySubscribable`` objects that declared their ``AnySubscribable/SubscribableValueType`` to be the same as declared in ``PublishableValueType``
    func publishValue<T: AnySubscribable>(to anySubscribable: T)
        where T.SubscribableValueType == PublishableValueType {
        
        anySubscribable.subscribe(to: self)
    }
    
    /// Publishes object changes over-time, non related to ``publishableValue``,  to the specified ``AnySubscribable`` object
    ///
    /// - Parameter value: a publisher that holds a value to be transmitted to the ``AnySubscribable`` provided in the parameters
    /// - Parameter anySubscribable: an ``AnySubscribable`` object that will receive updated from the provided published
    ///
    /// - Important: Only works with publishers that publish value updates of the same type as declared in anySubscribable's ``AnySubscribable/SubscribableValueType``
    func publish<T: AnySubscribable>(value: Published<T.SubscribableValueType?>.Publisher, to anySubscribable: T) {
        
            anySubscribable.subscribe(toChangesOf: value)
    }
}
