//
//  WeatherManager.swift
//  Clima
//
//  Created by João Victor Ipirajá de Alencar on 29/12/20.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager{
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let appId:String = ""
    private let unit:String = "metric"
    var delegate:WeatherManagerDelegate?
    
    
    func fetchWeather(latitude:CLLocationDegrees , longitude:CLLocationDegrees){
        let urlString = "\(self.weatherURL)?lat=\(latitude)&lon=\(longitude)&units=\(self.unit)&appid=\(self.appId)"
        print(urlString)
        self.performRequest(with: urlString)
        
    }
    
    func fetchWeather(in cityName:String){
        let urlString = "\(self.weatherURL)?q=\(cityName)&units=\(self.unit)&appid=\(self.appId)"
        print(urlString)
        self.performRequest(with: urlString)
        
    }
    
    
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(wd: safeData){
                        
                        self.delegate?.didUpdateWeather(self, weather:weather)
                        
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    
    private func parseJSON(wd: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let d = try decoder.decode(weatherData.self, from: wd)
            let id = d.weather[0].id
            let temp = d.main.temp
            let name = d.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
    
    
}
