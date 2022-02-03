import Alamofire
import Foundation

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getAuthToken()
}

class WeatherServiceImpl: WeatherService {
    let url_weather = "http://localhost:3000/v1/weather"
    let url_auth    = "http://localhost:3000/v1/auth"
    let url_hello   = "http://localhost:3000/v1/hello"

    public var token       = ""

    func getAuthToken() -> Void {
        let params: Parameters = [
            "username": "bharath",
            "password": "pass"
        ]

        AF.request(url_auth, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
          .validate(statusCode: 200..<300)
          .responseDecodable(of: Token.self) {
              AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    self.token = jsonObject["accessToken"] as! String
                    //print(self.token)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }
    }
    

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        self.getAuthToken()
        print(token)
        let headers : HTTPHeaders = ["Authorization": "Bearer \(self.token)"]
        print(headers)
        AF.request(url_weather, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                print(temperature)
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}


private struct Token: Decodable {
    let accessToken: String
}
