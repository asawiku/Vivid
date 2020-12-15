
import UIKit
import CoreLocation

//Initialize this struct in WeatherManager
struct WeatherModel {
    
    //Location
    let lat: Double
    let lon: Double
    let timezone: String
    
    //Current weather
    let currentTemp: Double
    let currentFeelsLike: Double
    let currentMain: String
    let currentDt: Int
    let currentWind: Double
    
    //Turn Double temp into an Int
    var currentTempInt: Int {
        return Int(currentTemp)
    }
    
    //Convert date into human format
    var dayOfWeek: String {
        let date = Date(timeIntervalSince1970: TimeInterval(currentDt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let fullDate = dateFormatter.string(from: date)
        return fullDate
    }
    
    var city: String {
        timezone.cityParsed()
    }
    
    var tempGradient: String {
        
        switch currentTempInt {
            
        case 11...17:
            return "chilly"
            
        case Int.min...10:
            return "cold"
            
        default:
            return "warm"
        }
    }
    
    func retreiveCityName(latitude: Double, longitude: Double, completionHandler: @escaping (String?) -> Void)
    {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon), completionHandler:
            {
                placeMarks, error in
                
                completionHandler(placeMarks?.first?.locality)
        })
    }
    
}





