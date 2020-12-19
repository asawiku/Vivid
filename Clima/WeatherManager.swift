
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = myApiKey //Insert your API keys here
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(lat: Double, lon: Double) {
       let urlString =  "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        self.performRequest(with: urlString)
      }
    
    func performRequest(with urlString: String) {
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //Convert Data to a Swift object
                    if let weather = self.parseJSON(safeData){ // Parse data
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task.
            task.resume()
            
        }
    }
    
    //Decode JSON Data using JSONDecoder and format it using Decodable WeatherData structs
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let lat = decodeData.lat
            let lon = decodeData.lon
            let timezone = decodeData.timezone

            let currentMain = decodeData.current.weather[0].main
            let currentTemp = decodeData.current.temp
            let currentFeelsLike = decodeData.current.feels_like
            let currentDt = decodeData.current.dt
            let currentWind = decodeData.current.wind_speed
            
            let weather = WeatherModel(lat: lat, lon: lon, timezone: timezone, currentTemp: currentTemp, currentFeelsLike: currentFeelsLike, currentMain: currentMain, currentDt: currentDt, currentWind: currentWind)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error) //
            return nil
        }
    }
}




