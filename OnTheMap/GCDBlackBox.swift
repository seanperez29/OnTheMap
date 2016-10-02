//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
