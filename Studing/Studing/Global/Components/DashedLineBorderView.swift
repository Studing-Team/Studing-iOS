//
//  DashedLineBorderView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import UIKit

class DashedLineBorderView: UIView {

    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 20)

        UIColor.white.setFill()
        path.fill()

        UIColor.black10.setStroke()
        path.lineWidth = 5

        let dashPattern : [CGFloat] = [12, 6]
        path.setLineDash(dashPattern, count: 2, phase: 0)
        path.stroke()
    }
}
