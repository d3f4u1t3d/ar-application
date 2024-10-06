//
//  AppDelegate.swift
//  AR-Edu-App
//
//  Created by Priyadharshan Raja on 25/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        deleteDocumentsFolder()
        return true
    }

    func deleteDocumentsFolder() {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
                for file in contents {
                    let filePath = documentsDirectory.appendingPathComponent(file).path
                    try fileManager.removeItem(atPath: filePath)
                }
                print("Documents folder cleared.")
            } catch {
                print("Failed to clear documents folder: \(error)")
            }
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    func applicationWillTerminate(_ application: UIApplication) {
            // Call the function to clear the Documents directory
            clearDocumentsDirectory()
        }

        // Function to clear the Documents directory
    func clearDocumentsDirectory() {
            let fileManager = FileManager.default
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    let filePaths = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                    for filePath in filePaths {
                        try fileManager.removeItem(at: filePath)
                        print("Removed file at: \(filePath)")
                    }
                    print("Documents directory cleared.")
                } catch {
                    print("Could not clear documents directory: \(error)")
                }
            }
        }
    }

