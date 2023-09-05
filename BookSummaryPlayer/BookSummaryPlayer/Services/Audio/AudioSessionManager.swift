//
//  AudioSessionManager.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import Logger
import AudioStreaming
import AVFoundation

public protocol AudioSessionManagerProtocol {
    func configureAudioSession()
    func registerSessionEvents()
    func setupActionsToControlCenter()
    func activateAudioSession()
    func stopAudioSession()
}

public class AudioSessionManager: AudioSessionManagerProtocol {
    
    public func configureAudioSession() {
        do {
            Log.info("AudioSession category is AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.1)
        } catch {
            Log.error("Couldn't setup audio session category to Playback: \(error.localizedDescription)")
        }
    }
    
    public func registerSessionEvents() {
        // Register session events here using Combine publishers or NotificationCenter.
    }
    
    public func setupActionsToControlCenter() {
        // Set up actions to control center using Combine publishers or MPRemoteCommandCenter.
    }
    
    public func activateAudioSession() {
        do {
            Log.info("AudioSession is active")
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            Log.error("Couldn't set audio session to active: \(error.localizedDescription)")
        }
    }
    
    public func stopAudioSession() {
        do {
            Log.info("AudioSession is stopped")
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            Log.error("Couldn't stop audio session: \(error.localizedDescription)")
        }
    }
}
