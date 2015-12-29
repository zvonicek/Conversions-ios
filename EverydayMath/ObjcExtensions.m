//
//  ObjcExtensions.m
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

#import "ObjcExtensions.h"

void strokeRectInContext(CGContextRef context, CGRect rect, CGFloat lineWidth, CGFloat radiusLeft, CGFloat radiusRight) {
    CGContextSetLineWidth(context, lineWidth);
    setRectPathInContext(context, rect, radiusLeft, radiusRight);
    CGContextStrokePath(context);
}


void fillRectInContext(CGContextRef context, CGRect rect, CGFloat radiusLeft, CGFloat radiusRight) {
    setRectPathInContext(context, rect, radiusLeft, radiusRight);
    CGContextFillPath(context);
}


void setRectPathInContext(CGContextRef context, CGRect rect, CGFloat radiusLeft, CGFloat radiusRight) {
    CGContextBeginPath(context);
    if (radiusLeft > 0.0 || radiusRight > 0.0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radiusLeft);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radiusRight);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radiusRight);
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radiusLeft);
    } else {
        CGContextAddRect(context, rect);
    }
    CGContextClosePath(context);
}
