import UIKit

public struct Place: Codable, Equatable {
  public var id: String

  public var name: String

  public var address: String

  public var stars: Int

  public var reviews: Int

  public var price: String

  public var description: String

  public var imageURL: URL?
}

private struct PlaceResult: Codable {
  var places: [Place]
}

private struct ImageResult: Codable {
  var image: URL

  enum CodingKeys: String, CodingKey {
    case image = "img"
  }
}

public class PlaceFetcher {
  /// Fetches the list of places.
  ///
  /// - Parameters:
  ///   - queue:    The `DispatchQueue` on which the `callback` is called. Default is
  ///               `DispatchQueue.main`.
  ///   - callback: The callback that will be invoked with the list of places or an empty Array in
  ///               case of an error.
  static func loadPlaces(queue: DispatchQueue = .main, callback: @escaping ([Place]) -> Void) {
    let url = URL(string: "https://api.byteboard.dev/data/places")!

    let task = URLSession.shared.dataTask(with: url) { data, response, err in
      let result: [Place]
      if let data = data, err == nil {
        let decoder = JSONDecoder()

        result = (try? decoder.decode(PlaceResult.self, from: data).places) ?? []
        
      } else {
        result = []
      }
      print("result", result)
      queue.async {
        callback(result)
      }
    }

    task.resume()
  }

  /// Fetches the image URL for a `Place` with a given ID.
  ///
  /// - Parameters:
  ///   - placeID:  The ID of the place for which to fetch the image URL.
  ///   - queue:    The `DispatchQueue` on which the `callback` is called. Default is
  ///               `DispatchQueue.main`.
  ///   - callback: The callback that will be invoked with the resulting image URL or `nil` in case
  ///               of an error.
  static func loadImageURL(forPlaceID placeID: String, queue: DispatchQueue = .main, callback: @escaping (URL?) -> Void) {
    let url = URL(string: "https://api.byteboard.dev/data/img")!.appendingPathComponent(placeID)

    let task = URLSession.shared.dataTask(with: url) { data, response, err in
      let result: URL?

      if let data = data, err == nil {
        let decoder = JSONDecoder()

        result = try? decoder.decode(ImageResult.self, from: data).image
      } else {
        result = nil
      }

      queue.async {
        callback(result)
      }
    }

    task.resume()
  }
}

extension PlaceFetcher {
  /// Fetches a list of `Place`s with their `imageURL` property set.
  /// - Parameters:
  ///   - queue:    The `DispatchQueue` on which the `callback` is called. Default is
  ///               `DispatchQueue.main`.
  ///   - callback: The callback that will be invoked with the list of places or an empty Array in
  ///               case of an error.
  static func loadPlacesWithImages(queue: DispatchQueue = .main, callback: @escaping ([Place]) -> Void) {
    var placesWithImageUrls: [Place] = []
    let group = DispatchGroup()
 
    loadPlaces( callback: { places in
      for var place in places {
        group.enter()
        loadImageURL( forPlaceID: place.id) { url in
          place.imageURL = url
          placesWithImageUrls.append(place)
          group.leave()
        }
      }
      group.notify(queue: .main) {
        callback(placesWithImageUrls)
      }
    })
  }
    
}
