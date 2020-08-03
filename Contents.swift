import UIKit

// MARK: - Goals
// Fetch the people
// Also fetch the movies that person was in?

// Endpoints
    let peopleEndPoint = "people"
    

struct Person: Decodable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let episode_id: Int
    let opening_crawl: String
    let director: String
    let producer: String
    let release_date: String
    
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                completion(film)
            } catch {
                print("Error decoding the film data.")
            }
            } .resume()
        
    }
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // Prepare the URL
        guard let baseURL = baseURL else { return completion(nil)}
        let secondToLast = baseURL.appendingPathComponent(peopleEndPoint)
        let finalURL = secondToLast.appendingPathComponent(String(id))
        print(finalURL)
        
        // Contact the Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print("Error decoding the data")
                return completion(nil)
            }
            } .resume()

        
        // Handle all/any errors
        
        // Check for data
        
        // Decode Person from JSON
    }
    
    
    
}
SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
    print(person.name)
    for film in person.films {
        fetchFilm(url: film)
    }
  }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}
