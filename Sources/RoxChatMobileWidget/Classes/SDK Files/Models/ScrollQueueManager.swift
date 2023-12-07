//
//  ScrollQueueManager.swift
//  RoxChat
//
//  
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class ScrollQueueManager {

    private var isSusupended: Bool
    private let scrollQueue: DispatchQueue
    private let semaphore = DispatchSemaphore(value: 5)

    init() {
        self.isSusupended = false
        self.scrollQueue = DispatchQueue(label: "com.scrollSerialQueue", qos: .userInteractive)
    }

    // This method perform scrollTasks
    // This method must pause tasks when scroll is running
    // After end of scroll we call method scrollViewDidEndScrollingAnimation
    func perform(kind: TaskKind, _ closure: @escaping (() -> Void)) {
        scrollQueue.async {
            self.semaphore.signal()
            DispatchQueue.main.sync {
                closure()
                guard kind.associatedValue == true else { return }
                self.safeSuspendScrollQueue()
                self.delayedResumeScrollQueue()
            }
            self.semaphore.wait()
        }
    }

    func scrollViewDidEndScrollingAnimation() {
        safeResumeScrollQueue()
    }

    private func safeResumeScrollQueue() {
        guard isSusupended else { return }
        scrollQueue.resume()
        isSusupended.toggle()
    }

    private func safeSuspendScrollQueue() {
        guard !isSusupended else { return }
        scrollQueue.suspend()
        isSusupended.toggle()
    }

    private func delayedResumeScrollQueue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.safeResumeScrollQueue()
        }
    }

    enum TaskKind {
        case reloadTableView
        case scrollTableView(animated: Bool)

        var associatedValue: Bool? {
            switch self {
            case .scrollTableView(let value):
                return value
            default:
                return nil
            }
        }
    }
}


