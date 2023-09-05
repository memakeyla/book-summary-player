//
//  SpeedControlView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI
import Extensions

struct SpeedControlView: View {
    
    @State var speedOptions: [Double]
    @Binding var selectedSpeed: Double
    
    var body: some View {
        Menu {
            Picker(selection: $selectedSpeed, label: Text("")) {
                ForEach(speedOptions, id: \.self) { speedOption in
                    Text(speedOption.formattedSpeedRate).tag(speedOption)
                }
            }
        } label: {
            Text("Speed \(selectedSpeed.formattedSpeedRate)")
                .font(.caption)
                .bold()
                .foregroundColor(.black)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                )
        }
    }
}

struct SpeedControlView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedControlView(
            speedOptions: [1.0, 1.5, 2.0],
            selectedSpeed: .constant(1.0)
        )
    }
}
