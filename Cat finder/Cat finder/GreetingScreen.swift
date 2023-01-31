//
//  GreetingScreen.swift
//  Cat finder
//
//  Created by Julia on 11/8/22.
//

import SwiftUI

struct GreetingScreen: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            HStack{
                Text("Cat Finder")
                    .bold()
                    .font(.system(size: 50))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.orange)
                Image(systemName: "pawprint.fill")
                    .font(.largeTitle)
            }
            Spacer()
                .frame(height: 50)
            Text("Hi! I am here to help you to know cats better!")
                .font(.system(size: 30, design:.serif))
                .multilineTextAlignment(.center)
            Image("кот")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
                .frame(height: 100)
            NavigationLink(destination: CriteriaScreen()) {
                Text("Start")
            }.padding(20)
                .background(.green)
                .foregroundColor(.black)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 245.0 / 255, green: 222.0/255, blue: 179.0 / 255))
    }
}

struct GreetingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GreetingScreen()
        }
    }
}
