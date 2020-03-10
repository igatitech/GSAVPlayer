//
//  VideoBase.swift
//  GSAVPlayer
//
//  Created by Gati Shah on 23/02/20.
//  Copyright © 2020 iGatiTech. All rights reserved.
//


import Foundation

public class VideoBase {
	public var videos : Array<Videos>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let videoBase_list = VideoBase.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of VideoBase Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [VideoBase]
    {
        var models:[VideoBase] = []
        for item in array
        {
            models.append(VideoBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let videoBase = VideoBase(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: VideoBase Instance.
*/
	required public init?(dictionary: NSDictionary) {

        if (dictionary["videos"] != nil) { videos = Videos.modelsFromDictionaryArray(array: dictionary["videos"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()


		return dictionary
	}

}
