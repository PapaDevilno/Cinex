//
//  ContentView.swift
//  Cinex
//
//  Created by Nicholas Yvees on 25/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var splashScreen = true
    
    var body: some View {
        NavigationView{
            ZStack{
                if splashScreen{
                    VStack{
                        Text("CINEX")
                            .font(.custom(AppFont.JustHand, size: 96))
                            .foregroundColor(AppColor.orange)
                        
                        Text("Improve your cinema experience with us.")
                            .font(.custom(AppFont.JustHand, size: 14))
                            .foregroundColor(AppColor.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black)
                } else{
                    VStack{
                        
                        Spacer()
                        
                        VStack{
                            Image("GuideAsset")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                            
                            Text("Point your camera to the movie poster")
                                .font(.custom(AppFont.JustHand, size: 18))
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("Notes:")
                                .font(.custom(AppFont.JustHand, size: 18))
                                .foregroundColor(AppColor.red)
                            
                            Text("If the movie isn't showing any trailer, press the refresh button & try again")
                                .font(.custom(AppFont.JustHand, size: 18))
                                .foregroundColor(AppColor.red)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                        }
                        .padding(.bottom, 50)
                        
                        NavigationLink{
                            ARPosterView()
                        } label: {
                            Text("START")
                                .padding(.vertical,20)
                                .padding(.horizontal, 140)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.custom(AppFont.JustHand, size: 24))
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(AppColor.orange)
                                        .shadow(radius: 3)
                                )
                        }
                        .padding(.bottom, 50)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black)
                }
            }.onAppear(){
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 1)) {
                        self.splashScreen = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
