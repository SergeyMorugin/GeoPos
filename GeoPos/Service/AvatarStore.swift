//
//  AvatarStore.swift
//  GeoPos
//
//  Created by Matthew on 28.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit


class AvatarStore {
    class func save(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("avatar.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    class func load() -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("avatar.png").path)
        }
        return nil
    }
}
