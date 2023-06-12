//
//  SceneDelegate.swift
//  iosbingo
//
//  Created by Hamza Saeed on 19/07/2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        redirectUsertoScreen(scene)
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func redirectUsertoScreen(_ scene: UIScene){
        if AppUserDefault.shared.getValueInt(for: .IsLoggedIn) == 0 {
            if let windowScene = scene as? UIWindowScene {
                 let window = UIWindow(windowScene: windowScene)
                let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
                  window.rootViewController = nav
                  self.window = window
                  window.makeKeyAndVisible()
             }
        }else{
            var profileData : UserExistsModel?
            do {
                profileData = try AppUserDefault.shared.sharedObj.getObject(forKey: .userData, castTo: UserExistsModel.self)
                print(profileData!)
            } catch {
                print(error.localizedDescription)
            }
            
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//                 window.rootViewController = nav
//                 self.window = window
//                 window.makeKeyAndVisible()
//            }
            
//            if let windowScene = scene as? UIWindowScene {
//                let window = UIWindow(windowScene: windowScene)
//                let nav : UIViewController? = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//                window.rootViewController = nav
//                self.window = window
//                window.makeKeyAndVisible()
//            }
            
            if let windowScene = scene as? UIWindowScene {
                  let window = UIWindow(windowScene: windowScene)
                  var nav : UIViewController?
                  if(profileData?.registrationStatus == ""){
                     nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                  }else if(profileData?.registrationStatus == "name"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NameViewController") as! NameViewController
                  }else if(profileData?.registrationStatus == "email"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
                  }else if(profileData?.registrationStatus == "birthday"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BirthdayViewController") as! BirthdayViewController
                  }else if(profileData?.registrationStatus == "notification"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationSettingsViewController") as! NotificationSettingsViewController
                  }else if(profileData?.registrationStatus == "photo"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UploadProfileViewController") as! UploadProfileViewController
                  }else if(profileData?.registrationStatus == "location"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationSettingsViewController") as! LocationSettingsViewController
                  }else if(profileData?.registrationStatus == "availability"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DatingAvailabilityViewController") as! DatingAvailabilityViewController
                  } else if(profileData?.registrationStatus == "radar"){
                      AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                      nav = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
                   } else if(profileData?.registrationStatus == "catalog"){
                       AppUserDefault.shared.set(value: true, for: .isUserRegistering)
                       nav = UIStoryboard(name: "Dating", bundle: nil).instantiateViewController(identifier: "DateNightCatelogCoverViewController") as! DateNightCatelogCoverViewController
                      
                    } else {
                       AppUserDefault.shared.set(value: false, for: .isUserRegistering)
                       AppUserDefault.shared.set(value: 1, for: .IsLoggedIn)
                      nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                  }
                
                //reclamation status
//                const WELCOME_STAGE = "welcome";
//                const INVITEE_DEMO_STAGE = "demo";
//                const LEVEL_THREE = "start";
//                const LEVEL_THREE_PENDING = "pending";
                
                  let navViewController = UINavigationController(rootViewController: nav ?? UIViewController())
                  navViewController.isNavigationBarHidden = true
                  window.rootViewController = navViewController
                  self.window = window
                  window.makeKeyAndVisible()
             }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for urlContext in URLContexts {
          let url = urlContext.url
          Auth.auth().canHandle(url)
      }
      // URL not auth related; it should be handled separately.
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.scheduleAppProcessing()
//            appDelegate.scheduleAppRefresh()
//        }
    }


}

