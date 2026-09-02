
module Ai
  class TaskBreakdownService
    class ParseError < StandardError; end

    def initialize(title:, user:)
      @title = title
      @user = user
    end

    def call
      raw_response = client.chat(
        system_prompt: TaskBreakdownPrompt.build,
        user_message: @title
      )

      content = extract_content(raw_response)
      data = parse_json(content)
      validate_shape!(data)

      build_task(data)
    end

    private

    def client
      @client ||= Ai::GroqClient.new
    end

    def extract_content(raw_response)
      raw_response.dig("choices", 0, "message", "content")
    end

    def parse_json(content)
      JSON.parse(content)
    rescue JSON::ParserError => e
      raise ParseError, "AI did not return valid JSON: #{e.message}"
    end

    def validate_shape!(data)
      unless data.is_a?(Hash) && data["subtasks"].is_a?(Array) && data["subtasks"].any?
        raise ParseError, "AI response missing expected 'subtasks' array"
      end
    end

    def build_task(data)
      task = @user.tasks.new(
        title: @title,
        category: data["category"].presence || "General",
        status: "pending"
      )

      data["subtasks"].each_with_index do |subtask_data, index|
        task.subtasks.build(
          description: subtask_data["description"],
          estimated_minutes: subtask_data["estimated_minutes"],
          position: index + 1
        )
      end

      task.save!
      task
    end
  end
end