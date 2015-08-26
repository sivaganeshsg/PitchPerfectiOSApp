//
//  RecordedAudio.swift
//  Pitch Perfect App
//
//  Created by Siva Ganesh on 25/07/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import Foundation


class RecordedAudio : NSObject {

    var title : String!
    var filePathURL : NSURL!
    
    init(title: String, filePathURL : NSURL) {
        self.title = title
        self.filePathURL = filePathURL
    }
    
}
