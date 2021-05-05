//
//  UIView+Layout.swift
//  xChange
//
//  Created by Alessio on 2021-04-05.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    static func verticalSpaceView(of height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        return view
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = CGAffineTransform(rotationAngle: radians)
        self.transform = rotation
    }
    
    func updateLayoutTopmostSuperview() {
        var topmostSuperview = superview
        while topmostSuperview?.superview != nil {
            topmostSuperview = topmostSuperview?.superview
        }
        topmostSuperview?.layoutIfNeeded()
    }
    
    static func spacer(color: UIColor, height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.tag = 90210
        spacer.backgroundColor = color
        spacer.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return spacer
    }
}

extension UIView {
    func withBorders(for edges:UIRectEdge..., width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}
