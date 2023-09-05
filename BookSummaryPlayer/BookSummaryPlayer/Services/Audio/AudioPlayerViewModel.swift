//
//  AudioPlayerViewModel.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import AudioStreaming
import AVFoundation
import Combine
import Logger
import MediaPlayer
import Domain

class AudioPlayerViewModel: NSObject, ObservableObject {
    
    @Published var playingChapter: Chapter? = nil
    @Published var playingChapterIndex: Int = 0

    @Published var playerState: AudioPlayerState = .stopped
    @Published var audioRate: Double = AppConstants.Speed.defaultAudioRate
    @Published var audioProgress: Double? = nil

    private var player: AudioPlayer
    private var audioSystemResetObserver: AnyCancellable?
    private var audioSystemInterruptObserver: AnyCancellable?
    
    private var nowPlayingCenter: NowPlayingCenterProtocol!
    private let audioSessionManager: AudioSessionManagerProtocol

    private var cancellable = Set<AnyCancellable>()
    private var timer: Timer?

    private var currentBook: Book?

    var duration: Double {
        player.duration
    }
    
    var progress: Double {
        player.progress
    }
    
    var isPlaying: Bool {
        player.isEngineRunning
    }
    
    init(player: AudioPlayer = AudioPlayer(configuration: .init(enableLogs: true)),
         audioSessionManager: AudioSessionManagerProtocol = AudioSessionManager()) {
        self.audioSessionManager = audioSessionManager
        self.player = player
        super.init()

        player.delegate = self
        nowPlayingCenter = NowPlayingCenter(playerService: self)

        audioSessionManager.configureAudioSession()
        registerSessionEvents()
        setupActionsToControlCenter()
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    // MARK: - Public Methods

    func prepareForPlaying(_ book: Book) {
        currentBook = book
        playingChapterIndex = 0
    }
    
    func play() {
        guard let currentBook else { return }
        playChapter(currentBook.chapters[playingChapterIndex])
    }
    
    private func playChapter(_ chapter: Chapter) {
        playingChapter = chapter

        // Load and play the new chapter
        play(url: chapter.fileUrl)
        updateAudioProgress()
    }

    func pause() {
        if self.isPlaying {
            self.player.pause()
        }
    }
    
    func resume() {
        player.resume()
    }
    
    func setSpeed(_ rate: Double) {
        player.rate = Float(rate)
        audioRate = rate
    }
    
    func seek(to time: Double) {
        player.seek(to: time)
        updateAudioProgress()
    }
    
    func seek10secondsForward() {
        let timeToSeek = player.progress + 10
        if timeToSeek >= duration {
            seek(to: duration - 1)
        } else {
            seek(to: timeToSeek)
        }
    }
    
    func seek5secondsBackward() {
        let timeToSeek = player.progress - 5
        if timeToSeek <= 0 {
            seek(to: 0)
        } else {
            seek(to: timeToSeek)
        }
    }
    
    func playNextChapter() {
        guard let currentBook else { return }

        if playingChapterIndex < currentBook.chapters.count - 1 {
            playingChapterIndex += 1
            playChapter(currentBook.chapters[playingChapterIndex])
        } else {
            // There are no more chapters
        }
    }

    func playPreviousChapter() {
        guard let currentBook else { return }

        if playingChapterIndex > 0 {
            playingChapterIndex -= 1
            playChapter(currentBook.chapters[playingChapterIndex])
        } else {
            // It's the first chapter
        }
    }
    
    // MARK: - Private Methods
    
    private var canResume: Bool {
        playingChapter != nil
    }
    
    private func play(url: URL) {
        audioSessionManager.activateAudioSession()
        player.play(url: url)
        updateCurrentPlayingInfo()
    }
    
    private func recreatePlayer() {
        player = AudioPlayer(configuration: .init(enableLogs: true))
        player.delegate = self
    }
    
    private func registerSessionEvents() {
        audioSystemResetObserver = NotificationCenter.default
            .publisher(for: AVAudioSession.mediaServicesWereResetNotification)
            .sink { [weak self] _ in
                self?.audioSessionManager.configureAudioSession()
                self?.recreatePlayer()
            }
        
        audioSystemInterruptObserver = NotificationCenter.default
            .publisher(for: AVAudioSession.interruptionNotification)
            .sink { [weak self] notification in
                self?.handleAudioSessionInterruption(notification: notification)
            }
    }
    
    private func updateCurrentPlayingInfo() {
        if let currentBook {
            nowPlayingCenter.updateCurrentPlayingBookInfo(currentBook)
        }
    }
    
    private func setupActionsToControlCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // Play command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.isPlaying == false, self.canResume {
                self.resume()
                return .success
            }
            return .commandFailed
        }

        // Pause command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.isPlaying {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionTypeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeValue) else {
            return
        }

        switch interruptionType {
        case .began:
            // Handle audio interruption (e.g., phone call)
            self.player.pause()
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)

            // Resume audio playback after interruption ends (e.g., phone call ends)
            if options.contains(.shouldResume) {
                resume()
                updateCurrentPlayingInfo()
            }
        @unknown default:
            break
        }
    }
    
    private func startUpdatingProgress() {
        // Invalidate the existing timer if any to prevent multiple timers running at once
        timer?.invalidate()

        // Create a new timer to update the progress every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateAudioProgress()
        }
    }
    
    private func stopUpdatingProgress() {
        // Invalidate the timer to stop updates
        timer?.invalidate()
        timer = nil
    }

    private func updateAudioProgress() {
        // Update the audioProgress property based on the current player's progress
        audioProgress = progress
        nowPlayingCenter.updateProgress(progress)
    }
}

extension AudioPlayerViewModel: AudioPlayerDelegate {
    
    func audioPlayerDidStartPlaying(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
        Log.info("Player Did Start Playing")
    }
    
    func audioPlayerDidFinishBuffering(player: AudioStreaming.AudioPlayer, with entryId: AudioStreaming.AudioEntryId) {
        Log.info("Player Did Finish Buffering")
    }
    
    func audioPlayerStateChanged(player: AudioStreaming.AudioPlayer, with newState: AudioStreaming.AudioPlayerState, previous: AudioStreaming.AudioPlayerState) {
        Log.info("Player State Changed with new state: \(newState), previous: \(previous)")
        switch newState {
        case .playing:
            playerState = .playing
            startUpdatingProgress() // Start updating progress when playback begins
        case .paused, .error:
            playerState = .paused
            stopUpdatingProgress() // Stop updating progress when playback is paused or encounters an error
        case .disposed, .stopped:
            playerState = .stopped
            stopUpdatingProgress() // Stop updating progress when playback stops
        default:
            break
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AudioStreaming.AudioPlayer, entryId: AudioStreaming.AudioEntryId, stopReason: AudioStreaming.AudioPlayerStopReason, progress: Double, duration: Double) {
        Log.info("Player Did Finish Playing")
        
        // Audio reached the end, can move to the next chapter.
        if Int(progress) == Int(duration) {
            playNextChapter()
        }
    }
    
    func audioPlayerUnexpectedError(player: AudioStreaming.AudioPlayer, error: AudioStreaming.AudioPlayerError) {
        Log.error("audio Player Unexpected Error")
    }
    
    func audioPlayerDidCancel(player: AudioStreaming.AudioPlayer, queuedItems: [AudioStreaming.AudioEntryId]) {
        Log.info("audio Player Did Cancel")
    }
    
    func audioPlayerDidReadMetadata(player: AudioStreaming.AudioPlayer, metadata: [String : String]) {
        // Implement handling of metadata if needed.
    }
}
