//
//  FindingPlutoTests.swift
//  FindingPlutoTests
//
//  Created by Mariana on 01.11.2022.
//

import XCTest
@testable import FindingPluto

class ModelsTests: XCTestCase {

    func testInit() {
        let testJSONDict: [String:Any] = ["name": "Stormy",
                                          "size": "Large",
                                          "gender": "female",
                                          "status":"adoptable",
                                          "distance": 45,
                                          "breeds":[
                                            "primary": "Husky",
                                            "secondary": "Shepherd",
                                            "mixed": true,
                                            "unknown": false],
                                          "primary_photo_cropped": [
                                            "small":"https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/58774024/1/?bust=1667743184&width=300",
                                            "medium":"https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/58774024/1/?bust=1667743184&width=450",
                                            "large":"https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/58774024/1/?bust=1667743184&width=600",
                                            "full":"https://dl5zpyw5k3jeb.cloudfront.net/photos/pets/58774024/1/?bust=1667743184"
                                          ]
        ]

        XCTAssertNotNil(Animal(jsonDict: testJSONDict))
    }
}

private extension Animal {
    init?(jsonDict: [String: Any]) {
        
        guard let name = jsonDict["name"] as? String,
              let size = jsonDict["size"] as? String,
              let gender = jsonDict["gender"] as? String,
              let status = jsonDict["status"] as? String,
              let distance = jsonDict["distance"] as? Int,
              let breedsDict = jsonDict["breeds"] as? [String : Any],
              let breed = Breed(dict: breedsDict),
              let photosDict = jsonDict["primary_photo_cropped"] as? [String : String],
              let photoURL = PrimaryPhoto(dict: photosDict) else {
                return nil
        }
        self.init(name: name,
                  breeds: breed,
                  size: size,
                  gender: gender,
                  status: status,
                  distance: distance,
                  imageURL: photoURL)

    }
}

private extension Breed {
    init?(dict: [String : Any]) {
        guard let primary = dict["primary"] as? String,
              let secondary = dict["secondary"] as? String,
              let mixed = dict["mixed"] as? Bool,
              let unknown = dict["unknown"] as? Bool else {
                  return nil
              }
        self.init(primary: primary, secondary: secondary, mixed: mixed, unknown: unknown)
    }
}

private extension PrimaryPhoto {
    init?(dict: [String : String]) {
        guard let small = dict["small"] else {
            return nil
        }
        self.init(small: small)
    }
}
