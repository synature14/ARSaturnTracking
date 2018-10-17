//
//  PlanetNode.swift
//  ARSaturn
//
//  Created by sutie on 17/10/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import Foundation
import ARKit

class PlanetNode: SCNNode {

    // 공전
    func revolvingAnimation (speed: Double) {
//        let spinAction = SCNAction.rotateBy(x: 0, y:  CGFloat.pi * 360 / 180, z: 0, duration: spinDuration)
        let revolveAction = SCNAction.rotateBy(x: 0, y:  CGFloat.pi * 360 / 180, z: 0, duration: speed * 5)
        let forever = SCNAction.repeatForever(revolveAction)
        self.runAction(forever)
    }
}
