//
//  GCDBlackBox.swift
//  moviesWithMVC
//
//  Created by Mohamed Sayed on 9/9/18.
//  Copyright © 2018 Mohamed Sayed. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
