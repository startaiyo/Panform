//
//  AppDelegate.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/12.
//

import GoogleMaps
import UIKit
import Apollo
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let googleApiKey = Secrets.googleMapApiKey

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(googleApiKey)
        FirebaseApp.configure()
        window = .init(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()

        return true
    }
}
