require "net/http"
require "uri"
require "json"

module Ai
  class GroqClient
    ENDPOINT = "https://api.groq.com/openai/v1/chat/completions".freeze
    MODEL = "openai/gpt-oss-120b".freeze

    def initialize
      @api_key = Rails.application.credentials.dig(:groq, :api_key)
    end

    def chat(system_prompt:, user_message:)
      uri = URI(ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{@api_key}"

      request.body = {
        model: MODEL,
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_message }
        ],
        temperature: 0.3,
        response_format: { type: "json_object" }
      }.to_json

      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end