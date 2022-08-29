//
//  TimerController.swift
//  FarmersGuild
//
//  Created by Brian Pagani on 8/24/22.
//

import Foundation

protocol TimerControllerDelegete: AnyObject {
    
    func cropTimerCompleted()
    func cropTimerStopped()
}

class TimerController {
    
    weak var timeDelegate: TimerControllerDelegete?
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    var isOn: Bool {
        if timeRemaining != nil {
            return true
        } else {
            return false
        }
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            timeDelegate?.cropTimerCompleted()
            print("\n[TimerController] - secondTick: The timer has run out.\n")
        }
    }
    
    func startTimer(time: TimeInterval) {
        if !isOn {
            timeRemaining = time
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn{
            timer?.invalidate()
            timeRemaining = nil
        }
    }
}
