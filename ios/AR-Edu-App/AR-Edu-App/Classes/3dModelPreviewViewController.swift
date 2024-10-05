import UIKit
import SceneKit

class ARModelPreviewViewController: UIViewController {

        private var sceneView: SCNView!
        var scene: SCNScene

        init(scene: SCNScene) {
            self.scene = scene
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            // Initialize and configure the SceneKit view
            sceneView = SCNView(frame: self.view.bounds)
            sceneView.backgroundColor = UIColor.black // Set background color
            sceneView.allowsCameraControl = true      // Allow user interaction (rotate/zoom)
            sceneView.autoenablesDefaultLighting = true // Enable lighting to see the model
            self.view.addSubview(sceneView)

            // Load and set the 3D model
            load3DModel()

            // Add tap gesture recognizer to detect taps on the model
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            sceneView.addGestureRecognizer(tapGesture)
        }

        func load3DModel() {

            // Get the model node
            if let modelNode = scene.rootNode.childNodes.first {
                // Scale the model up or down if necessary
                modelNode.scale = SCNVector3(5.0, 5.0, 5.0) // Adjust the scale as per your requirement

                // Calculate the bounding box
                let (minVec, maxVec) = modelNode.boundingBox

                // Calculate the center of the bounding box
                let center = SCNVector3(
                    (minVec.x + maxVec.x) / 2,
                    (minVec.y + maxVec.y) / 2,
                    (minVec.z + maxVec.z) / 2
                )

                // Reposition the model so that its center aligns with (0, 0, 0)
                modelNode.position = SCNVector3(-center.x, -center.y, -center.z)
            }
            // Add a camera to view the model
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(0, 0, 10) // Move camera back so it can see the model
            scene.rootNode.addChildNode(cameraNode)

            // Add a light source to illuminate the model
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni // Omni-directional light
            lightNode.position = SCNVector3(0, 10, 10) // Adjust light position
            scene.rootNode.addChildNode(lightNode)

            // Set the scene to the view
            sceneView.scene = scene
        }

        // Handle user tap on the scene
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, options: nil)
            
            if let hit = hitResults.first {
                // Get the world coordinates of the hit location
                let hitPosition = hit.worldCoordinates
                
                // Mark the position on the model
                markPosition(at: hitPosition)
                
                // Optionally, add a label/annotation to this position
                addAnnotation(at: hitPosition, withText: "Marker")
            }
        }

        // Function to mark the position with a small sphere
        func markPosition(at position: SCNVector3) {
            let markerGeometry = SCNSphere(radius: 0.05)
            let markerMaterial = SCNMaterial()
            markerMaterial.diffuse.contents = UIColor.red // Set marker color
            markerGeometry.materials = [markerMaterial]
            
            let markerNode = SCNNode(geometry: markerGeometry)
            markerNode.position = position
            
            scene.rootNode.addChildNode(markerNode) // Add marker to scene
        }

        // Function to add an annotation label to the scene
        func addAnnotation(at position: SCNVector3, withText text: String) {
            let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
            textGeometry.firstMaterial?.diffuse.contents = UIColor.white

            let textNode = SCNNode(geometry: textGeometry)
            textNode.scale = SCNVector3(0.1, 0.1, 0.1) // Scale down the text
            textNode.position = SCNVector3(position.x, position.y + 0.2, position.z) // Slightly above the marker

            scene.rootNode.addChildNode(textNode) // Add label to scene
        }
    }
