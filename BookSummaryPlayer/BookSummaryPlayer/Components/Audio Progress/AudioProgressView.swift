//
//  AudioProgressView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI
import Extensions

struct AudioProgressView: View {
    
    @Binding var progress: Double
    @Binding var duration: Double
    
    var onSeekPlayer: (Double) -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(progress.formattedTime)
                .font(.caption)
                .foregroundColor(.gray)

            Slider(value: $progress, in: 0...duration) { editing in
                if !editing {
                    onSeekPlayer(progress)
                }
            }
            
            Text(duration.formattedTime)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct AudioProgressView_Previews: PreviewProvider {
    static var previews: some View {
        AudioProgressView(
            progress: .constant(200),
            duration: .constant(1928),
            onSeekPlayer: { _ in }
        )
    }
}
