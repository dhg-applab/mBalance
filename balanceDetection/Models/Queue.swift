//
//  Queue.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 19.06.21.
//

import Foundation

//this is a FIFO queue
struct Queue<T> {
    private var elements: [T] = []

    mutating func enqueue(_ value: T) {
        elements.append(value)
    }

    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }

    var head: T? {
        return elements.first
    }

    var tail: T? {
        return elements.last
    }
}
