class ApiController < ApplicationController
    def new_user
        @user = User.new(username: params[:username])
        if @user.save
            render json: { username: @user.username, _id: @user.id }
        else
            render json: { error: 'username cannot be empty' }
        end
    end

    def list_users
        render json: User.all.map{ |user| {_id: user.id, username: user.username} }.as_json
    end

    def add_exercise
        @user = User.find(params[:userId])
        if @user
            @exercise = @user.exercises.new({
                description: params[:description],
                duration: params[:duration],
                date: (valid_date_string?(params[:date]) && Date.parse(params[:date])) || Date.today
            })
        else
            render json: { error: "no user with id: #{params[:userId]}." }
        end
        begin
            @exercise.save
            render json: {
                username: @user.username,
                description: @exercise.description,
                duration: @exercise.duration,
                _id: @user.id,
                date: @exercise.date.strftime('%a, %b %e %Y')
            }
        rescue NoMethodError
            render json: { error: 'malformed exercise data.' }
        end
    end

    def exercise_log
        @user = User.includes(:exercises).find(params[:userId])
        
        if !@user
            render json: { error: "no user with id: #{params[:userId]}." }
        elsif valid_date_string?(params[:from]) && valid_date_string?(params[:to])
            @exercises = @user.exercises
                              .select(:description, :duration, :date)
                              .where("date >= ? AND date <= ?", params[:from], params[:to])
        elsif params[:limit] && (params[:limit] == params[:limit].to_i.to_s)
            @exercises = @user.exercises
                              .select(:description, :duration, :date)
                              .limit(params[:limit])
        else
            @exercises = @user.exercises
                              .select(:description, :duration, :date)
        end

        render json: {
            _id: @user.id,
            username: @user.username,
            count: @user.exercises.length,
            log: @exercises.map{ |ex| {
                    description: ex.description,
                    duration: ex.duration,
                    date: ex.date.strftime('%a, %b %e %Y')
                 } }.as_json
        }
    end

    def valid_date_string?(date)
        date && Date.valid_date?(date.split('-'))
    end
end
