//
//  ViewController.swift
//  AR-Edu-App
//
//  Created by Priyadharshan Raja on 25/09/24.
//

import UIKit
import ARKit

class HomeScreenViewController: UIViewController {

    // UI Components
    let appTitleLabel = UILabel()
    let tenantRoomIdTextField = UITextField()
    let submitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view background color
        view.backgroundColor = UIColor.systemTeal

        // Configure App Title Label
        appTitleLabel.text = "Pullaiyar Suli-Edu-App"
        appTitleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        appTitleLabel.textAlignment = .center
        appTitleLabel.textColor = UIColor.label
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Tenant Room ID TextField
        tenantRoomIdTextField.placeholder = "Enter Room ID"
        tenantRoomIdTextField.borderStyle = .roundedRect
        tenantRoomIdTextField.font = UIFont.systemFont(ofSize: 18)
        tenantRoomIdTextField.keyboardType = .numberPad
        tenantRoomIdTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor.systemIndigo
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up layout using a vertical stack view
        let stackView = UIStackView(arrangedSubviews: [appTitleLabel, tenantRoomIdTextField, submitButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Stack View constraints
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // TextField height constraint
            tenantRoomIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Button height constraint
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Button Action
    @objc func submitButtonTapped() {
        guard let tenantId = tenantRoomIdTextField.text, !tenantId.isEmpty else {
            showAlert(message: "Please enter a Room ID")
            return
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "DetectionImages", bundle: nil) else {
            print("No reference images found")
            return
        }
       
        let ARtrackingVC = ARTrackingViewController(imagesToTrack: referenceImages)
        self.navigationController?.pushViewController(ARtrackingVC, animated: true)
        // Proceed with your action using the tenant ID
        print("Tenant Room ID entered: \(tenantId)")
    }
    
    // Helper function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default){_ in
            self.verifyRoomId()
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func verifyRoomId() {
        print("Room Id Entered")
    }
}


