//
//  LocationSettingsViewController.swift
//  iosbingo
//
//  Created by apple on 30/08/22.
//

import UIKit
import CoreLocation
import MapKit
import MobileCoreServices

class LocationSettingsViewController: UIViewController {

    @IBOutlet weak var map_view: MKMapView!
    
    var latitide : Double = 0.0
    var longitude : Double = 0.0
    var city = ""
    var state = ""
    var country = ""
    
    var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.map_view.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func btn_next(_ sender: Any) {
        updateLocation()
    }
    
    func updateLocation(){
        let params = ["latitude" : self.latitide,
                      "longitude" : self.longitude,
                      "location": self.city] as [String:Any]

        print(params)
        API.shared.sendData(url: APIPath.updateUserMetaVar, requestType: .post, params: params, objectType: EmptyModel.self) { (data,status)  in
            if status {
                //guard data != nil else {return}
                self.pushController(controllerName: "DatingAvailabilityViewController", storyboardName: "Main")
            }else{
                AppLoader.shared.hide()
                print("Error found")
            }
        }
    }
    
    func pushController (controllerName:String,storyboardName:String) {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: controllerName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GetCurrentLocationLatLong(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
}
extension LocationSettingsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        if currentLocation == nil {
            // Zoom to user location
            self.latitide = locations.last?.coordinate.latitude ?? 0.0
            self.longitude = locations.last?.coordinate.longitude ?? 0.0
            
            let location = CLLocation(latitude: self.latitide, longitude: self.longitude)
            location.fetchCityAndCountry { city, stateName, country, error in
                guard let city = city, let stateName = stateName, let country = country, error == nil else { return }
                self.city = city
                self.state = stateName
                self.country = country
            }
            
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                map_view.setRegion(viewRegion, animated: false)
            }
        }
    }

}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ stateName: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.administrativeArea, $0?.first?.country, $1) }
    }
}
    
