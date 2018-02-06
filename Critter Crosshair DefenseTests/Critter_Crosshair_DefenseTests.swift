//
//  Critter_Crosshair_DefenseTests.swift
//  Critter Crosshair DefenseTests
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Critter_Crosshair_Defense

class Critter_Crosshair_DefenseTests: XCTestCase{
    
    var character: SKSpriteNode!
    var scene: SKScene!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let sceneSize = CGSize(width: 1000, height: 1000)
        self.scene = SKScene(size: sceneSize)
        self.scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let characterSize = CGSize(width: 10.0, height: 10.0)
        self.character = SKSpriteNode(color: UIColor.clear, size: characterSize)
        self.character.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.character.position = CGPoint.zero
        self.character.move(toParent: self.scene)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        character = nil
        super.tearDown()
    }
    
    
    func testRotateAnimationGenerator(){
        
        let rotateAnimationGenerator1 = RotateAnimationGenerator(animationName: "RotateAnimationGenerator", rotateTo: nil, rotateBy: 0.4, shortestUnitArc: true, duration: 1.0)
        
        let rotateAction = rotateAnimationGenerator1.createAnimation()
    
        XCTAssertNotNil(rotateAction)
        
        XCTAssertTrue(rotateAnimationGenerator1.hasRotateByAnimation)
        XCTAssertFalse(rotateAnimationGenerator1.hasRotateToAnimation)
        
        let rotateAnimationGenerator2 = RotateAnimationGenerator(animationName: "RotateAnimationGenerator", rotateTo: 1.00, rotateBy: 0.4, shortestUnitArc: true, duration: 1.0)
        
        let rotateAction2 = rotateAnimationGenerator2.createAnimation()
        
        XCTAssertNotNil(rotateAction2)
        XCTAssertTrue(rotateAnimationGenerator2.hasRotateByAnimation)
        XCTAssertTrue(rotateAnimationGenerator2.hasRotateToAnimation)
        
        let rotateAnimationGenerator3 = RotateAnimationGenerator(animationName: "RotateAnimationGenerator", rotateTo: 1.00, rotateBy: nil, shortestUnitArc: true, duration: 1.00)
        
        let rotateAction3 = rotateAnimationGenerator3.createAnimation()
        
        XCTAssertNotNil(rotateAction3)
        XCTAssertTrue(rotateAnimationGenerator3.hasRotateToAnimation)
        XCTAssertFalse(rotateAnimationGenerator3.hasRotateByAnimation)
        
    }
    
    
    func testMoveAnimationGenerator(){
        
        let moveAnimationGenerator1 = MoveAnimationGenerator(animationName: "MoveAnimationGenerator", xMoveTo: nil, yMoveTo: nil, xMoveBy: -5.00, yMoveBy: nil, duration: 1.0)
        
        let moveLeftAction = moveAnimationGenerator1.createAnimation()
        
    
        XCTAssertNotNil(moveLeftAction)
        
        XCTAssertTrue(moveAnimationGenerator1.hasMoveByAnimation)
        XCTAssertFalse(moveAnimationGenerator1.hasMoveToAnimation)
        
        let duration = moveLeftAction!.duration
        
        XCTAssertEqual(duration, 1.0)
        
        
        let moveAnimationGenerator2 = MoveAnimationGenerator(animationName: "MoveAnimationGenerator", xMoveTo: nil, yMoveTo: 2.0, xMoveBy: -5.00, yMoveBy: nil, duration: 1.0)

        let moveAction2 = moveAnimationGenerator2.createAnimation()
        
        
        XCTAssertNotNil(moveAction2)
        
        XCTAssertTrue(moveAnimationGenerator2.hasMoveToAnimation)
        XCTAssertTrue(moveAnimationGenerator2.hasMoveByAnimation)
        
   
        let moveAnimationGenerator3 = MoveAnimationGenerator(animationName: "MoveAnimationGenerator", xMoveTo: 2.0, yMoveTo: nil, xMoveBy: nil, yMoveBy: nil, duration: 1.0)
        
        let moveAction3 = moveAnimationGenerator3.createAnimation()
        
        XCTAssertNotNil(moveAction3)
        XCTAssertTrue(moveAnimationGenerator3.hasMoveToAnimation)
        XCTAssertFalse(moveAnimationGenerator3.hasMoveByAnimation)
        
    
    }
    
    func testScaleAnimationGenerator(){
        
        let scaleAnimationGenerator1 = ScaleAnimationGenerator(animationName: "ScaleAnimationGenerator", xScaleTo: nil, yScaleTo: nil, xScaleBy: nil, yScaleBy: 2.0, duration: 1.0)
        
        let scaleAnimation1 = scaleAnimationGenerator1.createAnimation()
        
        XCTAssertNotNil(scaleAnimation1)
        
        XCTAssertTrue(scaleAnimationGenerator1.hasScaleByAnimation)
        XCTAssertFalse(scaleAnimationGenerator1.hasScaleToAnimation)
        
        let scaleAnimationGenerator2 = ScaleAnimationGenerator(animationName: "scaleAnimationGenerator", xScaleTo: 1.5, yScaleTo: nil, xScaleBy: nil, yScaleBy: 2.0, duration: 1.0)
        
        let scaleAnimation2 = scaleAnimationGenerator2.createAnimation()
        
        XCTAssertNotNil(scaleAnimation2)
        XCTAssertTrue(scaleAnimationGenerator2.hasScaleToAnimation)
        XCTAssertTrue(scaleAnimationGenerator2.hasScaleByAnimation)
        
        let scaleAnimationGenerator3 = ScaleAnimationGenerator(animationName: "ScaleAnimationGenerator", xScaleTo: 0.9, yScaleTo: nil, xScaleBy: nil, yScaleBy: nil, duration: 1.0)
        
        let scaleAnimation3 = scaleAnimationGenerator3.createAnimation()
        
        XCTAssertNotNil(scaleAnimation3)
        XCTAssertTrue(scaleAnimationGenerator3.hasScaleToAnimation)
        XCTAssertFalse(scaleAnimationGenerator3.hasScaleByAnimation)
        
    }
    
    
    func testMoveActions(){
  
    
    func testScaleActions(){
        
    }
    
    func testRotateActions(){
        
        
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
  
    
}
