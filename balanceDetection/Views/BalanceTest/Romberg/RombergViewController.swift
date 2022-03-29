//
//  RombergViewController.swift
//  balanceDetection
//
//  Created by Céline Aldenhoven on 31.05.21.
//

import Foundation
import UIKit
import ARKit
import RealityKit
import Combine
import AVFoundation
import CoreData

#if !targetEnvironment(simulator)
class RombergViewController: UIViewController, ARSessionDelegate {
    
    var variableResultLabel: UILabel = {
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "FontColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playSound(file: "LydiaIntroduction")
        
        //MARK: Views & Constraints
        
        variableResultLabel.text = "Arms crossed: \(handsCrossed), feet together: \(feetTogether)"
        
        view.addSubview(arView)
        arView.addSubview(variableResultLabel)
        
        let guide = self.view.safeAreaLayoutGuide
        
        let constraints = [
            arView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            arView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            arView.topAnchor.constraint(equalTo: guide.topAnchor),
            arView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            variableResultLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            variableResultLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            variableResultLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            variableResultLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.navigationItem.titleView = topTitleLabel
        
        //MARK: AR configuration
        
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }
        
        //Add the anchors to the scene
        arView.scene.addAnchor(characterAnchor)

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    var handsCrossed = false
    var feetTogether = false
    var testStarted = false
    var testWithEyesClosed = false
    var lostBalanceWithEyesOpen = false
    var lostBalanceWithEyesClosed = false
    var correctPositionAgain = false
    var testCompletelyFinished = false
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        guard !testCompletelyFinished else { return }
        
        for anchor in anchors {
            
            //retrieve all the body anchor from the session
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            //retrieve the transformations from the body anchor to calculate the joint positions later
            guard let headTransform = bodyAnchor.skeleton.modelTransform(for: .head) else { continue }
            guard let hipTransform = bodyAnchor.skeleton.modelTransform(for: .root) else { continue }
            guard let rightHandTransform = bodyAnchor.skeleton.modelTransform(for: .rightHand) else { continue }
            guard let leftHandTransform = bodyAnchor.skeleton.modelTransform(for: .leftHand) else { continue }
            guard let rightFootTransform = bodyAnchor.skeleton.modelTransform(for: .rightFoot) else { continue }
            guard let leftFootTransform = bodyAnchor.skeleton.modelTransform(for: .leftFoot) else { continue }
            
            //MARK: update the position of the anchors
            
            headAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(headTransform.columns.3)
            hipAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(hipTransform.columns.3)
            rightHandAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(rightHandTransform.columns.3)
            leftHandAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(leftHandTransform.columns.3)
            rightFootAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(rightFootTransform.columns.3)
            leftFootAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3) + simd_make_float3(leftFootTransform.columns.3)
            
            // Update the position of the character anchor.
            characterAnchor.position = simd_make_float3(bodyAnchor.transform.columns.3)
            // Also copy over the rotation of the body anchor, because the skeleton's pose in the world is relative to the body anchor's rotation.
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
   
            // MARK: Attach UI elements to the correct anchors
            
            if let character = character, character.parent == nil {
                // Attach the character to its anchor as soon as
                // 1. the body anchor was detected and
                // 2. the character was loaded.
                characterAnchor.addChild(character)
            }
            
            //MARK: Recognise positions and invoke methods accordingly
            
            //TODO: Timestamp setzen
            
            /*
             Hand position
             */
            
            //Hände auf ähnlicher höhe?
            if(leftHandAnchor.position.y - rightHandAnchor.position.y < 0.03
                && leftHandAnchor.position.y - rightHandAnchor.position.y > -0.02
                //Hände vertauscht?
                && leftHandAnchor.position.x - rightHandAnchor.position.x < 0.2
                && leftHandAnchor.position.x - rightHandAnchor.position.x > -0.1) {
                handsCrossed = true
            } else {
                handsCrossed = false
            }
            
            /*
             Fuß position
             */
            
            //Füße auf selber höhe?
            if(leftFootAnchor.position.z - rightFootAnchor.position.z < 0.3 //0
                && leftFootAnchor.position.z - rightFootAnchor.position.z > -0.3  //-0.15
                //Füße beisammen?
                && leftFootAnchor.position.x - rightFootAnchor.position.x < 0.3
                && leftFootAnchor.position.x - rightFootAnchor.position.x > -0.05) {
                feetTogether = true
            } else {
                feetTogether = false
            }
            
            //das zittern des Models herausfiltern
            guard !modelQuiver(hands: handsCrossed, feet: feetTogether, timestamp: Date()) else { return }
            
            variableResultLabel.text = "Arms crossed: \(handsCrossed), feet together: \(feetTogether)"
            
            //MARK: Romberg stance
            if(feetTogether && handsCrossed && !testStarted) {
                testStarted = true
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
                //takes 6 seconds to announce the test start
                playSound(file: "CorrectPosition-TestStarts")
                
            }
            
            //MARK: LostBalanceInFirstRound
            if(((testStarted && !testWithEyesClosed && !feetTogether) ||
                (testStarted && !testWithEyesClosed && !handsCrossed))
                && !lostBalanceWithEyesOpen) {
                lostBalanceWithEyesOpen = true
                timer.invalidate()
                secondsFirstRound = 60 - timerCountFirstRound
                playSound(file: "LostBalanceInFirstRound")
            }
            
            //MARK: LostBalanceInFirstRound -> in correct position again -> secondRoundStarts
            if(feetTogether && handsCrossed && lostBalanceWithEyesOpen && !correctPositionAgain) {
                correctPositionAgain = true
                testWithEyesClosed = true
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
                //takes 8 seconds to announce the test start
                playSound(file: "LostBalanceInFirstRound-SecondRoundStarts")
                
            }
            
            //MARK: LostBalanceInSecondRound
            if(((testStarted && testWithEyesClosed && !feetTogether) ||
                (testStarted && testWithEyesClosed && !handsCrossed))
                && !lostBalanceWithEyesClosed) {
                lostBalanceWithEyesClosed = true
                timer.invalidate()
                testCompletelyFinished = true
                secondsSecondRound = 60 - timerCountSecondRound
                //takes 7 seconds
                playSound(file: "LostBalanceInSecondRound")
                let resultsPage = RombergResultsView(eyesOpen: secondsFirstRound, eyesClosed: secondsSecondRound)
                navigationController?.pushViewController(resultsPage, animated: true)
                saveResults(eyesOpenResult: Int16(secondsFirstRound), eyesClosedResult: Int16(secondsSecondRound))
            }
        }
    }
    
    //MARK: Timer && test results
    var timer = Timer()
    var timerCountFirstRound = 66
    var timerCountSecondRound = 68
    var secondsFirstRound = 0
    var secondsSecondRound = 0
    
    @objc func fireTimer() {
        if(!testWithEyesClosed) {
            timerCountFirstRound -= 1
            if(timerCountFirstRound == 0){
                timer.invalidate()
                secondsFirstRound = 60
                testWithEyesClosed = true
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
                //takes 8 seconds
                playSound(file: "HeldBalanceInFirstRound-SecondRoundStarts")
            }
        } else {
            timerCountSecondRound -= 1
            if(timerCountSecondRound == 0){
                timer.invalidate()
                testCompletelyFinished = true
                secondsSecondRound = 60
                //takes 9 seconds
                playSound(file: "TestFinished-KeptBalance")
                let resultsPage = RombergResultsView(eyesOpen: secondsFirstRound, eyesClosed: secondsSecondRound)
                navigationController?.pushViewController(resultsPage, animated: true)
                saveResults(eyesOpenResult: Int16(secondsFirstRound), eyesClosedResult: Int16(secondsSecondRound))
            }
        }
    }
    
    //MARK: filter out model quiver, while detecting romberg position and balance loss
    
    var handsCrossedQueue = Queue<Bool>()
    var feetTogetherQueue = Queue<Bool>()
    var firstTimestampHands = Date() //default value that will be overwriten with first call of modelQuiver
    var firstTimestampFeet = Date() //default value that will be overwriten with first call of modelQuiver
    
    func modelQuiver(hands: Bool, feet: Bool, timestamp: Date) -> Bool {
        // Annahme: das model zuckt max 0.6 sekunde
        // => wenn alle Werte in 0.6 sec der Hände & füße gleich waren, dann können sie auch verwendet werden
        
        // erster Aufruf dieser Methode
        if(handsCrossedQueue.head == nil) {
            handsCrossedQueue.enqueue(hands)
            firstTimestampHands = timestamp
            firstTimestampFeet = timestamp
        }
        if(feetTogetherQueue.head == nil) {
            feetTogetherQueue.enqueue(feet)
            firstTimestampHands = timestamp
            firstTimestampFeet = timestamp
        }
        
        //wenn dieser wert einen anderen als der erste der queue hat, dann wird die queue gelöscht und mit diesem wert von vorne angefangen
        //hands
        guard hands == handsCrossedQueue.head else {
            handsCrossedQueue = Queue<Bool>()
            handsCrossedQueue.enqueue(hands)
            firstTimestampHands = timestamp
            return true
        }
        //feet
        guard feet == feetTogetherQueue.head else {
            feetTogetherQueue = Queue<Bool>()
            feetTogetherQueue.enqueue(feet)
            firstTimestampFeet = timestamp
            return true
        }
        
        //werte in queue packen
        handsCrossedQueue.enqueue(hands)
        feetTogetherQueue.enqueue(feet)
        
        //wert passt -> wenn lastValue - firstValue >= 0.6sec, dann return false
        guard firstTimestampHands.distance(to: timestamp) > 0.6 && firstTimestampFeet.distance(to: timestamp) > 0.6 else { return true }
        
        return false
    }
    
    //MARK: Audio player
    var player: AVAudioPlayer?
    
    func playSound(file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "wav") else {
            print("Can't grab sound file")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            player?.play()
        } catch {
            print("Whoopsie")
        }
    }
    
    //MARK: Position recognition variables
    
    var initialPosition = false
    var eyesClosed = false
    
    //MARK: UI-Elements
    
    var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance                  "
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(named: "FontColor")
        label.textAlignment = .left
        return label
    }()
    
    var arView: ARView = {
        let view = ARView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: AR and Body Tracking Elements
    
    let headAnchor = AnchorEntity()
    let hipAnchor = AnchorEntity()
    let rightHandAnchor = AnchorEntity()
    let leftHandAnchor = AnchorEntity()
    let rightFootAnchor = AnchorEntity()
    let leftFootAnchor = AnchorEntity()
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    
    //MARK: CoreData
    
    private func saveResults(eyesOpenResult: Int16, eyesClosedResult: Int16){
        let input = BalanceResult(context: BalanceCoreData.stack.context)
        input.eyesOpen = eyesOpenResult
        input.eyesClosed = eyesClosedResult
        do {
            try BalanceCoreData.stack.context.save()
        } catch {
            print("Unable to save results, \(error)")
        }
    }
}
#endif
