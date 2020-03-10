//
//  Videos.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 23/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//


import Foundation

public class Videos {
	public var description : String?
	public var sources : String?
	public var subtitle : String?
	public var thumb : String?
	public var title : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let videos_list = Videos.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Videos Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Videos]
    {
        var models:[Videos] = []
        for item in array
        {
            models.append(Videos(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let videos = Videos(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Videos Instance.
*/
	required public init?(dictionary: NSDictionary) {

		description = dictionary["description"] as? String
        sources = dictionary["sources"] as? String
		subtitle = dictionary["subtitle"] as? String
		thumb = dictionary["thumb"] as? String
		title = dictionary["title"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.sources, forKey: "sources")
		dictionary.setValue(self.subtitle, forKey: "subtitle")
		dictionary.setValue(self.thumb, forKey: "thumb")
		dictionary.setValue(self.title, forKey: "title")

		return dictionary
	}

}
