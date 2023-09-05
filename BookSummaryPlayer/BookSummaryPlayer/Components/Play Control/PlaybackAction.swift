//
//  PlaybackAction.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 05.09.2023.
//

import Foundation

public enum PlaybackAction {
    case play
    case pause
    case moveToPrevious
    case moveToNext
    case seekBackward
    case seekForward
}

extension PlaybackAction {
    
    var iconName: String {
        switch self {
        case .play:
            return "play.fill"
        case .pause:
            return "pause.fill"
        case .moveToPrevious:
            return "backward.end.fill"
        case .moveToNext:
            return "forward.end.fill"
        case .seekBackward:
            return "gobackward.5"
        case .seekForward:
            return "goforward.10"
        }
    }
}
