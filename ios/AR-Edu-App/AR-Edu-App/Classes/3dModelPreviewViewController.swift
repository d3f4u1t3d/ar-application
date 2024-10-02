import UIKit
import SceneKit

class ARModelPreviewViewController: UIViewController {

    private var sceneView: SCNView!
    var scene : SCNScene
    
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
}
