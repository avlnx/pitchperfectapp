//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Thyago Silva on 07/09/15.
//  Copyright (c) 2015 Avalanche. All rights reserved.
//

import Foundation

class RecordedAudio
{
    var filePathUrl : NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!) {
        self.filePathUrl = filePathUrl
        self.title = filePathUrl.lastPathComponent
    }
}