class MemoriesController < ApplicationController
  before_action :set_memory_folder
  before_action :set_memory, only: [:edit, :destroy]
  before_action :authorize_member!, only: [ :index, :create, :edit, :destroy ]

  def index
    @memories = @memory_folder.memories.includes(media_attachment: :blob)
  end

  def create
    @memory_folder = MemoryFolder.find(params[:memory_folder_id])
    @memory = @memory_folder.memories.new(memory_params)
    @memory.user = current_user

    Rails.logger.debug "== Params for memory: #{memory_params.inspect}"

    if @memory.save
      redirect_to plan_memory_folder_path(@memory_folder.plan, @memory_folder), notice: "思い出を追加しました"
    else
      @memories = @memory_folder.memories.includes(media_attachment: :blob)
      render "memory_folders/show", status: :unprocessable_entity
    end
  end

  def edit
    @memory = @memory_folder.memories.find(params[:id])
  end

  def destroy
    @memory.destroy
    redirect_to plan_memory_folder_path(@memory_folder.plan, @memory_folder), notice: "思い出を削除しました"
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  private

  def set_memory_folder
    @memory_folder = MemoryFolder.find(params[:memory_folder_id])
  end

  def set_memory
    @memory = @memory_folder.memories.find(params[:id])
  end

  def memory_params
    params.require(:memory).permit(:media, :url, :caption)
  end
end
