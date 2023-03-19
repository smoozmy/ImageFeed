//
//  GradientView.swift
//  ImageFeed
//
//  Created by Александр Крапивин on 19.03.2023.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
           return CAGradientLayer.classForCoder()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor(named: "YP Gradient")?.cgColor ?? UIColor.black.withAlphaComponent(0.2)]
        }
}
