//
//  CustomMarker.swift
//  GeoPos
//
//  Created by Matthew on 28.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit


class CustomMarker {
    var diameter: CGFloat = 80
    var color: UIColor = .blue
    var avatarBorder: CGFloat = 2
    
    func markerWithAvatar(_ avatar: UIImage?) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter+10), false, 0)
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.saveGState()
            
            // draw marker circle
            let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            ctx.setFillColor(color.cgColor)
            ctx.fillEllipse(in: rect)
            
            // draw bottom marker triangle
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: diameter / 2))
            ctx.addLine(to: CGPoint(x: diameter / 2, y: diameter + 10))
            ctx.addLine(to: CGPoint(x: diameter, y: diameter / 2))
            ctx.closePath()

            ctx.setFillColor(color.cgColor)
            ctx.drawPath(using: .fill)
        
            if let image = avatar {
                let circleImage = image.circleMasked()!
                circleImage.draw(in: CGRect(x: avatarBorder, y: avatarBorder, width: diameter-2*avatarBorder, height: diameter-2*avatarBorder))
            } else {
                let circleImage = UIImage(systemName: "person.fill")!
                circleImage.draw(in: CGRect(x: 4*avatarBorder, y: 4*avatarBorder, width: diameter-8*avatarBorder, height: diameter-8*avatarBorder))
            }
            ctx.restoreGState()
            let img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return img
    }
}



extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    
    func circleMasked()-> UIImage? {
        let breadthSize = CGSize.init(width: breadth, height: breadth)
        let breadthRect = CGRect.init(origin: .zero, size: breadthSize)
        
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
