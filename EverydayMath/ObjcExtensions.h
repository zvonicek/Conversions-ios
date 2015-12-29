//
//  ObjcExtensions.h
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void strokeRectInContext(CGContextRef context, CGRect rect, CGFloat lineWidth, CGFloat radiusLeft, CGFloat radiusRight);
void fillRectInContext(CGContextRef context, CGRect rect, CGFloat radiusLeft, CGFloat radiusRight);
void setRectPathInContext(CGContextRef context, CGRect rect, CGFloat radiusLeft, CGFloat radiusRight);
