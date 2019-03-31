//
//  ViewController.swift
//  Cat Eat Fish
//
//  Created by Yulibar Husni on 27/03/19.
//  Copyright © 2019 Yulibar Husni. All rights reserved.
//

import UIKit
import GameKit

var scoreSession: Int = 50
var hiScore: Int?
var health = 3
var isGameOver = false
let duration = Double.random(in: 1.0...3.0)


var mainScreen: ViewController!

class ViewController: UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID = "com.hiscore.cateatfish"

    
    
    let goodFeedback = UIImpactFeedbackGenerator(style: .light)
    let badFeedback = UIImpactFeedbackGenerator(style: .heavy)

    @IBOutlet weak var foodOutlet: UIImageView!
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var tapToPlayOutlet: UIButton!
    @IBOutlet weak var gameOverOutlet: UIView!
    @IBOutlet weak var foodButtonOutlet: UIButton!
    @IBOutlet weak var notFoodButtonOutlet: UIButton!
    
    @IBOutlet weak var gameOverScoreSessionOutlet: UILabel!
    @IBOutlet weak var gameOverHiScoreOutlet: UILabel!
    
    @IBOutlet weak var catHeadOutlet: UIImageView!
    @IBOutlet weak var catPawOutletL: UIImageView!
    @IBOutlet weak var catPawOutletR: UIImageView!
    @IBOutlet weak var comboBar: UIProgressView!
    @IBOutlet weak var comboOutlet: UILabel!
    
    
    var whichfood:[UIImage] = [#imageLiteral(resourceName: "foodFish"),#imageLiteral(resourceName: "foodMeat")]
    var numberOfCombo: Int = 0
    var comboTimer:Timer?
    var timerWaitingAnswer: Timer?
    var waitingForAnswer = 5


    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()

        startingMusic()
        foodButtonOutlet.isHighlighted = true
        notFoodButtonOutlet.isHighlighted = true
        
        foodButtonOutlet.isEnabled = false
        notFoodButtonOutlet.isEnabled = false
        
        scoreOutlet.isHidden = true
        comboBar.isHidden = true
        comboOutlet.isHidden = true


        self.scoreOutlet.frame.origin.y = -40
        
        animate()
        // Do any additional setup after loading the view.
    
    }
    
    func animate() {
        
        catHeadOutlet.frame.origin.y = 70
        catPawOutletL.frame.origin.y = 215
        catPawOutletR.frame.origin.y = 215

        UIView.animate(withDuration: duration, delay: 1, options: [.repeat, .autoreverse], animations: {
            self.catHeadOutlet.frame.origin.y -= 20
            //self.tapToPlayOutlet.frame.origin.y -= 20
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1, options: [.repeat, .autoreverse], animations: {
            self.catPawOutletL.frame.origin.y += 10
            self.catPawOutletR.frame.origin.y += 10
        }, completion: nil)
    }
    
    
    
    
    func restartgame() {
        print("restart Game")
        gameOverOutlet.isHidden = true
    }
    
    func gameStart() {
        
        isGameOver = false
        comboOutlet.isHidden = true

        foodOutlet.isHidden = false
        foodButtonOutlet.isHighlighted = false
        notFoodButtonOutlet.isHighlighted = false
        foodButtonOutlet.isEnabled = true
        notFoodButtonOutlet.isEnabled = true
        scoreOutlet.isHidden = false
        comboBar.isHidden = true
        
        health = 3
        prepareFood()
        scoreSession = 50
        scoreOutlet.text = "\(scoreSession)"
        
        UIView.animate(withDuration: 0.5) {
            self.scoreOutlet.frame.origin.y += 60
        }
        ambienceSound?.stop()
        inGameMusic()
        
    }
    
    func prepareFood() {
        generatingFood()

        foodButtonOutlet.isEnabled = false
        notFoodButtonOutlet.isEnabled = false

        self.foodOutlet.frame.origin.y = 750

        switch isGameOver {
        case false:
            UIView.animate(withDuration: 0.2, animations: {
                self.foodOutlet.frame.origin.y -= 380
            }) { (true) in
                self.foodButtonOutlet.isHighlighted = false
                self.notFoodButtonOutlet.isHighlighted = false
                
                self.foodButtonOutlet.isEnabled = true
                self.notFoodButtonOutlet.isEnabled = true
            }
        default:
            print("no control")
        }
    }
    
    
    func gameOver() {

        catAngrySound()
        gameplayMusic?.stop()
        
        isGameOver = true
        gameOverOutlet.isHidden = false
        foodButtonOutlet.isEnabled = false
        notFoodButtonOutlet.isEnabled = false
        
        scoreOutlet.isHidden = true
        comboOutlet.isHidden = true
        comboBar.isHidden = true
        
        gameOverScoreSessionOutlet.text = "\(scoreSession)"
        
        hiScore = UserDefaults.standard.integer(forKey: "hiScore")
        
        if hiScore! >= scoreSession {
            gameOverHiScoreOutlet.text = "\(hiScore!)"
        } else {
            UserDefaults.standard.set(scoreSession, forKey: "hiScore")
            gameOverHiScoreOutlet.text = "\(scoreSession)-NEW!!"
            UpdateLeaderboard()
        }
//        foodButtonOutlet.isHighlighted = true
//        notFoodButtonOutlet.isHighlighted = true
        waitingForAnswer = 5
    }
    
    func updateScore() {
        scoreOutlet.text = "\(scoreSession)"
        print("score is : \(scoreSession)")
    }
    
    func rightAnswer() {
        comboOutlet.isHidden = true
        comboTimer?.invalidate()
        goodFeedback.impactOccurred()
        catEatSound()
        updateScore()

        switch numberOfCombo {
        case 0...10:
            if comboBar.progress > 0 {
                comboBar.isHidden = false
                comboBar.progress = 1
                comboTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(timerCombo), userInfo: nil, repeats: true)
                numberOfCombo += 1
            } else {
                numberOfCombo = 0
                comboBar.progress = 1
            }
        default:
            if comboBar.progress > 0 {
                comboBar.isHidden = false
                comboBar.progress = 1
                comboTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCombo), userInfo: nil, repeats: true)
                numberOfCombo += 1
            } else {
                numberOfCombo = 0
                comboBar.progress = 1
            }

        }
        comboCheck()
    }
    
    @objc func timerCombo() {
        comboBar.progress -= 0.01
        if comboBar.progress == 0 {
            comboTimer?.invalidate()
            comboBar.isHidden = true
            comboOutlet.isHidden = true
        }
    }
    
    func wrongAnswer() {
        comboOutlet.isHidden = true

        comboBar.isHidden = true
        comboTimer?.invalidate()
        badFeedback.impactOccurred()
        catAngrySound()
        scoreSession = scoreSession - 15
        health = health - 1
        updateScore()
        numberOfCombo = 0
        checkHealth()
    }
    
    func checkHealth() {
        switch health {
        case 2:
            self.view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case 1:
            self.view.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        case 0:
            gameOver()
        default:
            self.view.backgroundColor = #colorLiteral(red: 0.7851128578, green: 0.7802764177, blue: 0.5960496068, alpha: 1)
        }
    }
    
    func comboCheck() {
        
        switch numberOfCombo {
        case 0...2:
            print("no combo")
            scoreSession = scoreSession + 3
            
        case 3...10:
            scoreSession = scoreSession + (3 * numberOfCombo)
            comboOutlet.isHidden = false
            comboOutlet.text = "combo \(numberOfCombo)x"
            UIView.animate(withDuration: 0.3) {
                self.comboOutlet.frame.origin.y -= 30
            }

        default:
            scoreSession = scoreSession + (3 * numberOfCombo * 2)
            comboOutlet.isHidden = false
            comboOutlet.text = "SUPER COMBO \(numberOfCombo)X"
            UIView.animate(withDuration: 0.3) {
                self.comboOutlet.frame.origin.y -= 30
            }
        }
    }
    
    func generatingFood() {
        foodOutlet.image = whichfood.randomElement()
    }

    @IBAction func notFoodButton(_ sender: UIButton, forEvent event: UIEvent) {
        buttonSound()
        switch foodOutlet.image {
        case #imageLiteral(resourceName: "foodFish"):
            wrongAnswer()
        default:
            rightAnswer()
        }
        prepareFood()
        waitingForAnswer = 5
    }
    
    @IBAction func foodButton(_ sender: UIButton) {
        buttonSound()
        switch foodOutlet.image {
        case #imageLiteral(resourceName: "foodFish"):
            rightAnswer()
        default:
            wrongAnswer()
        }
        prepareFood()
        waitingForAnswer = 5
    }
    
    @IBAction func tapToPlay(_ sender: UIButton) {
        tapToPlayOutlet.isHidden = true
        startButtonSound()
        gameStart()
    }
    
    @IBAction func startupButton(_ sender: UIButton) {
        gameOverOutlet.isHidden = true
        scoreSession = 0
        scoreOutlet.text = "\(scoreSession)"
        foodOutlet.isHidden = true
        tapToPlayOutlet.isHidden = false
        self.view.backgroundColor = #colorLiteral(red: 0.7851128578, green: 0.7802764177, blue: 0.5960496068, alpha: 1)
        self.scoreOutlet.frame.origin.y = -40
    }
    
    //MARK: - GameKit things
    // Submit score to GC leaderboard
    func UpdateLeaderboard() {
    let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
    bestScoreInt.value = Int64(scoreSession)
    GKScore.report([bestScoreInt]) { (error) in
    if error != nil {
    print(error!.localizedDescription)
    } else {
    print("Best Score submitted to your Leaderboard!")
    }
    }
    }

    
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
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    @IBAction func leaderBoardButton(_ sender: UIButton) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
}
