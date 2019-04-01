//
//  soundController.swift
//  Cat Eat Fish
//
//  Created by Yulibar Husni on 29/03/19.
//  Copyright © 2019 Yulibar Husni. All rights reserved.
//

import Foundation
import AVFoundation

var pushButton: AVAudioPlayer?
var startSound: AVAudioPlayer?
var gameplayMusic: AVAudioPlayer?
var catLove: AVAudioPlayer?
var catAngry: AVAudioPlayer?
var ambienceSound: AVAudioPlayer?
var endSound: AVAudioPlayer?
var hiScoreSound: AVAudioPlayer?

func buttonSound() {
    let audioFileURL = Bundle.main.url(forResource: "button_push", withExtension: "wav")
    do {
        try pushButton = AVAudioPlayer(contentsOf: audioFileURL!)
        pushButton?.volume = 2
    } catch let error {
        print(error.localizedDescription)
    }
    pushButton?.play()
}

func startButtonSound() {
    let audioFileURL = Bundle.main.url(forResource: "start", withExtension: "wav")
    do {
        try startSound = AVAudioPlayer(contentsOf: audioFileURL!)
        startSound?.volume = 0.5
    } catch let error {
        print(error.localizedDescription)
    }
    startSound?.play()
}

func catEatSound() {
    let audioFileURL = Bundle.main.url(forResource: "catLove", withExtension: "mp3")
    do {
        try catLove = AVAudioPlayer(contentsOf: audioFileURL!)
        catLove?.volume = 2
    } catch let error {
        print(error.localizedDescription)
    }
    catLove?.play()
}

func catAngrySound() {
    let audioFileURL = Bundle.main.url(forResource: "gameOver", withExtension: "mp3")
    do {
        try catAngry = AVAudioPlayer(contentsOf: audioFileURL!)
        catAngry?.volume = 2
    } catch let error {
        print(error.localizedDescription)
    }
    catAngry?.play()
}

func inGameMusic() {
    let audioFileURL = Bundle.main.url(forResource: "music-inGame", withExtension: "mp3")
    do {
        try gameplayMusic = AVAudioPlayer(contentsOf: audioFileURL!)
        gameplayMusic?.volume = 3
    } catch let error {
        print(error.localizedDescription)
    }
    gameplayMusic?.play()
    gameplayMusic?.numberOfLoops = Int(FP_INFINITE)
}

func startingMusic() {
    let audioFileURL = Bundle.main.url(forResource: "startingMusic", withExtension: "mp3")
    do {
        try ambienceSound = AVAudioPlayer(contentsOf: audioFileURL!)
        ambienceSound?.volume = 1
    } catch let error {
        print(error.localizedDescription)
    }
    ambienceSound?.play()
    ambienceSound?.numberOfLoops = Int(FP_INFINITE)
}

func gameFinished() {
    let audioFileURL = Bundle.main.url(forResource: "end", withExtension: "mp3")
    do {
        try endSound = AVAudioPlayer(contentsOf: audioFileURL!)
        endSound?.volume = 1.5
    } catch let error {
        print(error.localizedDescription)
    }
    endSound?.play()
}

func newHiScoreSound() {
    let audioFileURL = Bundle.main.url(forResource: "hiscore", withExtension: "mp3")
    do {
        try hiScoreSound = AVAudioPlayer(contentsOf: audioFileURL!)
        hiScoreSound?.volume = 1.5
    } catch let error {
        print(error.localizedDescription)
    }
    hiScoreSound?.play()
}
