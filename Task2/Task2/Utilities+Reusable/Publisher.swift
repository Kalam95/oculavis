//
//  Publisher.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

public typealias ErrorHandler = ((HTTPNetworkError) -> Void)
public typealias DataHandler<T> = ((T)-> Void)

///
/*** This is publisher for ***Reactive Programming***, Which is used to back updating the views via ViewModels and ViewModels via NetworkLayers.
**Note: ** This is simple replacement of PublishSubject of RxSwift or Publisher/Subcriber in Compine, its not exact but i created to just to manage the reactive communication otherwise in general i use RxSwift or somether ways to do so. It is made Generic in aproach.
 */
public class PublishSubject<T> {
    private var errorHanlder: ErrorHandler?
    private var onNextHanlder: DataHandler<T>?

    
    /// This method is used, when some entity wants to listen and update something whenever any or both of the closure emitts
    /// - Parameters:
    ///   - onNext: called when a new data/related item is emitted
    ///   - onError: called when a error has encountered
    public func subscribe(onNext: DataHandler<T>? = nil, onError: ErrorHandler? = nil) {
        onNextHanlder = onNext
        errorHanlder = onError
    }

    /// Function to emmit error
    /// - Parameter error: error to be emitted
    public func onError(_ error: HTTPNetworkError) {
        self.errorHanlder?(error)
    }

    /// Function to emmit data
    /// - Parameter data: Item to be emitted
    public func onNext(_ data: T) {
        self.onNextHanlder?(data)
    }
}
