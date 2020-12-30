//
//  ViewController.swift
//  Clima
//
//  Created by João Victor Ipirajá de Alencar on 28/12/20.
//

import UIKit
import CoreLocation

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}


class ViewController: UIViewController {
    
    
    @IBOutlet weak var imgviewCondition: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    var weathermanager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weathermanager.delegate = self
        txtSearch.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.LoadingStart()
        locationManager.requestLocation()
   
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        txtSearch.endEditing(true) //dimiss the keyboard
        print(txtSearch.text!)
    }
    
    
    @IBAction func locationClicked(_ sender: UIButton) {
        self.LoadingStart()
        locationManager.requestLocation()
    }
    
    
}

//MARK: - UiTextFieldDelegate

extension ViewController: UITextFieldDelegate{
    
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Try Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.LoadingStart()
        
        if let city = textField.text{
            weathermanager.fetchWeather(in: city)
            
            
        }
        
        self.txtSearch.text = ""
        textField.placeholder = "Search"
        
    }
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel){
        
        DispatchQueue.main.async {
            
            self.lblTemperature.text = weather.temperatureString
            self.imgviewCondition.image = UIImage(systemName: weather.conditionName)
            self.lblCity.text = weather.cityName
            self.LoadingStop()
        }
        
    }
    
    func didFailWithError(error: Error) {
        self.LoadingStop()
        print(error)
        
    }
    
}

//MARK: - locationManagerDelegate

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weathermanager.fetchWeather(latitude: lat, longitude: lon)
            print(lat,lon)
        
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.LoadingStop()
        print(error)
        
    }
}

//MARK: - LoadingScreen

extension UIViewController{
    func LoadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        ProgressDialog.alert.view.addSubview(loadingIndicator)
        
        present(ProgressDialog.alert, animated: true, completion: nil)
    }
    
    func LoadingStop(){
        ProgressDialog.alert.dismiss(animated: true, completion: nil)
    }
    
    
}
