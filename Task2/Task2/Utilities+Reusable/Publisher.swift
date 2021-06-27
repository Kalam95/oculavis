//
//  Publisher.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

public typealias ErrorHandler = ((HTTPNetworkError) -> Void)
public typealias DataHandler<T> = ((T)-> Void)

public class PublishSubject<T> {
    private var errorHanlder: ErrorHandler?
    private var onNextHanlder: DataHandler<T>?
    func subscribe(onNext: DataHandler<T>? = nil, onError: ErrorHandler? = nil) {
        onNextHanlder = onNext
        errorHanlder = onError
    }

    public func onError(_ error: HTTPNetworkError) {
        self.errorHanlder?(error)
    }

    public func onNext(_ data: T) {
        self.onNextHanlder?(data)
    }
}
