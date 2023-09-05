//
//  SummaryPlayerView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI
import Domain
import DI
import Extensions

struct SummaryPlayerView: View {
    
    @InjectObject private var viewModel: SummaryPlayerViewModel
    @Inject private var audioPlayerViewModel: AudioPlayerViewModel
    
    private let speedOptions = AppConstants.Speed.availableOptions
    
    @State private var progress: Double = 0
    @State private var duration: Double = 0
    @State private var speed: Double = AppConstants.Speed.defaultAudioRate
    @State private var playerState: AudioPlayerState = .stopped
    @State private var nowPlayingChapterIndex: Int = 1

    @State private var errorMessage: ErrorMessage?

    @State private var book: Book?
    
    private var currentChapter: Chapter? {
        guard let book else { return nil }
        return book.chapters[nowPlayingChapterIndex]
    }
    
    /// Used to dynamically update play controls.
    private var canGoToPreviousChapter: Binding<Bool> {
        Binding<Bool>(
            get: { nowPlayingChapterIndex > 0 },
            set: { _ in }
         )
    }
    
    private var canGoToNextChapter: Binding<Bool> {
        Binding<Bool>(
            get: { nowPlayingChapterIndex < (book?.chapters.count ?? 0) - 1 },
            set: { _ in }
        )
    }

    var body: some View {
        contenView
            .background(
                Color.backgroundColor
            )
            .onReceive(viewModel.$uiState) { state in
                switch state {
                case .failure(let error):
                    errorMessage = error
                case .book(let bookData):
                    book = bookData
                    audioPlayerViewModel.prepareForPlaying(bookData)
                default:
                    break
                }
            }
            .onChange(of: speed) { newSpeedRate in
                audioPlayerViewModel.setSpeed(newSpeedRate)
            }
            .onReceive(audioPlayerViewModel.$playerState) { newAudioState in
                playerState = newAudioState
            }
            .onReceive(audioPlayerViewModel.$audioProgress) { newProgress in
                duration = audioPlayerViewModel.duration
                progress = newProgress ?? 0
            }
            .onReceive(audioPlayerViewModel.$playingChapterIndex) { nowPlayingChapterIndex in
                duration = currentChapter?.duration ?? 0
                self.nowPlayingChapterIndex = nowPlayingChapterIndex
            }
            .alert(item: $errorMessage) {
                Alert.with($0)
            }
    }
    
    @ViewBuilder
    private var contenView: some View {
        VStack {
            coverView
            
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 12) {
                    keyPointInfoView
                    titleView
                }
                .padding(.horizontal, 16)
                
                VStack(spacing: 4) {
                    audioProgressView
                    speedControlView
                }
                Spacer()
            }

            playControlsView
                .padding(.bottom, 48)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private var coverView: some View {
        BookCoverView(
            url: book?.coverUrl
        )
        .frame(minHeight: 270)
    }
    
    @ViewBuilder
    private var keyPointInfoView: some View {
        if let book {
            Text("Chapter \(nowPlayingChapterIndex + 1) of \(book.chapters.count)".uppercased())
                .foregroundColor(.gray)
                .font(.callout)
        }
    }
    
    private var titleView: some View {
        Text(currentChapter?.title ?? "Chapter Title Not Available")
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .font(.body)
    }
    
    private var audioProgressView: some View {
        AudioProgressView(
            progress: $progress,
            duration: $duration,
            onSeekPlayer: { newTime in
                audioPlayerViewModel.seek(to: newTime)
            }
        )
    }
    
    private var speedControlView: some View {
        SpeedControlView(
            speedOptions: speedOptions,
            selectedSpeed: $speed
        )
    }
    
    private var playControlsView: some View {
        PlayControlView(
            playerState: $playerState,
            canGoBackward: canGoToPreviousChapter,
            canGoForward: canGoToNextChapter,
            onPlay: {
                switch playerState {
                case .playing:
                    audioPlayerViewModel.pause()
                case .paused:
                    audioPlayerViewModel.resume()
                case .stopped:
                    audioPlayerViewModel.play()
                }
            },
            onMoveToPrevious: {
                audioPlayerViewModel.playPreviousChapter()
            }, onSeek5SecBack: {
                audioPlayerViewModel.seek5secondsBackward()
            }, onSeek10SecForward: {
                audioPlayerViewModel.seek10secondsForward()
            }, onMoveToNext: {
                audioPlayerViewModel.playNextChapter()
            }
        )
    }
}

struct SummaryPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPlayerView()
    }
}
