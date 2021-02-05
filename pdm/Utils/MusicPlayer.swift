//
//  MusicPlayer.swift
//  pdm
//
//  Created by Muhammad Aqeel on 24/12/2020.
//

import Foundation
import AVKit
import AVFoundation
import UIKit
import MediaPlayer

class MusicPlayer {
    public static var instance = MusicPlayer()
    var player = AVPlayer()
    var updater : CADisplayLink! = nil
    var progressBar:UIProgressView?
    var lblDuration:UILabel?
    var delegate:MusicDelgate?
    var isPlaying:Bool{
        return self.player.isPlaying
    }
    var didRepeat = false
    var didShuffle = false
    var isPause = false

    func initPlayer(url: String,shouldPlay:Bool = true) {
        guard let url = URL(string: url) else { return }
        let asset = AVAsset(url: url)
        let keys: [String] = ["playable"]
        getTime()
        asset.loadValuesAsynchronously(forKeys: keys, completionHandler: {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                DispatchQueue.main.async { [self] in
                    let playerItem = AVPlayerItem(asset: asset)
                    self.player = AVPlayer(playerItem: playerItem)
                    if shouldPlay{
                        self.playAudioBackground()
                        self.delegate?.playerStausChanged(isPlaying: true)
                        self.player.play()
                    }
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    self.updater = CADisplayLink(target: self, selector: #selector(MusicPlayer.trackAudio))
                    self.updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
                    self.setupRemoteTransportControls()
                    self.setupNowPlaying()
                    NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                    
                }
                break
            case .failed:
                 DispatchQueue.main.async {
                     
                }
                break
             case .cancelled:
                DispatchQueue.main.async {
                    
                }
                break
             default:
                break
            }
        })
    }
    
    @objc func trackAudio() {
        getTime()
    }
    func getTime(){
        let current:Double = player.currentTime().seconds
        if let total = player.currentItem?.asset.duration{
            let total:Double = CMTimeGetSeconds(total)
            let normalizedTime = Float( current / total)
            if let progressBar = progressBar{
                progressBar.progress = normalizedTime
            }
            if let lblDuration = lblDuration{
                var sec = Int(total-current)
                let mint = sec/60
                sec = sec - (Int(mint)*60)
                lblDuration.text = "\(String(format: "%02d", mint)):\(String(format: "%02d", sec))"
            }
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        if self.didRepeat{
            MusicPlayer.instance.player.seek(to: CMTime.zero)
            MusicPlayer.instance.player.play()
            return
        }
        guard UserDefaults.standard.bool(forKey: kAutoPlay) else {
            player.pause()
            delegate?.playerStausChanged(isPlaying: false)
            MusicPlayer.instance.player.seek(to: CMTime.zero)
            return
        }
        delegate?.playerStausChanged(isPlaying: false)
        if let progressBar = progressBar{
            progressBar.progress = 0
        }
        if let globalList = Global.shared.podDetails{
            if self.didShuffle{
                MusicPlayer.instance.stop()
                let range = 0..<globalList.pods.count
                let index = range.randomElement() ?? Global.shared.currentPlayingIndex+1
                if globalList.pods.count > index{
                    let new = globalList.pods[index]
                    MusicPlayer.instance.initPlayer(url: new.episodeFileLink)
//                    Global.shared.currentPlayingIndex += 1
                    Global.shared.podcaste = new
                    delegate?.songChanged(pod: new)
                    MusicPlayer.instance.play()
                }
            } else if globalList.pods.count > Global.shared.currentPlayingIndex+1{
                MusicPlayer.instance.stop()
                let new = globalList.pods[Global.shared.currentPlayingIndex+1]
                MusicPlayer.instance.initPlayer(url: new.episodeFileLink)
                Global.shared.currentPlayingIndex += 1
                Global.shared.podcaste = new
                delegate?.songChanged(pod: new)
                MusicPlayer.instance.play()
            } else {
                player.pause()
                delegate?.playerStausChanged(isPlaying: false)
                MusicPlayer.instance.player.seek(to: CMTime.zero)
            }
        }
    }
    
    func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    func pause(){
        isPause = true
        delegate?.playerStausChanged(isPlaying: false)
        player.pause()
    }
    func stop(){
        delegate?.playerStausChanged(isPlaying: false)
        player.pause()
        player = AVPlayer()
    }
    func fastForward(){
        let moveForword : Float64 = 5
        if let duration  = MusicPlayer.instance.player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(MusicPlayer.instance.player.currentTime())
            let newTime = playerCurrentTime + moveForword
            if newTime < CMTimeGetSeconds(duration){
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                MusicPlayer.instance.player.seek(to: selectedTime)
            }
            MusicPlayer.instance.pause()
            MusicPlayer.instance.play()
        }
    }
    func slowForward(){
        let moveForword : Float64 = 5
        if let duration  = MusicPlayer.instance.player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(MusicPlayer.instance.player.currentTime())
            var newTime = playerCurrentTime - moveForword
            if newTime < 0 {
                newTime = 0
            }
            if newTime < CMTimeGetSeconds(duration){
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                MusicPlayer.instance.player.seek(to: selectedTime)
            }
            MusicPlayer.instance.player.pause()
            let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            MusicPlayer.instance.player.seek(to: selectedTime)
            MusicPlayer.instance.pause()
            MusicPlayer.instance.play()
        }
    }
    
    func play() {
        isPause = false
        delegate?.playerStausChanged(isPlaying: true)
        player.play()
    }
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
    }
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "My Movie"
        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.currentItem?.asset.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
protocol MusicDelgate {
    func playerStausChanged(isPlaying:Bool)
    func songChanged(pod:Pod)
}
