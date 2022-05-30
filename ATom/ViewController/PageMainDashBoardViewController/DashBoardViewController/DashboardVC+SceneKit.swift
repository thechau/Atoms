//
//  File.swift
//  ATom
//
//  Created by Phan The Chau on 30/12/2021.
//  Copyright © 2021 phan.the.chau. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SceneKit.ModelIO

// MARK: Create Node Object

extension DashBoardViewController {
    func animationRotate() {
        let duration: TimeInterval = 1
        let duration2: TimeInterval = 2
          shadownLabel.alpha = 0
          let rotate = SCNAction.rotateTo(x: -0.7, y: 0, z: 0, duration: duration2)
          let moveOrigin = SCNAction.move(to: SCNVector3(0, 1, 1), duration: duration2)
        //  let hoverDown = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: duration)

          //deviceNode.rotation = SCNVector4Make(0, 1, 0, -Float(M_PI/15))
          let aa = SCNAction.rotate(toAxisAngle: SCNVector4Make(0, 1, 0, -Float(M_PI/15)), duration: duration)
          let bb = SCNAction.rotateTo(x: 0, y: -0.5, z: 0, duration: duration)
          
          deviceNode.position.x = -3.5
          deviceNode.scale = SCNVector3(0.85, 0.85, 0.85)
          
         // backgroundNode.scale = SCNVector3(2, 2, 2)
          
          logoNode.position.x = -3.5
          logoNode.scale = SCNVector3(0.85, 0.85, 0.85)
          
          let cc = SCNAction.group([aa, bb])
          deviceNode.runAction(cc)
          logoNode.runAction(cc)
          //deviceNode.eulerAngles = SCNVector3Make(0, -Float(M_PI/15), 0)
          let action = SCNAction.group([rotate, moveOrigin])
          worldNode.runAction(action)
          
          // let actionWait = SCNAction.wait(duration: duration * 0.25)
          let gradientFadeIn = SCNAction.fadeIn(duration: duration)
          gradientNode.runAction(gradientFadeIn)
          
          let menuMoveAction2 = SCNAction.move(to: SCNVector3(0, 80, -20), duration: duration)
          let actionGradient = SCNAction.group([menuMoveAction2, gradientFadeIn])
          gradientNode2.runAction(actionGradient)
    }
    
    @objc func toggle(_ sender: AnyObject!) {
        let rightVC = UIStoryboard(name: "ReportSTB", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")  as! SettingViewController
        self.navigationController?.pushViewController(rightVC, animated: true)
    }
    
    func setUpSnenKit() {
        let screenBound = UIScreen.main.bounds
        if screenBound.height / screenBound.width >= 2 {
            zPositionCamera = 2
        } else {
            zPositionCamera = 0
        }
        
        guard let scenes = SCNScene(named: options.nameDevice) else {
            return
        }
        scene = scenes
        
        let node = scene.rootNode.childNodes[0]
        boxNode = scene.rootNode.childNodes[0].childNodes[1]
        deviceNode = scene.rootNode.childNodes[0].childNodes[0]
        simpleTextNode = scene.rootNode.childNodes[0].childNodes[6]
        logoNode = scene.rootNode.childNodes[0].childNodes[4]
        atomTextNode = scene.rootNode.childNodes[0].childNodes[2]
        backgroundNode = scene.rootNode.childNodes[0].childNodes[3]
        
        scene.rootNode.childNodes[0].childNodes.forEach { (node) in
            node.scale = options.scaleNode
            node.position.x = -0.5
        }
        
        
        gradientNode2 = createImage(name: "gradient2", width: 60, height: 40)
        gradientNode2.position.z = -20
        gradientNode2.position.y = 80
        scene.rootNode.addChildNode(gradientNode2)
        
        circleNode1 = createImage(name: "ani", width: 25, height: 25)
        circleNode1.position.z = -8
        circleNode1.position.y = -0.5
        circleNode1.eulerAngles = SCNVector3Make(-Float(Double.pi / 2), 0, 0)
        circleNode1.opacity = 0
        deviceNode.addChildNode(circleNode1)
        
        //boxNode.removeFromParentNode()
        
        let menuNode = createMenuNode()
        boxNode.addChildNode(menuNode)
        
        
        let heightBoxWorld: CGFloat = 5
        
        worldNode = SCNNode(geometry: nil)
        
        let originNode = SCNNode(geometry: nil)
        originNode.position.y = 7
        worldNode.addChildNode(originNode)
        
        let frontViewNode = SCNNode(geometry: nil)
        frontViewNode.position = SCNVector3(0, 0, Float(heightBoxWorld) / 2)
        
        let deviceNode = SCNNode(geometry: nil)
        node.eulerAngles = SCNVector3Make(Float(Double.pi / 2), 0, 0)
        node.removeFromParentNode()
        node.position = SCNVector3(0, -10, 1)
        deviceNode.addChildNode(node)
        deviceNode.position.z = Float(-3)
        deviceNode.position.y = 2.9
        frontViewNode.addChildNode(deviceNode)
        originNode.addChildNode(frontViewNode)
        
        // 2: Add camera node
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 58)
        scene.rootNode.addChildNode(cameraNode)
        
        
        // If you don't want to fix manually the lights
        sceneView.autoenablesDefaultLighting = false
        
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = false
        
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
        
        // Set background color
        sceneView.backgroundColor = .clear//backgroundColor
        
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
        
        // Set scene settings
        sceneView.scene = scene
        scene.rootNode.addChildNode(worldNode)
        shadownLabel.alpha = 0
    }
    
    func handleTouchFor(node: SCNNode) {
        if node.name == nameButton1 {
            showPatientInformationController()
        }
        
        if node.name == nameButton2 {
            showSearchScreen()
        }
        
        if node.name == nameButton3 {
            showQuickEGC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            handleTouchFor(node: result.node)
        }
    }
    
    func resetDefault() {
        worldNode.position = SCNVector3(0, 0, 0)
        worldNode.eulerAngles = SCNVector3(0, 0, 0)
        
        after(interval: 3, completion: {
            self.animation1()
        })
    }
    
    func animation1() {
        let duration: TimeInterval = 0.5
        
        let rotate = SCNAction.rotateTo(x: -CGFloat(Float.pi/180 * 80), y: 0, z: 0, duration: duration)
        let moveUp = SCNAction.move(to: SCNVector3(0, 11.3, 2), duration: duration)
        let action = SCNAction.group([rotate, moveUp])
        worldNode.runAction(action)
        
        let gradientFadeOut = SCNAction.fadeOut(duration: duration)
        gradientNode.runAction(gradientFadeOut)
        
        let gradient2Move = SCNAction.move(to: SCNVector3(0, 30, -20), duration: duration)
        
        cameraNode.position.y = 2
        simpleTextNode.removeFromParentNode()
        atomTextNode.removeFromParentNode()
        //backgroundNode.removeFromParentNode()
        self.bottomContraint.constant = -150
        self.leftArrowContraint.constant = -150
        self.reightArrowContraint.constant = -100
        
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
        
        after(interval: 0.5, completion: {
            self.bottomCancelButtonContraint.constant = 18
            self.cancelButton.isHidden = false
            self.shadownLabel.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        })
        sceneView.backgroundColor = .clear//UIColor.init(hex: "fbfbfb")
        
        //Test
        after(interval: 3, completion: {
          //  self.animation2()
        })
    }
    
    func animation2() {
        let duration: TimeInterval = 1
        shadownLabel.alpha = 0
        let rotate = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: duration)
        let moveOrigin = SCNAction.move(to: SCNVector3(0, 0, 0), duration: duration)
        //deviceNode.eulerAngles = SCNVector3Make(0, -Float(M_PI/15), 0)
        let action = SCNAction.group([rotate, moveOrigin])
        worldNode.runAction(action)
        
        // let actionWait = SCNAction.wait(duration: duration * 0.25)
        let gradientFadeIn = SCNAction.fadeIn(duration: duration)
        gradientNode.runAction(gradientFadeIn)
        
        let menuMoveAction2 = SCNAction.move(to: SCNVector3(0, 80, -20), duration: duration)
        let actionGradient = SCNAction.group([menuMoveAction2, gradientFadeIn])
        gradientNode2.runAction(actionGradient)
        
//        scene.rootNode.childNodes[0].childNodes.forEach { (node) in
//            node.scale = options.scaleNode
//            node.position.x = -1
//            node.rotation = SCNVector4Make(0, 1, 0, -Float(M_PI/15))
//            node.eulerAngles = SCNVector3Make(0, -Float(M_PI/15), 0)
//        }
        //Test

        self.cancelButton.isHidden = true
        
        after(interval: 1, completion: {
            self.animation3()
        })
        after(interval: 2) {
            self.view.backgroundColor = UIColor.init(hex: "fbfbfb")
            self.sceneView.backgroundColor = .black//UIColor.init(hex: "fbfbfb")
        }
    }
    
    func animation3() {
        
        //let duration: TimeInterval = 1
        
//        let position = SCNVector3(0, 0, -5)
//        let scale = SCNAction.scale(to: 0.85, duration: duration)
//        let move = SCNAction.move(to: position, duration: duration)
//        let groupAction = SCNAction.group([move, scale])
//
//        deviceNode.runAction(groupAction)
        
        circleNode1.opacity = 1
        circleNode1.scale = SCNVector3(1, 1, 1)
        
        let timeEachAnimationCirle: TimeInterval = 0.7
        let scaleAction = SCNAction.scale(to: 6, duration: timeEachAnimationCirle)
        let fade = SCNAction.fadeOut(duration: timeEachAnimationCirle)
        
        let resetAction = SCNAction.customAction(duration: 0.1, action: { node, _ -> Void in
            node.opacity = 1
            node.scale = SCNVector3(1, 1, 1)
        })
        
        let group = SCNAction.group([scaleAction, fade])
        let sequence = SCNAction.sequence([resetAction ,group])
        
        _ = SCNAction.customAction(duration: 0.1, action: { node, _ -> Void in
            node.opacity = 0
            node.scale = SCNVector3(1, 1, 1)
        })
        
        let delayAction = SCNAction.wait(duration: 1)
        let repeatAction = SCNAction.repeat(sequence, count: 100)
        
        circleNodeAction = SCNAction.sequence([delayAction, repeatAction])
        
        topConstraintCollectionView.constant = self.view.frame.height / 2 + 50
        //Test
        after(interval: 1) {
            self.heightConstraintGrayView.constant = 200
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }

        after(interval: 2, completion: {
            // self.resetDefault()
        })
    }
    
    func createTitleNode(text: String, font: UIFont, color: UIColor) -> SCNNode {
        let title = SCNText(string: text, extrusionDepth: 0.1)
        title.font = font
        title.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        let titleNode = SCNNode(geometry: title)
        
        let (minBound, maxBound) = title.boundingBox
        titleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.02/2)
        titleNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        title.materials = [material]
        
        return titleNode
    }
    
    func createDashNode() -> SCNNode {
        
        let boxGeometry = SCNPlane(width: 1.2, height: 0.05)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.6)
        let dashNode = SCNNode(geometry: boxGeometry)
        return dashNode
    }
    
    func createButtonNode(text: String, nameIcon: String) -> SCNNode {
        
        let boxGeometry = SCNPlane(width: 8, height: 2)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.clear
        let buttonNode = SCNNode(geometry: boxGeometry)
        buttonNode.position.z = 0.1
        
        let textNode = createTitleNode(text: text,
                                       font: options.fontMenu!,
                                       color: UIColor.gray)
        textNode.position.y = -0.5
        textNode.position.z = -0.1
        buttonNode.addChildNode(textNode)
        return buttonNode
    }
    
    func createImage(name: String, width: CGFloat, height: CGFloat) -> SCNNode {
        let node = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.physicsBody? = .static()
        node.name = name
        node.geometry?.materials.first?.diffuse.contents = UIImage(named: name)
        
        return node
    }
    
    func createMenuNode() -> SCNNode {
        
        let boxGeometry = SCNPlane(width: 33, height: 42)
        boxGeometry.firstMaterial?.diffuse.contents = UIColor.clear //UIColor.green.withAlphaComponent(0.7)
        menuNode = SCNNode(geometry: boxGeometry)
        menuNode.position.z = 37.5
        menuNode.position.y = -21.5
        menuNode.position.x = 0.5
        
        gradientNode = createImage(name: "gradient", width: 33, height: 42)
        gradientNode.position.z = 0.08
        menuNode.addChildNode(gradientNode)
        
        let newPatientButton = createButtonNode(text: nameButton1, nameIcon: "")
        newPatientButton.name = nameButton1
        newPatientButton.position.y = 19
        newPatientButton.position.z = 5
        //newPatientButton.position.x = 0.5
        menuNode.addChildNode(newPatientButton)
        
        let dash1 = createDashNode()
        dash1.position.y = 17
        dash1.position.z = 5
        menuNode.addChildNode(dash1)
        
        let existingPatientButton = createButtonNode(text: nameButton2, nameIcon: "")
        existingPatientButton.name = nameButton2
        existingPatientButton.position.y = 15
        existingPatientButton.position.z = 5
        menuNode.addChildNode(existingPatientButton)
        
        let dash2 = createDashNode()
        dash2.position.y = 13
        dash2.position.z = 5
        menuNode.addChildNode(dash2)
        
        let quickECGButton = createButtonNode(text: nameButton3, nameIcon: "")
        quickECGButton.name = nameButton3
        quickECGButton.position.y = 11
        quickECGButton.position.z = 5
        menuNode.addChildNode(quickECGButton)
        return menuNode
    }
}
