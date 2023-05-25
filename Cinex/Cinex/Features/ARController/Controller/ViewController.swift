import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var currentVideoNode: SCNNode?
    var currentPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // First see if there is a folder called "ARImages" Resource Group in our Assets Folder
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) {
            
            // If there is, set the images to track
            configuration.trackingImages = trackedImages
            // At any point in time, only 1 image will be tracked
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // Reset the AR session
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        // Create a new session configuration
        let configuration = ARImageTrackingConfiguration()
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the new session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        var videoFileName: String?
        if imageAnchor.referenceImage.name == "GOTG_Poster" {
            videoFileName = "GOTG_Trailer"
        } else if imageAnchor.referenceImage.name == "Mario_Poster" {
            videoFileName = "Mario_Trailer"
        } else if imageAnchor.referenceImage.name == "SpiderVerse_Poster" {
            videoFileName = "SpiderVerse_Trailer"
        } else if imageAnchor.referenceImage.name == "Flash_Poster" {
            videoFileName = "Flash_Trailer"
        } else if imageAnchor.referenceImage.name == "Fast_Poster" {
            videoFileName = "Fast_Trailer"
        }
        
        if let videoFileName = videoFileName,
            let fileUrlString = Bundle.main.path(forResource: videoFileName, ofType: "mp4") {
            
            // Remove previous video node and stop audio player if they exist
            currentVideoNode?.removeFromParentNode()
            currentPlayer?.pause()
            
            let videoItem = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString))
            let player = AVPlayer(playerItem: videoItem)
            let videoNode = SKVideoNode(avPlayer: player)
            
            player.play() // Start playing the video
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
                player.seek(to: CMTime.zero) // Loop the video by seeking to the beginning
                player.play()
            }
            
            let videoScene = SKScene(size: CGSize(width: 1280, height: 1280))
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            // Create an audio source from the video player
            let audioSource = SCNAudioSource(url: URL(fileURLWithPath: fileUrlString))!
            audioSource.loops = true
            let audioPlayer = SCNAudioPlayer(source: audioSource)
            planeNode.addAudioPlayer(audioPlayer)
            
            // Store the current video node and player for later removal
            currentVideoNode = planeNode
            currentPlayer = player
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Stop video and audio when anchor is removed
        currentVideoNode?.removeFromParentNode()
        currentPlayer?.pause()
        currentVideoNode = nil
        currentPlayer = nil
    }
}

