class WeightEntriesController < ApplicationController
    before_action :authenticate_user!

    def index
        @user = current_user
        @weight_entries = current_user.weight_entries.order('created_at DESC')
        @current_diff = @weight_entries.second.exact_weight - @weight_entries.first.exact_weight
        @diff_is_loss = @current_diff > 0 ? true:false
        @graph_labels = Array.new
        @graph_data = Array.new
        @weight_entries.each do |entry|
            @graph_labels.push(entry.updated_at.strftime("%m-%d-%Y %H:%M"))
            @graph_data.push(entry.exact_weight)
        end
    end

    def new
        @weight_entry = WeightEntry.new
    end

    def create
        @user = current_user
        @weight_entry = @user.weight_entries.build(weight_entry_params)
        if @weight_entry.save
            flash[:success] = "Your weight entry has been saved!"
            redirect_to user_weight_entries_path
        else
            render :new
        end
    end
    
    def update
        @weight_entry = WeightEntry.find(params[:id])
        if @weight_entry.update_attributes(weight_entry_params)
            flash[:success] = "Entry has been updated"
        else
            render :show
        end
    end

    def edit
        @weight_entry = WeightEntry.find(params[:id])
    end

    def destroy
        @weight_entry.destroy
        redirect_to users_url, notice: "Entry was successfully deleted"
    end

    private
        def weight_entry_params
            params.require(:weight_entry).permit(:exact_weight)
        end

end