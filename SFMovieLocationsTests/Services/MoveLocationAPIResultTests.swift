//
//  MoveLocationAPIResultTests.swift
//  SFMovieLocationsTests
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import XCTest

@testable import SFMovieLocations

class MoveLocationAPIResultTests: XCTestCase {

    func testDecoding() throws {
        let bundle = Bundle(for: MoveLocationAPIResultTests.self)
        let url = bundle.url(forResource: "sampledata", withExtension: "json", subdirectory: "TestData")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(MovieLocationAPIResult.self, from: data)
            XCTAssertEqual(1586, result.movieLocations.count)

            let last = result.movieLocations.last!
            XCTAssertEqual("Zodiac", last.title)
            XCTAssertEqual(2007, last.releaseYear)
            XCTAssertEqual("SF Chronicle Building (901 Mission St)", last.location)
            XCTAssertNil(last.funFact)
            XCTAssertEqual("Paramount Pictures", last.productionCompany)
            XCTAssertEqual("Paramount Pictures", last.distributor)
            XCTAssertEqual("David Fincher", last.director)
            XCTAssertEqual("James Vanderbilt", last.writer)
            XCTAssertEqual(["Jake Gyllenhaal", "Mark Ruffalo"], last.actors)

        } catch {
            print(error)
            XCTFail()
            return
        }

    }
}
