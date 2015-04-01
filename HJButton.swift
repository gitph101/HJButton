//
//  HJButton.swift
//  HJButton
//
//  Created by 研究院01 on 15/3/31.
//  Copyright (c) 2015年 HJ. All rights reserved.
//

import UIKit
import Foundation
class HJButton: UIView,UIGestureRecognizerDelegate {
    enum HJFlashButtonType{
        case HJFlashButtonTypeInner
        case HJFlashButtonTypeOutter
        
    }
    
    let HJFlashInnerCircleInitialRaius:CGFloat = 20.0
    var flashColor : UIColor
    var buttonType : HJFlashButtonType = HJFlashButtonType.HJFlashButtonTypeInner
        {
        willSet
        {
            if buttonType == HJFlashButtonType.HJFlashButtonTypeInner{
                self.clipsToBounds = true
            }
            else{
                self.clipsToBounds = false
            }
        }
        didSet
        {
            if buttonType == HJFlashButtonType.HJFlashButtonTypeInner{
                self.clipsToBounds = true
            }
            else{
                self.clipsToBounds = false
            }
        }
    }
    private var textLable:UILabel
    

    override init(frame: CGRect) {
        flashColor = UIColor.redColor()
        textLable = UILabel(frame: frame)
        super.init(frame: frame)
        setInit()
    }
    
     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    func setInit(){
        textLable.backgroundColor = UIColor.clearColor()
        textLable.textColor = UIColor.whiteColor()
        textLable.textAlignment = NSTextAlignment.Center
        textLable.userInteractionEnabled = true
        addSubview(textLable)
        backgroundColor = UIColor.grayColor()
        
        userInteractionEnabled = true
        var tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
        addGestureRecognizer(tap)
    }
    

    
    
    func didTap(tapGestureHandler:UITapGestureRecognizer){
    
        var tapLocation : CGPoint = tapGestureHandler.locationInView(self)
        var circleShape : CAShapeLayer
        var scale : CGFloat = 1.0
        
        let width:CGFloat = self.bounds.width
        let height:CGFloat = self.bounds.height
        
        if self.buttonType == HJFlashButtonType.HJFlashButtonTypeInner{
            let biggerEdge:CGFloat = width > height ? width : height
            let smallerEdge = width > height ? height : width
            let radius = smallerEdge/2 > HJFlashInnerCircleInitialRaius ? HJFlashInnerCircleInitialRaius:smallerEdge/2
            
            scale = biggerEdge / radius + 0.5
            println(biggerEdge)
            println(radius)
            println(scale)
            circleShape = createCircleShapeWithPosition(CGPointMake(tapLocation.x - radius, tapLocation.y - radius), rect: CGRectMake(0, 0, radius * 2, radius * 2), radius: radius)
        }else{
            scale = 2.5
            circleShape = createCircleShapeWithPosition(CGPointMake(width/2, height/2), rect: CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height), radius: layer.cornerRadius)
    
        }
        layer.addSublayer(circleShape)
        var groupAnimation:CAAnimationGroup = createFlashAnimationWithScale(scale, duration: 2.5)
        groupAnimation.setValue(circleShape, forKey: "circleShaperLayer")
        
        circleShape.addAnimation(groupAnimation, forKey: nil)
        circleShape.delegate = self
    }
    
    func createCircleShapeWithPosition(position:CGPoint,rect:CGRect,radius:CGFloat) -> CAShapeLayer{
        var circleShape:CAShapeLayer = CAShapeLayer()
        circleShape.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
        circleShape.position = position
        
        if self.buttonType == HJFlashButtonType.HJFlashButtonTypeInner{
            circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2)
            if flashColor == UIColor.clearColor() {
                circleShape.fillColor = self.flashColor.CGColor
            }else{
                circleShape.fillColor = UIColor.whiteColor().CGColor
            }
        }else{
            circleShape.fillColor = UIColor.clearColor().CGColor
            circleShape.strokeColor = self.flashColor == UIColor.clearColor() ? flashColor.CGColor : UIColor.purpleColor().CGColor
        }
        
        circleShape.opacity = 0
        circleShape.lineWidth = 1
        
        return circleShape
        
    }
    
    func createFlashAnimationWithScale(scale:CGFloat,duration:CGFloat) ->CAAnimationGroup{
    
        var scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale") // 可能有错
        scaleAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        scaleAnimation.toValue =  NSValue(CATransform3D: CATransform3DMakeScale(scale, scale, 1))
        
        var alphaAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        
        println(alphaAnimation)
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        var animation:CAAnimationGroup = CAAnimationGroup()
        animation.animations = [scaleAnimation,alphaAnimation]
        animation.delegate = self
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
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let layer: CALayer = anim.valueForKey("circleShaperLayer") as CALayer
        layer.removeFromSuperlayer()
    }

}
