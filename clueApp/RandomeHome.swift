//
//  RandomeHome.swift
//  clueApp
//
//  Created by Norah Khalid on 30/09/2025.
//


import SwiftUI

struct RandomeHome: View {
    var body: some View {
        NavigationView {
            VStack (spacing: 30){
           
                Spacer()
                    .padding(.horizontal)
               
                    HStack {
                        
                        
                        Image("Image 3")
                            .padding(.trailing)
                            
                        
                    }
                    Spacer()
                    
                    Image("Image 2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                    
                    
                }
                .padding()
                
                
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                           
                        }
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(Color("red"))
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Add") {
                            
                        }.font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color("red"))
                    }}}
                    }
                }
            
            #Preview {
                RandomeHome()
            }
        
