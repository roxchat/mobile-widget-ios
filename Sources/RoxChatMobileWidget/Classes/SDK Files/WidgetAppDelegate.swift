//
//  WidgetAppDelegate.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2017 Roxchat. All rights reserved.
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
import RoxchatClientLibrary

public protocol WidgetAppDelegateProtocol {
    func applicationDidEnterBackground()
}

public class WidgetAppDelegate: WidgetAppDelegateProtocol {

    public static var shared = WidgetAppDelegate()
    
    static var bundle: Bundle = {
    #if SWIFT_PACKAGE
        return Bundle.module
    #else
        return Bundle(for: WidgetAppDelegate.self)
    #endif
    }()
    
    
    var isApplicationConnected: Bool
    var applicationWasInactive: Bool
    
    init() {
        isApplicationConnected = true
        applicationWasInactive = false
    }
    
    public func applicationDidEnterBackground() {
        applicationWasInactive = true
    }

    func checkMainThread() {
        if !Thread.isMainThread {
        #if DEBUG
            fatalError("Not main thread error")
        #else
            print("Not main thread error")
        #endif
        }
    }
    
    private enum BundleConstants {
        static let resourcesName = "Resources"
        static let bundleExtension = "bundle"
    }
}


extension UIApplication {
    static func sharedInstance() -> UIApplication? {
        #if TARGET_IS_EXTENSION
            return nil
        #else
            return UIApplication.shared
        #endif
    }
}
