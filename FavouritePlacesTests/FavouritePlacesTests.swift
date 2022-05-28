//
//  FavouritePlacesTests.swift
//  FavouritePlacesTests
//
//  Created by zak on 29/4/2022.
//

import XCTest
@testable import FavouritePlaces
import CoreLocation
import MapKit

class FavouritePlacesTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testSunriseSunset() throws {
        guard let sun1 = LocationService.shared.lookupSunriseAndSunset("20", "20") else {
            XCTFail("Unable to look up sunrise and sunset times.")
            return
        }
        var sun2 = SunriseSunset(sunrise: "test", sunset: "test")
        let sunAPI = SunriseSunsetAPI(results: sun2, status: nil)
        let testString: String = "test"
        let testString2: String = "4:58am"
        let testString3: String = "5:49pm"
        let testStringOp: String? = nil
        
        XCTAssert((sun1.sunrise as Any) is String)
        XCTAssert((sun1.sunset as Any) is String)
        
        XCTAssertEqual(sunAPI.results, sun2)
        XCTAssert(sunAPI.status == testStringOp)
        XCTAssert((sunAPI.results as Any) is SunriseSunset)
        XCTAssert((sunAPI.status as Any) is String?)
        
        XCTAssert(sun2.sunrise == testString)
        XCTAssert(sun2.sunset == testString)
        sun2.sunrise = testString2
        XCTAssert(sun2.sunrise == testString2)
        sun2.sunset = testString3
        XCTAssert(sun2.sunset == testString3)
    }
    
    func testLocationService() throws {
        var coords1: CLLocation = CLLocation()
        var coords2: CLLocation = CLLocation()
        let locString: String = "Sydney"
        
        LocationService.shared.lookupCoordinates(locString) {
            (newCoords) in
            coords1 = newCoords
            
            XCTAssert(coords1 == newCoords)
            
            LocationService.shared.lookupCoordinates(locString) {
                (newCoords2) in
                coords2 = newCoords2
                
                XCTAssert(coords1 == coords2)
            }
        }
        
        let coords3: CLLocation = CLLocation(latitude: -28.6468558, longitude: 153.602905)
        var locString2: String = String()
        var locString3: String = String()
        let locString4: String = "Byron Bay"
        
        LocationService.shared.lookupName(coords3) {
            (newName) in
            locString2 = newName
            
            XCTAssert(locString2 == newName)
            XCTAssert(locString2 == locString4)
            
            LocationService.shared.lookupName(coords3) {
                (newName2) in
                locString3 = newName2
                
                XCTAssert(locString3 == newName2)
                XCTAssert(locString3 == locString4)
            }
        }
    }
    
    func testMKCoordRegionVM() throws {
        var coord: MKCoordinateRegion = MKCoordinateRegion()
        let testLatDoub: Double = 30.05
        let testLngDoub: Double = 29.35
        let testLatStr: String = String(testLatDoub)
        let testLngStr: String = String(testLngDoub)
        
        coord.latitudeString = testLatStr
        coord.longitudeString = testLngStr
        
        XCTAssert(coord.latitudeString == testLatStr)
        XCTAssert(coord.longitudeString == testLngStr)
        XCTAssert(coord.center.latitude == testLatDoub)
        XCTAssert(coord.center.longitude == testLngDoub)
        
        coord.center.latitude = testLatDoub
        coord.center.longitude = testLngDoub
        
        XCTAssert(coord.latitudeString == testLatStr)
        XCTAssert(coord.longitudeString == testLngStr)
        XCTAssert(coord.center.latitude == testLatDoub)
        XCTAssert(coord.center.longitude == testLngDoub)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
