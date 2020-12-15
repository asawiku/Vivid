
import UIKit
import CoreLocation


class WeatherViewController: UIViewController {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        
        //Make cells dynamic
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var itsLabel: UILabel!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iPhoneScreenSizes()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        gradientImage.layer.cornerRadius = 32
        
    }
    
    //Animate refresh button
    @IBAction func refreshPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.9, delay: 0, options: .curveEaseInOut, animations: ({self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi); self.refreshButton.transform = CGAffineTransform.identity}), completion: nil )
        
        locationManager.requestLocation()
    }
}

//MARK: - UIWeatherManagerDelegate

extension WeatherViewController:  WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.itsLabel.text = "It's "
            self.tempLabel.text = "\(weather.currentTempInt)°"
            print(weather.currentMain)
            
            self.gradientImage.image = UIImage (named: weather.tempGradient)
            self.cityLabel.text = weather.city
            self.dayLabel.text = weather.dayOfWeek
        
            switch weather.currentMain {
                
            case "Rain":
                self.descriptionLabel.text = "Boy, it began to rain like a bastard" // In buckets, I swear to God.
                self.bookLabel.text = "Same as in " + #""The catcher in the Rye""#
                
            case "Fog":
                self.descriptionLabel.text = "A thick gray fog brooded over the land"
                self.bookLabel.text = #"Just like in "Anna Karenina""#
                
            case "Clouds":
                self.descriptionLabel.text = "The clouds over the land now rose like mountains"
                self.bookLabel.text = "Just like in " + #""The Old Man and the Sea""#
                
            case "Thunderstorm":
                self.descriptionLabel.text = "Hark, what Himalayas of concussions!"
                self.bookLabel.text = "Same as in " + #""The Lightning-Rod Man""#
                
            case "Drizzle":
                self.descriptionLabel.text = "The drizzle crepitated against the hood of the car"
                self.bookLabel.text = "It's as if you're in " + #""Lolita""#
                
            case "Snow":
                self.descriptionLabel.text = "The flakes, silver and dark, falling obliquely against the lamplight"
                self.bookLabel.text = "It's like you're in James Joyce's " + #""The Dead""#

            default:
                self.descriptionLabel.text = "The sky looks lacquered, clouds are none"
                self.bookLabel.text = "It's like you're in " + #""Moby Dick""#
                
            }
        }
    }
    
    //Transform the date
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: ", error)
    }
}


extension WeatherViewController {
    func iPhoneScreenSizes() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        
        case 320...667.0:
            descriptionLabel.font = descriptionLabel.font.withSize(28)
            itsLabel.font = itsLabel.font.withSize(28)
            tempLabel.font = tempLabel.font.withSize(28)
            bookLabel.font = bookLabel.font.withSize(18)
            dayLabel.font = dayLabel.font.withSize(18)
            
        default:
            print("iPhoneScreen")
        }
    }
    
}


// MARK: - Constants

private enum Constants {
    static let reuseID = "CollectionCell"
}

