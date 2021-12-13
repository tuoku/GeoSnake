//
//  SettingsView.swift
//  GeoSnake2
//
//  Created by iosdev on 7.12.2021.
// placeholder for settings 

import SwiftUI

struct SettingsView: View {
    @AppStorage("toggleSfx") private var sfxOn = true
    @AppStorage("toggleMusic") private var musicOn = true
    @AppStorage("toggleNotifications") private var notificationsOn = true
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Sounds")) {
                    
                    Toggle(isOn: $sfxOn,
                           label: {
                        Text("SFX")
                    })
                    
                    Toggle(isOn: $musicOn,
                           label: {
                    Text("Music")
                })
                }
                Section(header:
                            Text("Other")) {
                    Toggle(isOn: $notificationsOn, label: {
                        Text("Notifications")
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
