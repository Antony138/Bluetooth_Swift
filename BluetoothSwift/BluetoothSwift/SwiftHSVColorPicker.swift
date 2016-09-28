//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit

protocol SwiftHSVColorPickerDelegate{
    
//    func touchColorWheel(view:SwiftHSVColorPicker,color:UIColor)
      func touchColorWheel(view:SwiftHSVColorPicker,color:UIColor,brightness:CGFloat,colorR:CGFloat,colorG:CGFloat,colorB:CGFloat)
}


public class SwiftHSVColorPicker: UIView {
    var colorWheel: ColorWheel!
    public var color: UIColor!
    
    var isInitColorWheel:Bool = true
    
    var colorPickerTag:Int = 0
    public var colorDic = [Int:UIColor]()
    var hueDic = [Int:CGFloat]()
    var saturationDic = [Int:CGFloat]()
    var brightnessDic = [Int:CGFloat]()
    
    var delegate:SwiftHSVColorPickerDelegate! = nil
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.backgroundColor = UIColor.blueColor()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setViewColor(color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        
        self.color = color
        
        var i: Int
        for i = 0; i < 8; i += 1 {
            brightnessDic[i] = brightness
            colorDic[i] = color
            hueDic[i] = hue
            saturationDic[i] = saturation
        }
        
        setup()
    }
    
    //三个视图的初始化
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }

        let height = self.frame.size.height
        let width = self.frame.size.width
        
        // Init new ColorWheel subview
        colorWheel = ColorWheel(frame: CGRect(x: 0, y: 0, width: width, height: height), color: self.color)
        colorWheel.colorPicker = self

        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)
        colorWheel.setConstraints()

    }
    
    //MARK:-设置约束
    func setConstraints(){
        
        if self.superview != nil{
            self.translatesAutoresizingMaskIntoConstraints = false
            self.superview!.translatesAutoresizingMaskIntoConstraints = false
            let leadingConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0.0)
            let trailingConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0.0)
            let topConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0.0)
            
            self.superview?.addConstraints([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
            
        }
    }
    
    //MARK:-回调设置饱和度和色调
    func hueAndSaturationSelected(hue: CGFloat, saturation: CGFloat) {
        
        hueDic[colorPickerTag] = hue
        saturationDic[colorPickerTag] = saturation
        colorDic[colorPickerTag] = UIColor(hue: hueDic[colorPickerTag]!, saturation: saturationDic[colorPickerTag]!, brightness: brightnessDic[colorPickerTag]!, alpha: 1.0)
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        colorDic[colorPickerTag]!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        var colorR: CGFloat = 0.0, colorG: CGFloat = 0.0, colorB: CGFloat = 0.0
        colorDic[colorPickerTag]!.getRed(&colorR, green: &colorG, blue: &colorB, alpha: &alpha)
        
//        print("--------------亮度为-\(brightness*255)--colorR-\(colorR*255)--colorG-\(colorG*255)--colorB-\(colorB*255)")
        
        delegate.touchColorWheel(self, color: colorDic[colorPickerTag]!, brightness: brightness*255, colorR: colorR*255, colorG: colorG*255, colorB: colorB*255)
        
        
    }
    
    //MARK:-回调设置明亮度
    func brightnessSelected(brightness: CGFloat) {

        brightnessDic[colorPickerTag] = brightness
        colorDic[colorPickerTag] = UIColor(hue: hueDic[colorPickerTag]!, saturation: saturationDic[colorPickerTag]!, brightness: brightnessDic[colorPickerTag]!, alpha: 1.0)
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        colorDic[colorPickerTag]!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        var colorR: CGFloat = 0.0, colorG: CGFloat = 0.0, colorB: CGFloat = 0.0
        colorDic[colorPickerTag]!.getRed(&colorR, green: &colorG, blue: &colorB, alpha: &alpha)
        
       
        delegate.touchColorWheel(self, color: colorDic[colorPickerTag]!, brightness: brightness*255, colorR: colorR*255, colorG: colorG*255, colorB: colorB*255)
        
    }
}
