//
//  ViewController.swift
//  Cat Eat Fish
//
//  Created by Yulibar Husni on 27/03/19.
//  Copyright © 2019 Yulibar Husni. All rights reserved.
//

import UIKit

var scoreSession: Int = 50
var hiScore: Int?
var health = 3
var isGameOver = false
let duration = Double.random(in: 1.0...3.0)


var mainScreen: ViewController!

class ViewController: UIViewController {
    

    
    let goodFeedback = UIImpactFeedbackGenerator(style: .light)
    let badFeedback = UIImpactFeedbackGenerator(style: .heavy)

    
    //var gameOverFrame: GameOverFrameViewController?

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
    
    
    var whichfood:[UIImage] = [#imageLiteral(resourceName: "foodFish"),#imageLiteral(resourceName: "foodMeat")]


    override func viewDidLoad() {
        super.viewDidLoad()
        startingMusic()
        foodButtonOutlet.isHighlighted = true
        notFoodButtonOutlet.isHighlighted = true
        
        foodButtonOutlet.isEnabled = false
        notFoodButtonOutlet.isEnabled = false
        
        scoreOutlet.isHidden = true

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
        
        foodOutlet.isHidden = false
        foodButtonOutlet.isHighlighted = false
        notFoodButtonOutlet.isHighlighted = false
        foodButtonOutlet.isEnabled = true
        notFoodButtonOutlet.isEnabled = true
        scoreOutlet.isHidden = false
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
        
//        foodButtonOutlet.isHighlighted = true
//        notFoodButtonOutlet.isHighlighted = true
        
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
        
        gameOverScoreSessionOutlet.text = "\(scoreSession)"
        
        hiScore = UserDefaults.standard.integer(forKey: "hiScore")
        
        if hiScore! >= scoreSession {
            gameOverHiScoreOutlet.text = "\(hiScore!)"
        } else {
            UserDefaults.standard.set(scoreSession, forKey: "hiScore")
            gameOverHiScoreOutlet.text = "\(scoreSession) - NEW!!"

        }
//        foodButtonOutlet.isHighlighted = true
//        notFoodButtonOutlet.isHighlighted = true
        print("GAME OVER")
    }
    
    func updateScore() {
        scoreOutlet.text = "\(scoreSession)"
        print("score is : \(scoreSession)")
    }
    
    func rightAnswer() {
        goodFeedback.impactOccurred()
        catEatSound()
        scoreSession = scoreSession + 3
        updateScore()
        //performSegue(withIdentifier: "gameOverSegue", sender: self)
    }
    
    func wrongAnswer() {
        badFeedback.impactOccurred()
        catAngrySound()
        scoreSession = scoreSession - 15
        health = health - 1
        updateScore()
        
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
}
