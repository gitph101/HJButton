//
//  HJButton.swift
//  HJButton
//
//  Created by 研究院01 on 15/3/31.
//  Copyright (c) 2015年 HJ. All rights reserved.
//
//  @@@ 修改增加注释
import UIKit
import Foundation
class HJButton: UIView,UIGestureRecognizerDelegate {
    enum HJFlashButtonType{
        case hjFlashButtonTypeInner
        case hjFlashButtonTypeOutter
        
    }
    
    let HJFlashInnerCircleInitialRaius:CGFloat = 20.0
    var flashColor : UIColor
    var buttonType : HJFlashButtonType = HJFlashButtonType.hjFlashButtonTypeInner
        {
        willSet
        {
            if buttonType == HJFlashButtonType.hjFlashButtonTypeInner{
                self.clipsToBounds = true
            }
            else{
                self.clipsToBounds = false
            }
        }
        didSet
        {
            if buttonType == HJFlashButtonType.hjFlashButtonTypeInner{
                self.clipsToBounds = true
            }
            else{
                self.clipsToBounds = false
            }
        }
    }
    fileprivate var textLable:UILabel
    

    override init(frame: CGRect) {
        flashColor = UIColor.red
        textLable = UILabel(frame: frame)
        super.init(frame: frame)
        setInit()
    }
    
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    func setInit(){
        textLable.backgroundColor = UIColor.clear
        textLable.textColor = UIColor.white
        textLable.textAlignment = NSTextAlignment.center
        textLable.isUserInteractionEnabled = true
        addSubview(textLable)
        backgroundColor = UIColor.gray
        
        isUserInteractionEnabled = true
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HJButton.didTap(_:)))
        addGestureRecognizer(tap)
    }
    

    
    
    func didTap(_ tapGestureHandler:UITapGestureRecognizer){
    
        var tapLocation : CGPoint = tapGestureHandler.location(in: self)
        var circleShape : CAShapeLayer
        var scale : CGFloat = 1.0
        
        let width:CGFloat = self.bounds.width
        let height:CGFloat = self.bounds.height
        
        if self.buttonType == HJFlashButtonType.hjFlashButtonTypeInner{
            let biggerEdge:CGFloat = width > height ? width : height
            let smallerEdge = width > height ? height : width
            let radius = smallerEdge/2 > HJFlashInnerCircleInitialRaius ? HJFlashInnerCircleInitialRaius:smallerEdge/2
            
            scale = biggerEdge / radius + 0.5
            println(biggerEdge)
            println(radius)
            println(scale)
            circleShape = createCircleShapeWithPosition(CGPoint(x: tapLocation.x - radius, y: tapLocation.y - radius), rect: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2), radius: radius)
        }else{
            scale = 2.5
            circleShape = createCircleShapeWithPosition(CGPoint(x: width/2, y: height/2), rect: CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: width, height: height), radius: layer.cornerRadius)
    
        }
        layer.addSublayer(circleShape)
        var groupAnimation:CAAnimationGroup = createFlashAnimationWithScale(scale, duration: 2.5)
        groupAnimation.setValue(circleShape, forKey: "circleShaperLayer")
        
        circleShape.add(groupAnimation, forKey: nil)
        circleShape.delegate = self
    }
    
    func createCircleShapeWithPosition(_ position:CGPoint,rect:CGRect,radius:CGFloat) -> CAShapeLayer{
        let circleShape:CAShapeLayer = CAShapeLayer()
        circleShape.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        circleShape.position = position
        
        if self.buttonType == HJFlashButtonType.hjFlashButtonTypeInner{
            circleShape.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            if flashColor == UIColor.clear {
                circleShape.fillColor = self.flashColor.cgColor
            }else{
                circleShape.fillColor = UIColor.white.cgColor
            }
        }else{
            circleShape.fillColor = UIColor.clear.cgColor
            circleShape.strokeColor = self.flashColor == UIColor.clear ? flashColor.cgColor : UIColor.purple.cgColor
        }
        
        circleShape.opacity = 0
        circleShape.lineWidth = 1
        
        return circleShape
        
    }
    
    func createFlashAnimationWithScale(_ scale:CGFloat,duration:CGFloat) ->CAAnimationGroup{
    
        var scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale") // 可能有错
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue =  NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, 1))
        
        var alphaAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        
        println(alphaAnimation)
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        var animation:CAAnimationGroup = CAAnimationGroup()
        animation.animations = [scaleAnimation,alphaAnimation]
        animation.delegate = self as! CAAnimationDelegate
        animation.duration =   CFTimeInterval(duration)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func animationDidStop(_ anim: CAAnimation!, finished flag: Bool) {
        let layer: CALayer = anim.value(forKey: "circleShaperLayer") as! CALayer
        layer.removeFromSuperlayer()
    }

}
