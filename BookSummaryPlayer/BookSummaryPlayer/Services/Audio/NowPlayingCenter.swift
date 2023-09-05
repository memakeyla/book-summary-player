//
//  NowPlayingCenter.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import MediaPlayer
import Domain

protocol NowPlayingCenterProtocol {
    func updateCurrentPlayingBookInfo(_ book: Book)
    func updateProgress(_ progress: Double)
}

class NowPlayingCenter: NowPlayingCenterProtocol {
    
    private let nowPlayingCenter: MPNowPlayingInfoCenter
    private var playerService: AudioPlayerViewModel
    
    private var task: URLSessionTask?
    private var session: URLSession { return URLSession.shared }
    
    private var nowPlayingInfo = [String: Any]()

    init(playerService: AudioPlayerViewModel) {
        self.nowPlayingCenter = .default()
        self.playerService = playerService
    }
    
    func updateCurrentPlayingBookInfo(_ book: Book) {
        guard let playingChapter = playerService.playingChapter else {
            // If there is no playing chapter, clear the now playing info
            nowPlayingCenter.nowPlayingInfo = nil
            return
        }
        
        // Set the now playing info
        nowPlayingInfo = [
            MPMediaItemPropertyTitle: playingChapter.title,
            MPMediaItemPropertyAlbumTitle: book.title
        ]
        
        nowPlayingCenter.nowPlayingInfo = nowPlayingInfo

        // Set the cover image as artwork
        updateRemoteImage(url: book.coverUrl)
    }
    
    func updateProgress(_ progress: Double) {
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerService.progress
        nowPlayingCenter.nowPlayingInfo = nowPlayingInfo
    }

    private func overrideInfoCenter(for key: String, value: Any) {
        nowPlayingInfo[key] = value
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func updateRemoteImage(url: URL) {
        task?.cancel()
        task = session.dataTask(with: url) { [weak self] imageData, _, _ in
            guard let self = self, let imageData, let image = UIImage(data: imageData)
                else { return }

            DispatchQueue.main.async {
                let artwork = self.getArtwork(image: image)
                self.overrideInfoCenter(for: MPMediaItemPropertyArtwork, value: artwork)
            }
        }
        task?.resume()
    }
    
    private func getArtwork(image: UIImage) -> MPMediaItemArtwork {
        return MPMediaItemArtwork(boundsSize: image.size) { _ in image }
    }
}
