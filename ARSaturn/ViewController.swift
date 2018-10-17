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

        // Create a new scene
        let solarScene = SCNScene(named: "solarSystem.scn")!
        planetType = .sun
        
        // Set the scene to the view
        sceneView.scene = solarScene
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
        let childNodes = sceneView.scene.rootNode.childNodes
        
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
                ()
            case .mars:
                let marsParent = parentNode(of: node, revolving: 1.52)
                self.sceneView.scene.rootNode.addChildNode(marsParent)
            case .venus:
                let venusParent = parentNode(of: node, revolving: 0.72)
                self.sceneView.scene.rootNode.addChildNode(venusParent)
            case .jupiter:
                let jupiterParent = parentNode(of: node, revolving: 5.2)
                self.sceneView.scene.rootNode.addChildNode(jupiterParent)
            case .earth:
                createEarthAndMoon()
            case .saturn:
                createSaturnWithRing()
            default:
                break
            }
        }
    }
    
    private func parentNode(of planet: SCNNode, revolving duration: Double) -> PlanetNode {
        let parentNode = PlanetNode()
        parentNode.position = SCNVector3(0, 0, -3)
        parentNode.addChildNode(planet)
        parentNode.revolvingAnimation(speed: duration)
        return parentNode
    }
    
    private func createEarthAndMoon() {
        let earth = sceneView.scene.rootNode.childNodes.filter { $0.name == PlanetType.earth.rawValue }.first!
        earth.runAction(rotating(duration: 4))     // 자전
        
        let moon = sceneView.scene.rootNode.childNodes.filter { $0.name == PlanetType.moon.rawValue }.first!
        moon.runAction(rotating(duration: 4))          // 자전
        
        let moonParent = PlanetNode()
        moonParent.eulerAngles = SCNVector3(0, 0, -2)
        moonParent.addChildNode(moon)
        earth.addChildNode(moonParent)
        
        let earthParent = PlanetNode()
        earthParent.position = SCNVector3(0, 0, -5)
        earthParent.revolvingAnimation(speed: 1.0)  // 공전
        earthParent.addChildNode(earth)
        
        self.sceneView.scene.rootNode.addChildNode(earthParent)
    }
    
    private func createSaturnWithRing() {
        let saturn = sceneView.scene.rootNode.childNodes.filter { $0.name == PlanetType.saturn.rawValue }.first!
        let saturnRing = sceneView.scene.rootNode.childNodes.filter { $0.name == "saturnRing" }.first!

        saturnRing.position = SCNVector3(0, 0, -2)
        saturn.addChildNode(saturnRing)
        let saturnParent = parentNode(of: saturn, revolving: 9.58)
        saturnParent.eulerAngles = SCNVector3(0, 0, 10)
        self.sceneView.scene.rootNode.addChildNode(saturnParent)
    }

    
    // 자전
    private func rotating(duration: Double) -> SCNAction {
        let rotationAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 360 / 180, z: 0, duration: duration)
        let forever = SCNAction.repeatForever(rotationAction)
        return forever
    }

}
