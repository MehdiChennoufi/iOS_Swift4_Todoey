//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 21/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    
    // Creation du fichier et ecriture sur le disque
    do {
        _ = try Realm()
    } catch {
        print("Error initialising new realm, \(error)")
    }
    
    return true
    }

}

