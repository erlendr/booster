module Api
  class BoosterbotController < ApplicationController
    include ActionView::Helpers::TextHelper

  @@auth_token = ENV['SLASH_COMMAND_TOKEN']

  before_filter :token_authenticate!

    def slash_bot
      puts params

      if params[:command] == '/bot'
        text = params[:text]
        puts 'Full text: ' + text

        command = text.include?(' ') ? text.split(' ')[0].to_s : text
        puts 'Parsed command: ' + command

        case command
          when 'help' then
            answer("Commands: help hello stats sponsors")

          when 'hello' then
            command_hello

          when 'stats' then
            command_stats(strip_first(text))

          when 'sponsors' then
            command_sponsors(strip_first(text))


          else
            answer("I'm sorry. I don't understand what you mean.")
          end


        # render :nothing => true, :status => 200

      else
        head :bad_request
      end
    end

    def command_hello
      answer("Hello, #{params[:user_name]}. How are you?")
    end

    def command_stats(text)
      answer("OK, #{params[:user_name]}, here are some statistics for you.")
    end

    def command_sponsors(text)
      if text.empty?
        count_accepted = Sponsor.count(:conditions => "status = 'accepted'")
        count_dialogue = Sponsor.count(:conditions => "status = 'dialogue'")
        message = "Right now we have #{pluralize(count_accepted, ' accepted sponsor')}."
        if count_dialogue > 0
          message = message + " There are #{count_dialogue} in dialogue though, so maybe we'll get more soon!"
        end
        answer(message)
      else
       answer( text + " is not a valid sub command for 'sponsors'")
      end
    end

    def answer(message)
      SlackNotifier.postReply(params, message)
      # render :plain, :text => message, :status => 200
      render :nothing => true, :status => 201
      return
    end

    def strip_first(text)
      text.split(' ').drop(1).join(' ')
    end


    def token_authenticate!
      render :nothing => true, :status => 401 unless params[:token] == @@auth_token
    end

  end
end