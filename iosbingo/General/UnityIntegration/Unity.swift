import Foundation
import UnityFramework

class Unity: UIResponder, UIApplicationDelegate, NativeCallsProtocol {

    // The structure for Unity messages
    private struct UnityMessage {
        let objectName: String?
        let methodName: String?
        let messageBody: String?
    }
    
    var profileData:ProfileModel?
    
    var unityMode: UnityLoadMode = UnityLoadMode.DEMO_MODE
    
    var lifeSpectrum: SpectrumResponse?
    
    var loadSwiftView: ((String) -> Void)?

    private var cachedMessages = [UnityMessage]() // Array of cached messages

    static let shared = Unity()

    private let dataBundleId: String = "com.unity3d.framework"
    private let frameworkPath: String = "/Frameworks/UnityFramework.framework"

    private var ufw : UnityFramework?
    private var hostMainWindow : UIWindow?

    private var isInitialized: Bool {
        ufw?.appController() != nil
    }

    func show() {
        if isInitialized {
            showWindow()
        } else {
            initWindow()
        }
    }

    func setHostMainWindow(_ hostMainWindow: UIWindow?) {
        self.hostMainWindow = hostMainWindow
    }

    private func initWindow() {
        if isInitialized {
            showWindow()
            return
        }

        guard let ufw = loadUnityFramework() else {
            print("ERROR: Was not able to load Unity")
            return unloadWindow()
        }

        self.ufw = ufw
        
        ufw.setDataBundleId(dataBundleId)
        ufw.register(self)
        NSClassFromString("FrameworkLibAPI")?.registerAPIforNativeCalls(self)
        ufw.runEmbedded(
            withArgc: CommandLine.argc,
            argv: CommandLine.unsafeArgv,
            appLaunchOpts: nil
        )

        sendCachedMessages() // Added this line
    }

    private func showWindow() {
        if isInitialized {
            ufw?.showUnityWindow()
            sendCachedMessages() // Added this line
        }
    }

     func unloadWindow() {
        if isInitialized {
            cachedMessages.removeAll() // Added this line
            ufw?.unloadApplication()
        }
    }

    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath: String = Bundle.main.bundlePath + frameworkPath

        let bundle = Bundle(path: bundlePath)
        if bundle?.isLoaded == false {
            bundle?.load()
        }

        let ufw = bundle?.principalClass?.getInstance()
        if ufw?.appController() == nil {
            let machineHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
            machineHeader.pointee = _mh_execute_header

            ufw?.setExecuteHeader(machineHeader)
        }
        return ufw
    }
    
    func unload() {
        ufw?.unloadApplication()
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
       }

    // Main method for sending a message to Unity
    func sendMessage(
        _ objectName: String,
        methodName: String,
        message: String
    ) {
        let msg: UnityMessage = UnityMessage(
            objectName: objectName,
            methodName: methodName,
            messageBody: message
        )

        // Send the message right away if Unity is initialized, else cache it
        if isInitialized {
            ufw?.sendMessageToGO(
                withName: msg.objectName,
                functionName: msg.methodName,
                message: msg.messageBody
            )
        } else {
            cachedMessages.append(msg)
        }
    }

    // Send all previously cached messages, if any
    private func sendCachedMessages() {
        if cachedMessages.count >= 0 && isInitialized {
            for msg in cachedMessages {
                ufw?.sendMessageToGO(
                    withName: msg.objectName,
                    functionName: msg.methodName,
                    message: msg.messageBody
                )
            }

            cachedMessages.removeAll()
        }
    }
    
    func loadUnityFromProfile(fromVC: UIViewController) {

        let lifeSpectrum = LifeSpectrum()
        AppUserDefault.shared.selectedCategoryIndex = 0
       
        Unity.shared.unityMode = .Profile_MODE
        
        if let profile = Unity.shared.profileData {
            
            AppUserDefault.shared.selectedCategoryIndex = AppUserDefault.shared.selectedCategoryIndex
            lifeSpectrum.unityModuleState = Unity.shared.unityMode.rawValue
            
            lifeSpectrum.audioURL = profile.spectrum.audioFile
            lifeSpectrum.aspectsOfMyLife = profile.spectrum.aspectsToLife
            lifeSpectrum.day = profile.spectrum.lastUpdated
           
            lifeSpectrum.aspectsOfMyLife =  AppUserDefault.shared.getValueInt(for: .aspectsOfMyLife)
            
            if  let audioURL = URL(string: AppUserDefault.shared.getValue(for: .lifeInventoryAudioURL)) {
                lifeSpectrum.audioURL = audioURL.absoluteString
            }
            
            if  AppUserDefault.shared.getValue(for: .inventoryLastUpdated) != "" {
                lifeSpectrum.day = AppUserDefault.shared.getValue(for: .inventoryLastUpdated)
            }
            
            if let url = URL(string: profile.avatar) {
                lifeSpectrum.imageURL = url.absoluteString
            }
            
            lifeSpectrum.registrationLevel = AppUserDefault.shared.selectedCategoryIndex
            
            let aspects = Aspects()
            lifeSpectrum.aspects = aspects

            let encoder = JSONEncoder()
            
            let data = try! encoder.encode(lifeSpectrum)
            
            let json = String(data: data, encoding: .utf8)!
            print(json)
            
            AppLoader.shared.hide()
            
            Unity.shared.setHostMainWindow(UIApplication.shared.windows.first!)
            Unity.shared.show()
            
            Unity.shared.sendMessage(
                "Recieve From Host App Message",
                methodName: "MessageFromHostiOSApp",
                message: json)
            
            Unity.shared.loadSwiftView = { message in
                print(message)
                
                if let state = message.components(separatedBy: ",").first,  let value = state.components(separatedBy: ":").last, value == "3" {
                    
                        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UpdateValueInventoryViewController") as! UpdateValueInventoryViewController
                        vc.profileModel = profile
                        fromVC.navigationController?.pushViewController(vc, animated: true)
                    
                } else if let state = message.components(separatedBy: ",").first,  let value = state.components(separatedBy: ":").last, value == "2" {
                    
                    let nav = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    
                    UIApplication.shared.windows.first?.rootViewController = nav
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                    
                } else {
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ToValueMeReportViewController") as! ToValueMeReportViewController
                    fromVC.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
        }
    }
}

extension Unity: UnityFrameworkListener {

    private func unityDidUnload(_: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
        hostMainWindow?.makeKeyAndVisible()
    }
    func back(fromUnity message: String!) {
      
        print(message)
        if let loadSwiftView = loadSwiftView {
            loadSwiftView(message)
        }
        //your code
        //UnityFramework.sh
        Unity.shared.unload()
    }
    


    func backFromUnity(message: String)
    {
        print(message)
        //your code
        //UnityFramework.sh
        Unity.shared.unloadWindow()
    }
    
}
