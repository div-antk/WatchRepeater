//
//  InterfaceController.swift
//  WatchRepeater WatchKit Extension
//
//  Created by Takuya Ando on 2021/01/08.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {
  
  var lowGongPlayer:AVAudioPlayer!
  var highGongPlayer:AVAudioPlayer!
  
  private var isPlaying = false
  
  @IBOutlet weak var button: WKInterfaceButton!
  
  override func awake(withContext context: Any?) {
    // Configure interface objects here.
  }
  
  override func willActivate() {
    
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
  }
  
  @IBAction func actionButton() {
    if isPlaying { return }
    isPlaying = true
    
    
    repeater()
  }
  
  func repeater() {
    
    DispatchQueue.global().async {
      
      let now = Date()
      let time = Calendar.current.dateComponents([.hour, .minute], from: now)
      
      // hour を12時間で丸める
      let hour = time.hour! % 12
      let quarter = time.minute! / 15
      let minute = time.minute! % 15
      
      // 低音ゴング
      //      let lowGong:SystemSoundID = 1054
      // 高音ゴング
      //      let highGong:SystemSoundID = 1013
      
      // 第一ゴング
      for _ in 0 ..< hour {
        print("dong")
        //        AudioServicesPlaySystemSound(lowGong)
        self.lowGong()
        // 0.5秒待つ
        Thread.sleep(forTimeInterval: 0.5)
      }
      
      // 第二ゴングが鳴る場合遅延処理
      if quarter > 0 {
        Thread.sleep(forTimeInterval: 0.7)
      }
      
      // 第二ゴング
      for _ in 0 ..< quarter {
        print("ding-dong")
        self.highGong()
        //        AudioServicesPlaySystemSound(highGong)
        // 0.4秒待つ
        Thread.sleep(forTimeInterval: 0.4)
        self.lowGong()
        //        AudioServicesPlaySystemSound(lowGong)
        
        // 0.5秒待つ
        Thread.sleep(forTimeInterval: 0.5)
      }
      
      // 第三ゴングが鳴る場合遅延処理
      if minute > 0 {
        Thread.sleep(forTimeInterval: 0.7)
      }
      
      // 第三ゴング
      for _ in 0 ..< minute {
        print("ding")
        self.lowGong()
        //        AudioServicesPlaySystemSound(highGong)
        
        // 0.5秒待つ
        Thread.sleep(forTimeInterval: 0.5)
      }
      
      self.isPlaying = false
    }
  }
  
  func lowGong() {
    
    let lowGong = Bundle.main.url(forResource: "low", withExtension: "wave")
    do {
      lowGongPlayer = try AVAudioPlayer(contentsOf: lowGong!)
      lowGongPlayer?.play()
    } catch {
      print("error")
    }
  }
  
  func highGong() {
    
    let highGong = Bundle.main.url(forResource: "high", withExtension: "wave")
    do {
      highGongPlayer = try AVAudioPlayer(contentsOf: highGong!)
      highGongPlayer?.play()
    } catch {
      print("error")
    }
  }
}
