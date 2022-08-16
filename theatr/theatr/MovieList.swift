//
//  MovieList.swift
//  theatr
//
//  Created by Austin Hwa on 3/16/22.
//

import Foundation

struct Response: Codable {
    let _embedded: ShowTimesList
}

struct ShowTimesList: Codable {
    let showtimes: [ShowInfo]
}

struct ShowInfo: Codable {
    let movieName: String
    let theatreId: Int
    let showDateTimeLocal: String
    let showDateTimeUtc: String
    let mobilePurchaseUrl: String
}

class Movie: Hashable {
    var title: String
    var location: String
    var time: Date
    var ticketLink: String

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        if lhs.title == rhs.title && lhs.location == rhs.location && lhs.time == rhs.time {
            return true
        }
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    init(title: String, location: String, time: Date, ticketLink: String) {
        self.title = title
        self.location = location
        self.time = time
        self.ticketLink = ticketLink
    }
}

class MovieList: ObservableObject {
    @Published var movies: [Movie]
    
    let dateFormatter = DateFormatter()
    let URLstring = "https://api.amctheatres.com/v2/showtimes/views/current-location/"
    
    init() {
        movies = []
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss"
        dateFormatter.timeZone = .current
    }
    
    
    func formatAPIURL (currDate: Date, lon: Double, lat: Double) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M-dd-yyyy"
        formatter.timeZone = .current
        let formattedDate = formatter.string(from: currDate)
        
        return URLstring + formattedDate + "/" + String(lat) + "/" + String(lon) + "?pageSize=1000"
    }
    
    
    func updateMovies(currDate: Date, lon: Double, lat: Double) {
        
        let finalURL: String = formatAPIURL(currDate: currDate, lon: lon, lat: lat)
        
        Task {
            do {
                
                let response = try await apiCall(url: finalURL)
                
                DispatchQueue.main.async {
                    
                    self.movies.removeAll()
                    
                    for mov in response._embedded.showtimes {
                        
                        
                        let showTime = self.convertTimeToDate(lt: mov.showDateTimeLocal)
                        if (showTime <= currDate) {
                            continue
                        }
                        
                    
                        let purUrl: String = mov.mobilePurchaseUrl
                        let splitsville = String(purUrl.dropFirst().dropLast()).components(separatedBy: "/")
                        let theater: String = splitsville[6]
                        
                        var res = theater.replacingOccurrences(of: "[1-9][0-9]",
                                                  with: " $0",
                                                  options: .regularExpression)
                        
                        let first = String(res.prefix(1)).capitalized
                        let other = String(res.dropFirst())
                        
                        res = first + other
                        
                        res = "AMC " + res
                        
                        self.movies.append(Movie(title: mov.movieName, location: res, time: showTime, ticketLink: mov.mobilePurchaseUrl))

                    }

                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func apiCall(url: String)  async throws -> Response {
        
        guard let urlStr = URL(string: url) else {
            fatalError("Bad URL")
        }
        
        var req = URLRequest(url: urlStr)
        
        req.httpMethod = "GET"
        req.setValue("9F65AEE8-0A86-4A07-BF7D-67DC8A9FFA5B", forHTTPHeaderField: "X-AMC-Vendor-Key")
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let res = try JSONDecoder().decode(Response.self, from: data)
        
        return res
    }
    
    
    func convertTimeToDate (lt: String) -> Date {
        return dateFormatter.date(from: lt)!
    }
    
}
