//
//  Meme.swift
//  MemeMe-1.0
//
//  Created by Jacob Marttinen on 9/18/16.
//  Copyright © 2016 Jacob Marttinen. All rights reserved.
//

import Foundation
import UIKit

// Defines a Meme object state
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

// save takes in the information defining a Meme and saves it
func save(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
    _ = Meme(
        topText: topText,
        bottomText: bottomText,
        originalImage: originalImage,
        memedImage: memedImage
    )
}
