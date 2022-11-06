//
//  MockAnimal.swift
//  FindingPlutoTests
//
//  Created by Mariana on 06.11.2022.
//

import Foundation
@testable import FindingPluto

extension Animal {
    static func dummy(name: String = "Joey",
                      gender: String = "female",
                      size: String = "small",
                      status: String = "adoptable",
                      breeds: [String : Any] = ["primary":"Husky",
                                                "secondary":"Shepherd",
                                                "mixed": false,
                                                "unknown":false],
                      distance:Int = 20,
                      imageURLs: [String: String] = [ "small":"",
                                                      "medium":"",
                                                      "large":"",
                                                      "full":""]) -> Animal {
        return Animal(name: name,
                      breeds: Breed(primary: breeds["primary"] as? String,
                                    secondary: breeds["secondary"] as? String,
                                    mixed: breeds["mixed"] as! Bool,
                                    unknown: breeds["unknown"] as! Bool),
                      size: size,
                      gender: gender,
                      status: status,
                      distance: distance,
                      imageURL: PrimaryPhoto(small: imageURLs["small"]))
    }
}
