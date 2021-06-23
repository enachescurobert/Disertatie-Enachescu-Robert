//
//  UIImage+Extension.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
