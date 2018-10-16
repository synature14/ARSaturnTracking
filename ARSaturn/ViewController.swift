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
    @IBOutlet weak var checkLabel: UILabel!
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    lazy var fadeAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.8, duration: fadeDuration),
            .wait(duration: waitDuration),
            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let saturnScene = SCNScene(named: "saturn.scn")!
        
        // Set the scene to the view
        sceneView.scene = saturnScene
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()    // Create a session configuration
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
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        resetTrackingConfiguration()
    }
    
    
    // When detected image!
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"
        
        guard let overlayNode = self.node(with: imageName) else {
            return
        }
        
//        let planeNode = self.planeNode(withReferenceImage: imageAnchor.referenceImage)
//        planeNode.opacity = 0.0
//        planeNode.eulerAngles.x = -.pi / 2
//        planeNode.runAction(self.fadeAction)
//        node.addChildNode(planeNode)
        
        overlayNode.opacity = 1
        overlayNode.position.y = 0.2
        overlayNode.runAction(self.fadeAndSpinAction)
        
        node.addChildNode(overlayNode)
        DispatchQueue.main.async {
             self.checkLabel.text = "Image detected: \"\(imageName)\""
        }
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
