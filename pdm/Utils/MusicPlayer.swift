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
    var delegate:MusicDelgate?
    var isPlaying:Bool{
        return self.player.isPlaying
    }

    func initPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playAudioBackground()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        updater = CADisplayLink(target: self, selector: #selector(MusicPlayer.trackAudio))
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        setupRemoteTransportControls()
        setupNowPlaying()
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc func trackAudio() {
        let current:Double = player.currentTime().seconds
        if let total = player.currentItem?.asset.duration{
            let total:Double = CMTimeGetSeconds(total)
            let normalizedTime = Float( current / total)
            if let progressBar = progressBar{
                progressBar.progress = normalizedTime
            }
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        delegate?.playerStausChanged(isPlaying: false)
        if let progressBar = progressBar{
            progressBar.progress = 0
        }
        if let globalList = Global.shared.podDetails{
            if globalList.pods.count > Global.shared.currentPlayingIndex{
                let new = globalList.pods[Global.shared.currentPlayingIndex]
                MusicPlayer.instance.stop()
                MusicPlayer.instance.initPlayer(url: new.episodeFileLink)
                Global.shared.currentPlayingIndex += 1
                Global.shared.podcaste = new
                delegate?.songChanged(pod: new)
                MusicPlayer.instance.play()
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
