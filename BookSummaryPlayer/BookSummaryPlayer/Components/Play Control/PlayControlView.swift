//
//  PlayControlView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 01.09.2023.
//

import SwiftUI

struct PlayControlView: View {
    
    @Binding var playerState: AudioPlayerState
    @Binding var canGoBackward: Bool
    @Binding var canGoForward: Bool

    var onPlay: () -> Void
    var onMoveToPrevious: () -> Void
    var onSeek5SecBack: () -> Void
    var onSeek10SecForward: () -> Void
    var onMoveToNext: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            Group {
                backwardEndButton
                goBackward5Button
                playButton
                goForward10Button
                forwardEndButton
            }
            .foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    private var backwardEndButton: some View {
        Button {
            onMoveToPrevious()
        } label: {
            iconView(.moveToPrevious)
                .frame(
                    width: 20,
                    height: 20
                )
        }
        .disabled(!canGoBackward)
        .opacity(canGoBackward ? 1 : 0.3)
    }
    
    @ViewBuilder
    private var goBackward5Button: some View {
        Button {
            onSeek5SecBack()
        } label: {
            iconView(.seekBackward)
                .frame(
                    width: 30,
                    height: 30
                )
        }
    }
    
    @ViewBuilder
    private var playButton: some View {
        Button {
            onPlay()
        } label: {
            iconView(playerState == .playing ? .pause : .play)
                .frame(
                    width: 35,
                    height: 35
                )
        }
    }
    
    @ViewBuilder
    private var goForward10Button: some View {
        Button {
            onSeek10SecForward()
        } label: {
            iconView(.seekForward)
                .frame(
                    width: 30,
                    height: 30
                )
        }
    }
    
    @ViewBuilder
    private var forwardEndButton: some View {
        Button {
            onMoveToNext()
        } label: {
            iconView(.moveToNext)
                .frame(
                    width: 20,
                    height: 20
                )
        }
        .disabled(!canGoForward)
        .opacity(canGoForward ? 1 : 0.3)
    }
    
    private func iconView(_ action: PlaybackAction) -> some View {
        Image(systemName: action.iconName)
            .resizable()
    }
}
