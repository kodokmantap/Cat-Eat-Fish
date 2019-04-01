//
//  GKTestViewController.swift
//  Cat Eat Fish
//
//  Created by Yulibar Husni on 30/03/19.
//  Copyright © 2019 Yulibar Husni. All rights reserved.
//

import UIKit
import GameKit

class GKTestViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var scoreSlider: UISlider!
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.hiscore.cateatfish"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Call the GC authentication controller
        authenticateLocalPlayer()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error ?? nil)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func updateScoreLeaderboardButton(_ sender: UIButton) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(scoreSlider.value)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    @IBAction func checkLeaderBoardButton(_ sender: UIButton) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
}
