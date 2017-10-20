//
//  MovieLocationsAPIResult.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import Foundation

// Given that the response format is self-describing, the JSON parsing could be made
// more resilient to changes in the set of columns returned.
struct MovieLocationAPIResult: Decodable {
    var movieLocations: [MovieLocationRecord]

    enum CodingKeys: String, CodingKey {
        case movieLocations = "data"
    }
}

struct MovieLocationRecord: Decodable {
    var title: String
    var releaseYear: Int
    var location: String?
    var funFact: String?
    var productionCompany: String?
    var distributor: String?
    var director: String?
    var writer: String?
    var actors: [String] = []

    /* sample entry:
     [
     1586, "26E9B6AF-8668-4D34-92FA-277561CA580F", 1586, 1477603027, "881420", 1477603027, "881420", null, //metadata
     "Zodiac", // title
     "2007", // release year
     "SF Chronicle Building (901 Mission St)", // location
     null, // fun fact
     "Paramount Pictures", // production company
     "Paramount Pictures", // distributor
     "David Fincher", // director
     "James Vanderbilt", // writer
     "Jake Gyllenhaal", "Mark Ruffalo", null // actors
     ]
     */
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        // skipping values we don't care about
        _ = try container.decode(Int.self)
        _ = try container.decode(String.self)
        _ = try container.decode(Int.self)
        _ = try container.decode(Int.self)
        _ = try container.decode(String.self)
        _ = try container.decode(Int.self)
        _ = try container.decode(String.self)
        _ = try container.decodeNil()

        self.title = try container.decode(String.self)
        let yearString = try container.decode(String.self)
        self.releaseYear = Int(yearString) ?? 0
        self.location = try container.decodeIfPresent(String.self)
        self.funFact = try container.decodeIfPresent(String.self)
        self.productionCompany = try container.decodeIfPresent(String.self)
        self.distributor = try container.decodeIfPresent(String.self)
        self.director = try container.decodeIfPresent(String.self)
        self.writer = try container.decodeIfPresent(String.self)

        while !container.isAtEnd {
            if let actor = try container.decodeIfPresent(String.self) {
                self.actors.append(actor)
            }
        }
    }
}
