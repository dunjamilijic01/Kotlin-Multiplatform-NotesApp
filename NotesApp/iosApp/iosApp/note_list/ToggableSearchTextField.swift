//
//  ToggableSearchTextField.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI

struct ToggableSearchTextField<Destination :View>: View {
    var onSearchToggled :() -> Void
    var destinationProvider :() -> Destination
    var isSearchActive :Bool
    @Binding var searchText :String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .opacity(isSearchActive ? 1 : 0)
            
            if !isSearchActive{
                Spacer()
            }
            
            Button(action: onSearchToggled){
                Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                    .foregroundColor(.black)
            }
            
            NavigationLink(destination: destinationProvider()){
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }
        }
    }
}
