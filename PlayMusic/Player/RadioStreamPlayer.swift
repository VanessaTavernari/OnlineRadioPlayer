//
//  RadioStreamPlayer.swift
//  PlayMusic
//
//  Created by Vanessa Tavares Tavernari on 25/02/2022.
//

import Foundation
import Combine
import AVFoundation
import MediaPlayer

class RadioStreamPlayer {
        
    private var playerItem: AVPlayerItem { AVPlayerItem(url: URL(string: "http://coloniafm.ddns.net:8000/stream")!) }

    var isBuffering = CurrentValueSubject<Bool, Never>(false)
    var isPlaying = CurrentValueSubject<Bool, Never>(false)
    
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    
    private var player: AVPlayer?
    
    let commandCenter = MPRemoteCommandCenter.shared()
    
    init() {
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        commandCenter.previousTrackCommand.isEnabled = false;
        commandCenter.nextTrackCommand.isEnabled = false

        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            
            self.playRadio()
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            
            self.pauseRadio()
            return .success
        }
        
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
    }
    
    @objc
     func playRadio() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        playerItemBufferFullObserver?.invalidate()
        playerItemBufferKeepUpObserver?.invalidate()
        playerItemBufferFullObserver?.invalidate()
        
        player = AVPlayer(playerItem: playerItem)
        player?.allowsExternalPlayback = true
        
        playerItemBufferEmptyObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            self.isBuffering.send(true)
        }
            
        playerItemBufferKeepUpObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            self.isBuffering.send(false)
        }
            
        playerItemBufferFullObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            self.isBuffering.send(false)
        }
        
        player?.play()
        self.isPlaying.send(true)
        self.setupNowPlaying()
        
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Rádio Colônia FM"

        if let image = UIImage(named: "lockscreen") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    @objc
     func pauseRadio() {
        
        player?.pause()
        self.isPlaying.send(false)
    }
    
    func togglePlayOrPause() {
        
        if self.isPlaying.value  {
            
            self.pauseRadio()
            
        } else {
            
            self.playRadio()
        }
    }
    
}
