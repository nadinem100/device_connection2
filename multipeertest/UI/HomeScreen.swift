//
//  HomeScreen.swift
//  multipeertest
//
//  Created by Nadine Meister on 4/8/21.
//

import SwiftUI

struct HomeScreen: View {
    var lae_blue = Color(#colorLiteral(red: 0.18039216101169586, green: 0.49803921580314636, blue: 0.6313725709915161, alpha: 1))
    
    var body: some View {
        VStack{
            HStack{
                VStack {
                    Text("Connect your devices")
                        .font(.custom("Lato Light", size: 48))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    Text("Start setting up your session by connecting all your devices. Select the device from the list to connect via bluetooth. You may connect any of the apps with the session ID or QR code")
                        .font(.custom("Lato Regular", size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 40)
                }
                Image("Group 22346493")
                    .padding(.horizontal, 30)
            }
            HStack{
                VStack{
                    Button(action: { print("clicked on!")}) {
                        Image("Manikin")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("Manikin")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //second row
                    Button(action: { print("clicked on!")}) {
                        Image("Aed pads")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("Vital cables")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //third row
                    Button(action: { print("clicked on!")}) {
                        Image("SimNext logo")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("SimNext Devices")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //fourth
                    Button(action: { print("clicked on!")}) {
                        Image("Pulse")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("TruMonitor control")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                }
                
                //second column
                VStack{
                    Button(action: { print("clicked on!")}) {
                        Image("Ventilation lungs")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("Bag Valve Mask")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //second row
                    Button(action: { print("clicked on!")}) {
                        Image("Stethoscope")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("Stethoscope")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //third row
                    Button(action: { print("clicked on!")}) {
                        Image("Video recording")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
//                            .frame(width:35.63, height:35.63)
                        VStack{
                            Text("Recording devices")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                    
                    //fourth
                    Button(action: { print("clicked on!")}) {
                        Image("Pulse")
                            .padding()
                            .background(lae_blue)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        VStack{
                            Text("TruMonitor monitor")
                                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Not connected")
                                .foregroundColor(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Image("Chevron right")
                            .padding()
                    }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.gray)
                    )
                }
                
                
            }
            Button(action: {print("start session button pressed")}) {
                RoundedRectangle(cornerRadius: 25)
                    .padding(16)
                    .foregroundColor(lae_blue)
                    .frame(width: 296+32, height: 88, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(Text("Start session").font(.custom("Lato Bold", size: 22)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center))
            }
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.9450980424880981, green: 0.9843137264251709, blue: 0.9960784316062927, alpha: 1)))
                .overlay(Image("homescreen_viz"))
//            .frame(width: 768, height: 266.1)

        }
        
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
