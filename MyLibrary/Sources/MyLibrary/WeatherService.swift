import Alamofire
import Foundation

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String, Error>) -> Void)
    func getAuthToken(completion: @escaping (_ authToken: String) -> Void)
}

extension Request {
   public func debugLog() -> Self {
      #if DEBUG
         debugPrint(self)
       print(self.request?.headers)
      #endif
      return self
   }
}

class WeatherServiceImpl: WeatherService {
    let urlWeather = "http://localhost:3000/v1/weather"
    let urlAuth    = "http://localhost:3000/v1/auth"
    let urlHello   = "http://localhost:3000/v1/hello"


    func getAuthToken(completion: @escaping (_ authToken: String) -> Void) -> Void {
        let params: Parameters = [
            "username": "bharath",
            "password": "pass"
        ]

        AF.request(urlAuth, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
          .validate(statusCode: 200..<300)
          .responseDecodable(of: Token.self) {
              AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    let token = jsonObject["accessToken"] as! String
                    completion(token)
                    
                    
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    completion("")
                }
            }
    }
    

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        self.getAuthToken(completion: { authToken in
            let headers : HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
            AF.request(self.urlWeather, method: .get, headers: headers)
                .debugLog()
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Weather.self) { response in
                
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

        })
    }


    func getGreeting(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        self.getAuthToken(completion: { authToken in
            let headers : HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
            AF.request(self.urlHello, method: .get, headers: headers)
                .debugLog()
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Greeting.self) { response in
                
                switch response.result {
                case let .success(hello):
                    let message = hello.greeting 
                    print(message)
                    completion(.success(message))
    
                case let .failure(error):
                    completion(.failure(error))
                }
            }

        })
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

private struct Greeting: Decodable {
    let greeting: String
}
