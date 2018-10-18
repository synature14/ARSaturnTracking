//
//  PlanetNode.swift
//  ARSaturn
//
//  Created by sutie on 17/10/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import Foundation
import ARKit

extension Int {
    var degreeToRadians: Double {return Double(self) * .pi/180}
}


class PlanetNode: SCNNode {
    // 공전
    func revolvingAnimation (speed: Double) {
        let revolveAction = SCNAction.rotateBy(x: 0, y:  CGFloat(360.degreeToRadians), z: 0, duration: speed * 5)
        let forever = SCNAction.repeatForever(revolveAction)
        self.runAction(forever)
    }
}
