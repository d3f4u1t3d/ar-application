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
    var appTitleContainerView = UIView()
    var appSubTitle = UILabel()
    
    private var referenceImages : [ARReferenceImage] = []
    private var downloded3DModels : [SCNNode] = []
    
    private var downloadModelsAPI = "https://0a22-49-204-112-102.ngrok-free.app/files/"
    private var getFilesAPI = "https://0a22-49-204-112-102.ngrok-free.app/ios/45"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()

        // Set up the view background color
        view.backgroundColor = UIColor.systemTeal

        // Configure App Title Label
        appTitleLabel.text = "LearnSphere"
        appTitleLabel.font = UIFont.boldSystemFont(ofSize: 50)
        appTitleLabel.backgroundColor = .black
        appTitleLabel.textAlignment = .left
        appTitleLabel.layer.cornerRadius = 10
        appTitleLabel.layer.masksToBounds = true
        appTitleLabel.textColor = UIColor.label
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        appTitleContainerView.addSubview(appTitleLabel)

        appSubTitle.text = "The quick brown fox jumps over the lazy dog"
        appSubTitle.numberOfLines = 3
        appSubTitle.font = UIFont.boldSystemFont(ofSize: 20)
        appSubTitle.backgroundColor = .clear
        appSubTitle.translatesAutoresizingMaskIntoConstraints = false
        appTitleContainerView.addSubview(appSubTitle)
        
        appTitleContainerView.backgroundColor = .clear
        view.addSubview(appTitleContainerView)
        appTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTitleContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            appTitleContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            appTitleContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            appTitleContainerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: appTitleContainerView.topAnchor),
            appTitleLabel.leadingAnchor.constraint(equalTo: appTitleContainerView.leadingAnchor),
            appTitleLabel.trailingAnchor.constraint(equalTo: appTitleContainerView.trailingAnchor, constant: -30),
            appTitleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            appSubTitle.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: -15),
            appSubTitle.leadingAnchor.constraint(equalTo: appTitleContainerView.leadingAnchor),
            appSubTitle.trailingAnchor.constraint(equalTo: appTitleContainerView.trailingAnchor, constant: -140),
            appSubTitle.bottomAnchor.constraint(equalTo: appTitleContainerView.bottomAnchor)
        ])
        
        // Configure Tenant Room ID TextField
        tenantRoomIdTextField.placeholder = "Room ID here"
        tenantRoomIdTextField.borderStyle = .roundedRect
        tenantRoomIdTextField.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tenantRoomIdTextField.borderRect(forBounds: .zero)
        tenantRoomIdTextField.layer.cornerRadius = 10
        tenantRoomIdTextField.layer.borderColor = UIColor.white.cgColor  // Set white border color
        tenantRoomIdTextField.layer.borderWidth = 1.0
        tenantRoomIdTextField.font = UIFont.systemFont(ofSize: 18)
        tenantRoomIdTextField.keyboardType = .numberPad
        tenantRoomIdTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Submit Button
        submitButton.setTitle("Enter", for: .normal)
        submitButton.backgroundColor = UIColor(red: 245/255, green: 189/255, blue: 69/255, alpha: 1.0)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up layout using a vertical stack view
        let stackView = UIStackView(arrangedSubviews: [appTitleContainerView, tenantRoomIdTextField, submitButton])
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
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // TextField height constraint
            tenantRoomIdTextField.heightAnchor.constraint(equalToConstant: 60),
            
            // Button height constraint
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)

    }
    func setBackgroundImage() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "HomeWallpaper")
        backgroundImageView.contentMode = .scaleAspectFill

        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    // Button Action
    @objc func submitButtonTapped() {
        guard let tenantId = tenantRoomIdTextField.text, !tenantId.isEmpty else {
            showAlert(message: "Please enter a Room ID")
            return
        }
        
        let roomFolderURL = createFolderInDocumentsDirectory(folderName: String(tenantId))
        let roomID = "1234"
        
        downloadAssets(forRoomWithID: roomID, getFilesAPI: getFilesAPI, roomFolderURL: roomFolderURL!) {
            print("All assets downloaded and ready to use.")
            let ARtrackingVC = ARTrackingViewController(imagesToTrack: Set(self.referenceImages), downloaded3DModels: self.downloded3DModels)
           self.navigationController?.pushViewController(ARtrackingVC, animated: true)
        }
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "DetectionImages", bundle: nil) else {
//            print("No reference images found")
//            return
//        }
//       
//
//        let ARtrackingVC = ARTrackingViewController(imagesToTrack: referenceImages, downloaded3DModels: <#[SCNNode]#>)
//        self.navigationController?.pushViewController(ARtrackingVC, animated: true)
//        // Proceed with your action using the tenant ID
//        print("Tenant Room ID entered: \(tenantId)")
    }
    
    func createFolderInDocumentsDirectory(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            
            // Check if the main folder already exists, if not, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    print("Main folder created at: \(folderURL.path)")
                } catch {
                    print("Failed to create folder: \(error)")
                    return nil
                }
            }
            
            // Create subfolder for images inside the main folder
            let imagesFolderURL = folderURL.appendingPathComponent("Images")
            if !fileManager.fileExists(atPath: imagesFolderURL.path) {
                do {
                    try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("Images subfolder created at: \(imagesFolderURL.path)")
                } catch {
                    print("Failed to create Images subfolder: \(error)")
                    return nil
                }
            }
            
            // Create subfolder for 3D models inside the main folder
            let modelsFolderURL = folderURL.appendingPathComponent("3DModels")
            if !fileManager.fileExists(atPath: modelsFolderURL.path) {
                do {
                    try fileManager.createDirectory(at: modelsFolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("3DModels subfolder created at: \(modelsFolderURL.path)")
                } catch {
                    print("Failed to create 3DModels subfolder: \(error)")
                    return nil
                }
            }
            
            // Return the main folder URL
            return folderURL
        }
        return nil
    }
    
    func downloadAssets(forRoomWithID roomID: String, getFilesAPI: String, roomFolderURL: URL, completion: @escaping () -> Void) {
        
        // Start the activity indicator (if you have one)
        // self.activityIndicator.startAnimating()
        
        fetchModelData(from: getFilesAPI) { markerURLs, modelURLs in
            print("Marker URLs: \(markerURLs)")
            print("Model URLs: \(modelURLs)")

            // Create a DispatchGroup to track both downloads (markers and models)
            let downloadGroup = DispatchGroup()

            // Download the 3D models
            downloadGroup.enter()
            self.downloadMultipleUSDZModels(from: modelURLs, to: roomFolderURL.appendingPathComponent("3DModels")) { loadedNodes in
                print("3D Models loaded:")
                for node in loadedNodes {
                    print("Loaded model node: \(node)")
                }
                downloadGroup.leave() // Models download complete
            }

            // Download the marker images
            downloadGroup.enter()
            self.downloadMultipleMarkerImages(from: markerURLs, to: roomFolderURL.appendingPathComponent("Markers")) { referenceImages in
                print("Marker Images loaded:")
                for image in referenceImages {
                    print("Loaded marker image: \(image.name ?? "Unknown")")
                    // Use these images in your AR session
                }
                downloadGroup.leave() // Marker images download complete
            }

            // Notify when both downloads (models and markers) are completed
            downloadGroup.notify(queue: .main) {
                print("All assets downloaded (models and markers).")
                
                // Stop the activity indicator
                // self.activityIndicator.stopAnimating()

                // Call the completion handler to notify the calling code
                completion()
            }
        }
    }
    
    func fetchModelData(from apiURL: String, completion: @escaping ([String], [String]) -> Void) {
        guard let url = URL(string: apiURL) else {
            print("Invalid API URL")
            completion([], [])
            return
        }

        // Create a URLSession data task to fetch the JSON response
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion([], [])
                return
            }

            // Ensure there is data in the response
            guard let data = data else {
                print("No data returned from API")
                completion([], [])
                return
            }

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let markers = json["markers"] as? [String], // Extract marker names
                   let models = json["models"] as? [String] {  // Extract model names

                    // Base URL to append file names
                    let baseURL = "https://0a22-49-204-112-102.ngrok-free.app/files/"

                    // Filter only .jpg files for markers and .zip for models
                    let filteredMarkerURLs = markers.filter { $0.hasSuffix(".jpg") || $0.hasSuffix(".png") }
                        .map { baseURL + $0 }
                    
                    let filteredModelURLs = models.filter { $0.hasSuffix(".zip") || $0.hasSuffix(".usdz") }
                        .map {$0 }

                    // Return the filtered arrays through the completion handler
                    completion(filteredMarkerURLs, filteredModelURLs)
                } else {
                    print("Invalid JSON structure")
                    completion([], [])
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion([], [])
            }
        }

        // Start the URL session task
        task.resume()
    }
    
    func downloadMultipleUSDZModels(from urls: [String], to destinationFolder: URL, completion: @escaping ([SCNNode]) -> Void) {
        let fileManager = FileManager.default

        // Ensure the destination folder exists
        if !fileManager.fileExists(atPath: destinationFolder.path) {
            do {
                try fileManager.createDirectory(at: destinationFolder, withIntermediateDirectories: true, attributes: nil)
                print("Destination folder created at: \(destinationFolder.path)")
            } catch {
                print("Failed to create destination folder: \(error)")
                completion([])
                return
            }
        }

        // Create a DispatchGroup to track all download tasks
        let downloadGroup = DispatchGroup()

        // Array to hold the SCNNode objects for the 3D models
        var downloadedNodes: [SCNNode] = []

        // Iterate through the URLs and start downloading each file
        for fileName in urls {
            let urlString = downloadModelsAPI + fileName
            guard let url = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                continue
            }

            let destinationURL = destinationFolder.appendingPathComponent(fileName)

            // Check if the file already exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                print("File already exists at: \(destinationURL.path)")
                
                // Load the existing 3D model from the file
                if let node = load3DModel(from: destinationURL) {
                    node.name = (fileName as NSString?)?.deletingPathExtension
                    downloadedNodes.append(node)
                }
                continue
            }

            // Enter the DispatchGroup before starting the download task
            downloadGroup.enter()

            // Create and start the download task
            let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
                if let error = error {
                    print("Download error: \(error)")
                    downloadGroup.leave() // Leave the group on error
                    return
                }

                guard let tempURL = tempURL else {
                    print("No file URL for: \(urlString)")
                    downloadGroup.leave() // Leave the group if there's no file
                    return
                }

                // Move the file from the temp location to the destination folder
                do {
                    try fileManager.moveItem(at: tempURL, to: destinationURL)
                    print("File downloaded to: \(destinationURL.path)")

                    // Load the 3D model from the downloaded file and add to the nodes array
                    if let node = self.load3DModel(from: destinationURL) {
                        node.name = (fileName as NSString?)?.deletingPathExtension
                        downloadedNodes.append(node)
                    }
                } catch {
                    print("File move error: \(error)")
                }

                // Leave the DispatchGroup when the download task is complete
                downloadGroup.leave()
            }

            task.resume() // Start the download task
        }

        // Notify when all download tasks have completed
        downloadGroup.notify(queue: .main) {
            print("All downloads completed")
            self.downloded3DModels = downloadedNodes
            completion(downloadedNodes) // Return all the loaded SCNNodes
        }
    }
    
    func load3DModel(from fileURL: URL) -> SCNNode? {
        do {
            let scene = try SCNScene(url: fileURL, options: nil)
            if let modelNode = scene.rootNode.childNodes.first {
                return modelNode // Return the first node (your 3D model)
            }
        } catch {
            print("Error loading 3D model: \(error)")
        }
        return nil
    }
    
    func getFilesForCurrentRoomID(folderName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            
            // Check if the main folder already exists, if not, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    print("Main folder created at: \(folderURL.path)")
                } catch {
                    print("Failed to create folder: \(error)")
                    return nil
                }
            }
            
            // Create subfolder for images inside the main folder
            let imagesFolderURL = folderURL.appendingPathComponent("Images")
            if !fileManager.fileExists(atPath: imagesFolderURL.path) {
                do {
                    try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("Images subfolder created at: \(imagesFolderURL.path)")
                } catch {
                    print("Failed to create Images subfolder: \(error)")
                    return nil
                }
            }
            
            // Create subfolder for 3D models inside the main folder
            let modelsFolderURL = folderURL.appendingPathComponent("3DModels")
            if !fileManager.fileExists(atPath: modelsFolderURL.path) {
                do {
                    try fileManager.createDirectory(at: modelsFolderURL, withIntermediateDirectories: true, attributes: nil)
                    print("3DModels subfolder created at: \(modelsFolderURL.path)")
                } catch {
                    print("Failed to create 3DModels subfolder: \(error)")
                    return nil
                }
            }
            
            // Return the main folder URL
            return folderURL
        }
        return nil
    }
    
    func downloadMultipleMarkerImages(from urls: [String], to destinationFolder: URL, completion: @escaping ([ARReferenceImage]) -> Void) {
        
        let fileManager = FileManager.default

        // Ensure the destination folder exists
        if !fileManager.fileExists(atPath: destinationFolder.path) {
            do {
                try fileManager.createDirectory(at: destinationFolder, withIntermediateDirectories: true, attributes: nil)
                print("Destination folder created at: \(destinationFolder.path)")
            } catch {
                print("Failed to create destination folder: \(error)")
                completion([])
                return
            }
        }

        // Create a DispatchGroup to track all download tasks
        let downloadGroup = DispatchGroup()

        // Array to hold the ARReferenceImage objects
        var downloadedReferenceImages: [ARReferenceImage] = []

        // Iterate through the URLs and start downloading each file
        for urlString in urls {
            let getMarkerAPI = "https://0a22-49-204-112-102.ngrok-free.app/files/\(urlString)" // Update your API endpoint
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL: \(urlString)")
                continue
            }

            let fileName = url.lastPathComponent // Use the file name from the URL
            let destinationURL = destinationFolder.appendingPathComponent(fileName)

            // Check if the file already exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                print("File already exists at: \(destinationURL.path)")
                
                // Load the existing image and add it to the reference images array
                if let referenceImage = loadReferenceImage(from: destinationURL) {
                    downloadedReferenceImages.append(referenceImage)
                }
                continue
            }

            // Enter the DispatchGroup before starting the download task
            downloadGroup.enter()

            // Create and start the download task
            let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
                if let error = error {
                    print("Download error: \(error)")
                    downloadGroup.leave() // Leave the group on error
                    return
                }

                guard let tempURL = tempURL else {
                    print("No file URL for: \(urlString)")
                    downloadGroup.leave() // Leave the group if there's no file
                    return
                }

                // Move the file from the temp location to the destination folder
                do {
                    try fileManager.moveItem(at: tempURL, to: destinationURL)
                    print("File downloaded to: \(destinationURL.path)")

                    // Load the image and convert to ARReferenceImage
                    if let referenceImage = self.loadReferenceImage(from: destinationURL) {
                        downloadedReferenceImages.append(referenceImage)
                    }
                } catch {
                    print("File move error: \(error)")
                }

                // Leave the DispatchGroup when the download task is complete
                downloadGroup.leave()
            }

            task.resume() // Start the download task
        }

        // Notify when all download tasks have completed
        downloadGroup.notify(queue: .main) {
            print("All marker downloads completed")
            self.referenceImages = downloadedReferenceImages
            completion(downloadedReferenceImages) // Return all the loaded ARReferenceImages
        }
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
    
    func loadReferenceImage(from fileURL: URL) -> ARReferenceImage? {
        // Load the image from the URL
        if let image = UIImage(contentsOfFile: fileURL.path),
           let cgImage = image.cgImage {
            // Create ARReferenceImage from the CGImage
            let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2) // Set appropriate physical width
            referenceImage.name = fileURL.lastPathComponent
            return referenceImage
        }
        return nil
    }
    
    func verifyRoomId() {
        print("Room Id Entered")
    }
}


