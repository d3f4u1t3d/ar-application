//
//  ARTrackingViewController.swift
//  AR-Edu-App
//
//  Created by Priyadharshan Raja on 25/09/24.
//

import Foundation
import ARKit

class ARTrackingViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate{
    
    var imagesToTrack : Set<ARReferenceImage>
    
    private lazy var arSceneView: ARSCNView = {
        let arSceneView = ARSCNView()
        arSceneView.translatesAutoresizingMaskIntoConstraints = false
        arSceneView.delegate = self
        arSceneView.debugOptions = [.showFeaturePoints]
        arSceneView.autoenablesDefaultLighting = true
        arSceneView.automaticallyUpdatesLighting = true
        if let camera = arSceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
        }
        arSceneView.isUserInteractionEnabled = false
        return arSceneView
    }()
    
    private lazy var focusImageView: UIImageView = {
        let focusImageView = UIImageView()
        focusImageView.contentMode = .scaleAspectFit
        focusImageView.translatesAutoresizingMaskIntoConstraints = false
        focusImageView.image = UIImage(named: "AR_focus")
        focusImageView.tintColor = .white
        focusImageView.alpha = 0.4
        return focusImageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    init(imagesToTrack: Set<ARReferenceImage>) {
        self.imagesToTrack = imagesToTrack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureImageTrackingSession()
    }
    
    private func configureView() {
        
        arSceneView.session.delegate = self
        arSceneView.delegate = self
        
        self.view.addSubview(arSceneView)
        arSceneView.addSubview(focusImageView)
        arSceneView.addSubview(messageLabel)
        
        let focusGuide = UILayoutGuide()
        arSceneView.addLayoutGuide(focusGuide)
        
        NSLayoutConstraint.activate([
            self.arSceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.arSceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.arSceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.arSceneView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            focusGuide.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            focusGuide.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            focusGuide.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            focusGuide.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            focusImageView.topAnchor.constraint(equalTo: focusGuide.topAnchor),
            focusImageView.leadingAnchor.constraint(equalTo: focusGuide.leadingAnchor, constant: 50),
            focusImageView.trailingAnchor.constraint(equalTo: focusGuide.trailingAnchor, constant: -50),
            focusImageView.widthAnchor.constraint(equalTo: focusImageView.heightAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: focusGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: focusGuide.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: focusGuide.bottomAnchor),
            messageLabel.topAnchor.constraint(equalTo: focusImageView.bottomAnchor, constant: 25),
            
        ])
    }
    
    private func configureImageTrackingSession(){
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = self.imagesToTrack
        self.arSceneView.session.run(config, options: .resetTracking)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            print(anchor.name ?? "No Name")
            if anchor.name == "Tune-3D-Marker" {
                
                // Load the scene from the .obj file
                guard let scene = SCNScene(named: "baked_mesh.obj") else {
                    print("Failed to load model")
                    return
                }
                
                // Ensure pushing the new view controller happens on the main thread
                DispatchQueue.main.async {
                    let ARModelPreviewVC = ARModelPreviewViewController(scene: scene)
                    self.navigationController?.pushViewController(ARModelPreviewVC, animated: true)
                }
            }
        }
    }
}
