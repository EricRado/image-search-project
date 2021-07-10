//
//  Debouncer.swift
//  ImageSearchProject
//
//  Created by Eric Rado on 7/10/21.
//

import Foundation

protocol DebouncerDelegate: AnyObject {
    func didFireDebouncer(_ debouncer: Debouncer)
}

final class Debouncer {
    weak var delegate: DebouncerDelegate?
    var delay: Double
    weak var timer: Timer?
    
    init(delay: Double) {
        self.delay = delay
    }
    
    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(fireNow),
            userInfo: nil,
            repeats: false)
        timer = nextTimer
    }
    
    @objc private func fireNow() {
        delegate?.didFireDebouncer(self)
    }
}
