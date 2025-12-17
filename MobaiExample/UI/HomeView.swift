//
//  ContentView.swift
//  MobaiExample
//
//  Created by serif.kazan on 11/12/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var settingsIsShown = false
    @State private var route: Route? = nil
    @State private var captureResult: VideoDecodingResponse? = nil
    
    var body: some View {
        NavigationView{
            VStack {
                ZStack {
                    Text("Biometric SdK Example")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Spacer()
                        Button{
                            settingsIsShown = true
                        }label:{
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .foregroundStyle(Color(hex: "#F2C04C"))
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
                Button{
                    route = .capture
                } label:{
                    Text("Start Biometric Session")
                        .font(Font.system(size: 18).bold())
                        .foregroundStyle(.black)
                        .padding(18)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(hex: "#F2C04C"))
                .cornerRadius(25)
                .padding(.horizontal)
                .padding(.bottom, 10)
            
                Text("SDK: v2.3.1 Backend: v2.5.1")
                    .foregroundStyle(.white)
                NavigationLink(destination: CaptureView(onFinished: {result in
                    switch result {
                    case .success(let value):
                        print("Success")
                        captureResult = value
                        route = .result
                    case .failure(let error):
                        print("Failed: \(error)")
                    }
                    
                }), tag: .capture, selection: $route){
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(destination: ResultView(result: captureResult, onNavigateBack: {
                    route = nil
                }), tag: Route.result, selection: $route){
                    EmptyView()
                }.hidden()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#18323C"), Color(hex: "#2B586A")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .sheet(isPresented: $settingsIsShown){
                if #available(iOS 16.0, *) {
                    SettingsBottomSheetView()
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                } else {
                    SettingsBottomSheetView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
