//
//  SetCardView.m
//  Matchismo
//
//  Created by Juan C. Catalan on 18/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [roundedRect addClip];
    
    if (self.isFaceUp)
        [[UIColor lightGrayColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSetCard];
}

- (void)drawSetCard
{
    switch (self.symbol) {
        case 1:
            [self drawDiamond];
            break;
        case 2:
            [self drawSquiggle];
            break;
        case 3:
            [self drawOval];
            break;
    }
}

#define SQUIGGLE_LONG_DIAGONAL_DELTA_X_RATIO 0.594
#define SQUIGGLE_DIAGONAL_DELTA_Y_RATIO 0.12
#define SQUIGGLE_SHORT_DIAGONAL_DELTA_X_RATIO 0.462
#define SQUIGGLE_CONTROL_DELTA_X_RATIO 0.132
#define SQUIGGLE_CONTROL_DELTA_Y_RATIO 0.16
#define SQUIGGLE_LINE_WIDTH 2.0

- (void)drawSquiggle
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize shortDiagonal = CGSizeMake(middle.x * SQUIGGLE_SHORT_DIAGONAL_DELTA_X_RATIO, middle.y * SQUIGGLE_DIAGONAL_DELTA_Y_RATIO); 
    CGSize longDiagonal = CGSizeMake(middle.x * SQUIGGLE_LONG_DIAGONAL_DELTA_X_RATIO, middle.y * SQUIGGLE_DIAGONAL_DELTA_Y_RATIO);
    CGPoint point1 = CGPointMake(middle.x - longDiagonal.width, middle.y - longDiagonal.height);
    CGPoint point2 = CGPointMake(middle.x + shortDiagonal.width, middle.y - shortDiagonal.height);
    CGPoint point3 = CGPointMake(middle.x + longDiagonal.width, middle.y + longDiagonal.height);
    CGPoint point4 = CGPointMake(middle.x - shortDiagonal.width, middle.y + shortDiagonal.height);
    CGSize controlDelta = CGSizeMake(middle.x * SQUIGGLE_CONTROL_DELTA_X_RATIO, middle.y * SQUIGGLE_CONTROL_DELTA_Y_RATIO); 
    CGPoint curve1cp1 = CGPointMake(point1.x+controlDelta.width, point1.y-controlDelta.height);
    CGPoint curve1cp2 = CGPointMake(point2.x-controlDelta.width, point2.y+controlDelta.height);
    CGPoint curve2cp1 = CGPointMake(point2.x+controlDelta.width, point2.y-controlDelta.height);
    CGPoint curve2cp2 = CGPointMake(point3.x+controlDelta.width, point3.y-controlDelta.height);
    CGPoint curve3cp1 = CGPointMake(point3.x-controlDelta.width, point3.y+controlDelta.height);
    CGPoint curve3cp2 = CGPointMake(point4.x+controlDelta.width, point4.y-controlDelta.height);
    CGPoint curve4cp1 = CGPointMake(point4.x-controlDelta.width, point4.y+controlDelta.height);
    CGPoint curve4cp2 = CGPointMake(point1.x-controlDelta.width, point1.y+controlDelta.height);
       
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = SQUIGGLE_LINE_WIDTH;
    [path moveToPoint:point1];
    [path addCurveToPoint:point2 controlPoint1:curve1cp1 controlPoint2:curve1cp2];
    [path addCurveToPoint:point3 controlPoint1:curve2cp1 controlPoint2:curve2cp2];
    [path addCurveToPoint:point4 controlPoint1:curve3cp1 controlPoint2:curve3cp2];
    [path addCurveToPoint:point1 controlPoint1:curve4cp1 controlPoint2:curve4cp2];
    [path closePath];
    
    [self repeatSymbols:path];
}

#define OVAL_CONTROL_WIDTH_RATIO 0.75
#define OVAL_HEIGHT_RATIO 0.20
#define OVAL_LINE_WITDH_RATIO 0.40
#define OVAL_LINE_WIDTH 2.0

- (void)drawOval
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize delta = CGSizeMake(middle.x * OVAL_LINE_WITDH_RATIO, middle.y * OVAL_HEIGHT_RATIO);
    CGSize control = CGSizeMake(middle.x * OVAL_CONTROL_WIDTH_RATIO, middle.y * OVAL_HEIGHT_RATIO);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = OVAL_LINE_WIDTH;
    [path moveToPoint:CGPointMake(middle.x + delta.width, middle.y - delta.height)];
    [path addCurveToPoint:CGPointMake(middle.x + delta.width, middle.y + delta.height) controlPoint1:CGPointMake(middle.x + control.width , middle.y - control.height) controlPoint2:CGPointMake(middle.x + control.width , middle.y + control.height)];
    [path addLineToPoint:CGPointMake(middle.x - delta.width, middle.y + delta.height)];
    [path addCurveToPoint:CGPointMake(middle.x - delta.width, middle.y - delta.height) controlPoint1:CGPointMake(middle.x - control.width, middle.y + control.height) controlPoint2:CGPointMake(middle.x - control.width, middle.y - control.height)];
    [path closePath];    

    [self repeatSymbols:path];
}

#define SYMBOL_HEIGHT_RATIO 0.20
#define SYMBOL_WIDTH_RATIO 0.66
#define DIAMOND_LINE_WIDTH 2.0

- (void)drawDiamond
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGSize delta = CGSizeMake(middle.x * SYMBOL_WIDTH_RATIO, middle.y * SYMBOL_HEIGHT_RATIO);

    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = DIAMOND_LINE_WIDTH;
    [path moveToPoint:CGPointMake(middle.x, middle.y + delta.height)];
    [path addLineToPoint:CGPointMake(middle.x + delta.width, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y - delta.height)];
    [path addLineToPoint:CGPointMake(middle.x - delta.width, middle.y)];
    [path closePath];
    
    [self repeatSymbols:path];
}

#define PATTERN_WIDTH 3.0
#define PATTERN_HEIGHT 1.0
#define PATTERN_PAINTED_WIDTH 1.0

static void drawPattern (void *info, CGContextRef context)
{
    CGFloat *fillColorRGBcomponents = info;
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextSetRGBFillColor (context, *fillColorRGBcomponents++, *fillColorRGBcomponents++, *fillColorRGBcomponents++, *fillColorRGBcomponents);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, PATTERN_PAINTED_WIDTH, PATTERN_HEIGHT));
    CGContextFillPath(context);
}

void patternPainting (void *info)
{
    CGPatternRef pattern;
    CGColorSpaceRef patternSpace;
    static const CGPatternCallbacks callbacks = {0, &drawPattern, NULL};
    
    patternSpace = CGColorSpaceCreatePattern (NULL); 
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorSpace (context, patternSpace);
    CGColorSpaceRelease (patternSpace);
    
    CGFloat alpha = 1.0; // opaque pattern
        
    pattern = CGPatternCreate(info, CGRectMake(0, 0, PATTERN_WIDTH, PATTERN_HEIGHT),
                              CGAffineTransformIdentity, PATTERN_WIDTH, PATTERN_HEIGHT,
                              kCGPatternTilingConstantSpacing,
                              true, &callbacks);
    CGContextSetFillPattern (context, pattern, &alpha);
    CGPatternRelease (pattern);
}

#define SYMBOL_OFFSET_RATIO 0.28

- (void)repeatSymbols:(UIBezierPath *)path
{
    NSArray *colorPallette = @[[UIColor redColor],[UIColor colorWithRed: 0.0 green:0.5 blue:0.0 alpha:1.0],[UIColor purpleColor]];
    UIColor *symbolColor = colorPallette[self.color-1];
    [symbolColor setStroke];
    CGFloat symbolFillColor[4]; // Array with r,g,b,a components to draw pattern
    [symbolColor getRed:&symbolFillColor[0] green:&symbolFillColor[1] blue:&symbolFillColor[2] alpha:&symbolFillColor[3]];
    
    switch (self.shading) {
        case 2:
            patternPainting(symbolFillColor);
            break;
        case 3:
            [symbolColor setFill];
            break;
        default:
            break;
    }
    
    CGFloat verticalOffset = self.bounds.size.height*SYMBOL_OFFSET_RATIO;

    switch (self.number) {
        case 2:
        {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -verticalOffset/2);
            [path applyTransform:transform];
            [path stroke];
            [path fill];
            transform = CGAffineTransformMakeTranslation(0, verticalOffset);
            [path applyTransform:transform];
            [path stroke];
            [path fill];
            break;
        }            
        case 3:
        {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -verticalOffset);
            [path applyTransform:transform];
            [path stroke];
            [path fill];            
            transform = CGAffineTransformMakeTranslation(0, verticalOffset);
            [path applyTransform:transform];
            [path stroke];
            [path fill];
            transform = CGAffineTransformMakeTranslation(0, verticalOffset);
            [path applyTransform:transform];
            [path stroke];
            [path fill];
            break;
        }
        default:
        {
            [path stroke];
            [path fill];
            break;
        }
    }
}

- (void)setSymbol:(NSUInteger)symbol
    
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color =color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading =shading;
    [self setNeedsDisplay];
}

-(void) setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}


#pragma mark - Iitialization
- (void)setup
{
    // do initializaion here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    [self setup];
    return self;
}
@end
