//
//  PluggableApplicationDelegate.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

open class PluggableApplicationDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    open var services: [ApplicationService] {
        return []
    }

    private lazy var lazyServices: [ApplicationService] = {
        self.services
    }()

    @discardableResult
    private func apply<T, S>(_ work: (ApplicationService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Swift.Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []

        for service in lazyServices {
            dispatchGroup.enter()
            let returned = work(service) { result in
                results.append(result)
                dispatchGroup.leave()
            }
            if let returned = returned {
                returns.append(returned)
            } else {
                dispatchGroup.leave()
            }
            if returned == nil {}
        }

        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }

        return returns
    }
}

extension PluggableApplicationDelegate {
    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return lazyServices.allSatisfy {
            $0.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? true
        }
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return lazyServices.allSatisfy {
            $0.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
        }
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return lazyServices.allSatisfy {
            $0.application?(app, open: url, options: options) ?? true
        }
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return lazyServices.allSatisfy {
            $0.application?(application, continue: userActivity, restorationHandler: restorationHandler) ?? true
        }
    }
}

extension PluggableApplicationDelegate {
    public func applicationWillEnterForeground(_ application: UIApplication) {
        lazyServices.forEach { $0.applicationWillEnterForeground?(application) }
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        lazyServices.forEach { $0.applicationDidEnterBackground?(application) }
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        lazyServices.forEach { $0.applicationDidBecomeActive?(application) }
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        lazyServices.forEach { $0.applicationWillResignActive?(application) }
    }
}

extension PluggableApplicationDelegate {
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        lazyServices.forEach { $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply({ (service, completionHandler) -> Void? in
            service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }, completionHandler: { results in
            let result = results.min(by: { $0.rawValue < $1.rawValue }) ?? .noData
            completionHandler(result)
        })
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        lazyServices.forEach { $0.userNotificationCenter?(center, willPresent: notification, withCompletionHandler: completionHandler) }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        lazyServices.forEach { $0.userNotificationCenter?(center, didReceive: response, withCompletionHandler: completionHandler) }
    }
}
