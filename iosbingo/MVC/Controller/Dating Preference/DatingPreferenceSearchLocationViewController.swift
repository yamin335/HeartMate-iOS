//
//  DatingPreferenceSearchLocationViewController.swift
//  iosbingo
//
//  Created by Hamza Saeed on 27/10/2022.
//

import UIKit
import MapKit

protocol LocationData{
    func selectedLocation(data:[String:Any])
}

class DatingPreferenceSearchLocationViewController: UIViewController,UITextFieldDelegate, MKLocalSearchCompleterDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var searchResultsTable: UITableView!

    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var locationModel = [String:Any]()
    var delegate : LocationData?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        txtFieldSearch.addTarget(self, action: #selector(textFieldDidChange(_:)),for: UIControl.Event.editingChanged)
    }

    //MARK: - Custom Functions

    @objc func textFieldDidChange(_ textField: UITextField) {
        searchCompleter.queryFragment = textField.text!
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        searchResults = completer.results
        searchResultsTable.reloadData()
    }

        //MARK: - Btn Actions

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


extension DatingPreferenceSearchLocationViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTable.dequeueReusableCell(withIdentifier: "DatingPreferenceLocationTableViewCell") as! DatingPreferenceLocationTableViewCell
        let searchResult = searchResults[indexPath.row]
        cell.lblCity.text = "\(searchResult.title), \(searchResult.subtitle)"
        cell.lblFlag.text = countryFlag(countryCode: "US")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DatingPreferenceSearchLocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }

            guard let name = response?.mapItems[0].name else {
                return
            }

            let lat = coordinate.latitude
            let lon = coordinate.longitude

            print(lat)
            print(lon)
            print(name)

            let location = CLLocation(latitude: lat, longitude: lon)
            location.fetchCityAndCountry { city, stateName, country, error in
                var selectedCity = ""
                var selectedCountry = ""
                var selectedState = ""
                if let aCity = city {
                    selectedCity = aCity
                }
                if let aCountry = country {
                    selectedCountry = aCountry
                }
                if let aState = stateName {
                    selectedState = aState
                }

                self.locationModel = ["latitude":lat as Double,"longitude":lon as Double,"city":selectedCity,"state":selectedState,"country":selectedCountry]
                self.delegate?.selectedLocation(data: self.locationModel)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
