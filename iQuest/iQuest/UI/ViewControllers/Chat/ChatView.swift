//
//  ChatView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 06/09/23.
//

import SwiftUI

struct ChatView: View {
    
    @State private var messageText = ""
    @State var messages : [String] = ["Welcome to ChatGPT"]
    
    var body: some View {
        VStack {
            HStack{
                Text("Ask ChatGPT")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "bubble.left.fill")
                    .font(.system(size:26))
                    .foregroundColor(AppColors.primaryAppColor.suColor)
            }
            ScrollView{
                //Messages
                ForEach(messages, id:\.self) { message in
                    if message.contains("[USER]"){
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        HStack{
                            Spacer()
                            Text(newMessage)
                                .padding(10)
                                .background(.mint)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .listRowSeparator(.hidden)
                                .overlay(alignment:.bottomTrailing) {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.title)
                                        .rotationEffect(.degrees( -45))
                                        .offset(x:  10, y: 10)
                                        .foregroundColor(.mint)
                                }
                        }.padding()
                    }else {
                        HStack{
                            Text(message)
                                .padding(10)
                                .background(.gray)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                                .listRowSeparator(.hidden)
                                .overlay(alignment:.bottomLeading) {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.title)
                                        .rotationEffect(.degrees( 45))
                                        .offset(x:  -10, y: 10)
                                        .foregroundColor(.gray)
                                }
                            Spacer()
                        }.padding()
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            .background(Color.gray.opacity(0.1))
            HStack{
                TextField("Type your question", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        //SendMessage
                        Task {
                           await sendMessage(message: messageText)
                        }
                    }
                Button {
                    //SendMessage
                    Task {
                       await sendMessage(message: messageText)
                    }
                } label: {
                    Image(systemName: "paperplane.fill").foregroundColor(AppColors.primaryAppColor.suColor)
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
    
    func sendMessage(message:String) async {
        withAnimation {
            messages.append("[USER]" + message)
            print("message is :", message)
            self.messageText = ""
        }
        let reply = await getChatGPTResponse(message: message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(reply)
            }
        }
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
