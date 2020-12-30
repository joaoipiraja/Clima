//
//  WeatherData.swift
//  Clima
//
//  Created by João Victor Ipirajá de Alencar on 29/12/20.
//

import Foundation

struct weatherData: Codable{
    
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Main:Codable{
    let temp: Double
}

struct Weather: Codable{
    let id:Int

}
