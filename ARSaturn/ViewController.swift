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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages = referenceImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARImageAnchor {
            let saturnScene = SCNScene(named: "saturn.scn")!
            let saturnNode = saturnScene.rootNode.childNode(withName: "parentNode", recursively: true)!
            
            // Rotate the saturn planet
            let rotationAction = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1)
            let infinteAction = SCNAction.repeat(rotationAction, count: 5)
            saturnNode.runAction(infinteAction)
            
            saturnNode.position = SCNVector3(x: anchor.transform.columns.3.x,
                                             y: anchor.transform.columns.3.y,
                                             z: anchor.transform.columns.3.z)
            node.addChildNode(saturnNode)
        }
    }
    
}
