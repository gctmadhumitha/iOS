//
//  ChatGPTResponse.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 06/09/23.
//

import Foundation
import OpenAIKit

let apiToken: String = "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"
let organizationName: String = "org-E60ldsJ7z7JeI9SJGhWZNrjI"

/// Initialize OpenAIKit with your API Token
public let openAI = OpenAIKit(apiToken: apiToken, organization: organizationName)


func getChatGPTResponse(message:String) async -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") || tempMessage.contains("hi") {
        return "Hey there!"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later!"
    } else if tempMessage.contains("how are you") {
        return "I am fine, thank you!"
    }else {
        let result = await getChatGPTResponse(prompt: message, previousMessages: [])
        switch result {
            case .success(let aiResult):
            if let text = aiResult.choices.first?.message?.content {
                return text
            }
            case .failure(let error):
                return "Error :\(error.localizedDescription)"
        }
        return "Error in result"
    }
}


func getChatGPTResponse(prompt:String, previousMessages: [AIMessage]) async -> Result<AIResponseModel, Error> {
    return await withCheckedContinuation { continuation in
        openAI.sendChatCompletion(newMessage: AIMessage(role: .user, content: prompt), previousMessages: previousMessages, model: .gptV3_5(.gptTurbo), maxTokens: 2048, n: 1) { result in
            continuation.resume(returning: result)
        }
    }
}
