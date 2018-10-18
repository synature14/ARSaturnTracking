//
//  ViewController.swift
//  ARSaturn
//
//  Created by sutie on 16/10/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
 
    enum PlanetType: String {
        case sun = "sun"
        case mercury = "mercury"
        case venus = "venus"
        case earth = "earth"
        case moon = "moon"
        case mars = "mars"
        case jupiter = "jupiter"
        case saturn = "saturn"
        case saturnRing = "saturnRing"
    }
    
    var planetType: PlanetType!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config, options: ARSession.RunOptions.resetTracking)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPlanets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause() // Pause the view's session
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func setPlanets() {
        let solarScene = SCNScene(named: "solarSystem.scn")!
        let childNodes = solarScene.rootNode.childNodes
        
        childNodes.forEach { node in
            guard let nodeName = node.name else {
                return
            }
        
            if nodeName == "parent" || nodeName == "camera" {
                return
            }
            
            let type: PlanetType = PlanetType.init(rawValue: nodeName)!
            switch type {
            case .sun:
                node.position = SCNVector3(0, 0, -5)
                node.runAction(rotating(duration: 5))
                self.sceneView.scene.rootNode.addChildNode(node)
                
            case .mercury:
                node.position = SCNVector3(0, 1, -7)
                let mercuryParent = parentNode(of: node, revolving: 1.78, childRotating: 4)
                self.sceneView.scene.rootNode.addChildNode(mercuryParent)
                
            case .venus:
                node.position = SCNVector3(0, 3, -8)
                let venusParent = parentNode(of: node, revolving: 1.72, childRotating: 6)
                self.sceneView.scene.rootNode.addChildNode(venusParent)
                
            case .earth:
                createEarthAndMoon()
                
            case .mars:
                node.position = SCNVector3(0, -3, -12)
                let marsParent = parentNode(of: node, revolving: 2.6, childRotating: 4)
                self.sceneView.scene.rootNode.addChildNode(marsParent)
           
            case .jupiter:
                node.position = SCNVector3(1, 4.5, -15)
                let jupiterParent = parentNode(of: node, revolving: 4.2, childRotating: 5)
                self.sceneView.scene.rootNode.addChildNode(jupiterParent)
                
            case .saturn:
                node.position = SCNVector3(0, 0, -16)
                createSaturnWithRing()
            default:
                break
            }
        }
    }
    
    private func parentNode(of planet: SCNNode, revolving duration: Double, childRotating speed: Double) -> PlanetNode {
        let parentNode = PlanetNode()
        parentNode.position = SCNVector3(0, 0, -2)
        planet.runAction(rotating(duration: speed))
        parentNode.addChildNode(planet)
        parentNode.revolvingAnimation(speed: duration)
        return parentNode
    }
    
    private func createEarthAndMoon() {
        let solarScene = SCNScene(named: "solarSystem.scn")!
        let childNodes = solarScene.rootNode.childNodes
        
        let earth = childNodes.filter { $0.name == PlanetType.earth.rawValue }.first!
        earth.runAction(rotating(duration: 4))     // 자전
        
        let moon = childNodes.filter { $0.name == PlanetType.moon.rawValue }.first!
        moon.position = SCNVector3(0, 0, -2)        // Relative position
        moon.runAction(rotating(duration: 2))       // 자전
        
        let moonParent = PlanetNode()
        moonParent.eulerAngles = SCNVector3(0, 0, 10.degreeToRadians)
        moonParent.addChildNode(moon)
        earth.addChildNode(moonParent)
        
        let earthParent = PlanetNode()
        earthParent.position = SCNVector3(0, 0, -10)
        earthParent.revolvingAnimation(speed: 1.0)  // 공전
        earthParent.addChildNode(earth)
        
        self.sceneView.scene.rootNode.addChildNode(earthParent)
    }
    
    private func createSaturnWithRing() {
        let solarScene = SCNScene(named: "solarSystem.scn")!
        let childNodes = solarScene.rootNode.childNodes
        
        let saturn = childNodes.filter { $0.name == PlanetType.saturn.rawValue }.first!
        let saturnRing = childNodes.filter { $0.name == PlanetType.saturnRing.rawValue }.first!
        saturn.runAction(rotating(duration: 6))
        saturnRing.position = SCNVector3(0, 0, 0)
        saturn.addChildNode(saturnRing)
        
        let saturnParent = parentNode(of: saturn, revolving: 9.58, childRotating: 4.5)
        saturnParent.eulerAngles = SCNVector3(0, 0, 30.degreeToRadians)
        self.sceneView.scene.rootNode.addChildNode(saturnParent)
    }
    
    // 자전
    private func rotating(duration: Double) -> SCNAction {
        let rotationAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreeToRadians), z: 0, duration: duration)
        let forever = SCNAction.repeatForever(rotationAction)
        return forever
    }

}
