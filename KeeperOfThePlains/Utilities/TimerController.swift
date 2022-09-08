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
    func timerSecondTick()
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
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            timeDelegate?.timerSecondTick()
            //NOTE: - Print statement only for testing purposes remove when done testing
            print("[TimerController] - Time Remaining: \(timeRemaining)")
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            timeDelegate?.cropTimerCompleted()
            print("\n[TimerController] - secondTick: The timer has run out\n")
        }
    }
    
    func startTimer(time: TimeInterval) {
        print("\n[TimerController] - startTimer: The timer has started\n")
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
        if isOn {
            timer?.invalidate()
            timeRemaining = nil
            timeDelegate?.cropTimerStopped()
        }
    }
    
    
    func timeAsString() -> String { // make it into a readable time
        let timeRemaining = Int(self.timeRemaining ?? 20*60) // 2o minutes (12,000 second). want and Int in order to avoid 12:00:21 seconds
        let minutes = timeRemaining / 60
        let seconds = timeRemaining - (minutes * 60) // remainder will give you the seconds

        return String(format: "%02d : %02d", arguments: [minutes, seconds]) // the % will get replaced by the arguments you put in the line of code
    }

}
