
import Foundation

//Confirm to Decodable protocol

struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let wind_speed: Double
    let weather: [CurrentWeather]
}

struct CurrentWeather: Codable {
    let main: String
}

