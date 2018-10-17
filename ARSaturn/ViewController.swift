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
 
    enum Planet: String {
        case sun = "Sun"
        case mercury = "mercury"
        case venus = "venus"
        case earth = "earth"
        case moon = "moon"
        case marse = "marse"
        case saturn = "saturn"
    }
    
    var planetType: Planet!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let solarScene = SCNScene(named: "solarSystem.scn")!
        planetType = .sun
        
        // Set the scene to the view
        sceneView.scene = solarScene
//        sceneView.scene.rootNode.childNodes.map { $0.runAction(spinAction) }
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config, options: ARSession.RunOptions.resetTracking)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createEarthAndMoon()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    private func parentNode(of planet: SCNNode) -> PlanetNode {
        let parentNode = PlanetNode()
        
        return parentNode
    }

    func createEarthAndMoon() {
        let earth = sceneView.scene.rootNode.childNodes.filter { $0.name == Planet.earth.rawValue }.first!
        earth.runAction(rotating(duration: 6))     // 자전
        
        let moon = sceneView.scene.rootNode.childNodes.filter { $0.name == Planet.moon.rawValue }.first!
        moon.runAction(rotating(duration: 5))          // 자전
        
        let moonParent = PlanetNode()
        moonParent.eulerAngles = SCNVector3(0, 0, 0)
        moonParent.addChildNode(moon)
        earth.addChildNode(moonParent)
        
        let earthParent = PlanetNode()
        earthParent.position = SCNVector3(0, 0, -10)
        earthParent.revolvingAnimation(speed: 1.3)  // 공전
        earthParent.addChildNode(earth)
        
        self.sceneView.scene.rootNode.addChildNode(earthParent)
    }
    

    // 자전
    private func rotating(duration: Double) -> SCNAction {
        let rotationAction = SCNAction.rotateBy(x: CGFloat.pi * 360 / 180, y: 0, z: 0, duration: duration)
        let forever = SCNAction.repeatForever(rotationAction)
        return forever
    }
    
    
    private func planeNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }

    private func node(with imageName: String) -> SCNNode? {
        for node in sceneView.scene.rootNode.childNodes {
            if node.name == imageName {
                return node
            }
        }
        return nil
    }
    
    private func resetTrackingConfiguration() {
        self.checkLabel.text = "Not Found.."
        let configuration = ARImageTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
    
        configuration.maximumNumberOfTrackedImages = 1
        configuration.trackingImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        // Run the view's session
        sceneView.session.run(configuration, options: options)
    }

}
