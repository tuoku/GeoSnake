//
//  SettingsView.swift
//  GeoSnake2
//
//  Created by iosdev on 7.12.2021.
// placeholder for settings 

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Display")) {
                    
                    Toggle(isOn: .constant(true),
                           label: {
                        Text("Dark mode")
                    })
                    
                    Toggle(isOn: .constant(true),
                           label: {
                    Text("Use system settings")
                })
                }
            }
            .navigationTitle("Settings")
        }
    }


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
}
