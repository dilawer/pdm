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
        player.pause()
    }
    
    func play() {
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
