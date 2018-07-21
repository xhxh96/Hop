import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowOffsetWidth: Int = 0 {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        }
    }
    
    @IBInspectable var shadowOffsetHeight: Int = 3 {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        }
    }
    
    @IBInspectable var shadowColor: UIColor? = .black {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        
        layer.masksToBounds = false
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
    }
}
