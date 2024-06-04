//
//  RMSettingView.swift
//  RickAndMorty
//
//  Created by Дарья Балацун on 23.05.24.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.imageView {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}



#Preview("Setting View") {
    RMSettingsView(viewModel: .init(
        cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in 
                
            }
        })))
}


