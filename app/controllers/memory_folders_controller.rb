class MemoryFoldersController < ApplicationController
  before_action :set_plan
  before_action :set_memory_folder, only: [ :show, :update, :destroy ]
  before_action :authorize_member!, only: [ :index, :create, :update, :destroy ]

  def index
    @plan = Plan.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.build
    @memory_folders = @plan.memory_folders
  end

  def show
    @memory_folder = @plan.memory_folders.find(params[:id])
    @memory = @memory_folder.memories.new
    @memories = @memory_folder.memories.with_attached_media
  end

  def create
    @plan = current_user.plans.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.build(memory_folder_params)

    Rails.logger.debug "=== Memory Folder Debug ==="
    Rails.logger.debug "Plan: #{@plan.inspect}"
    Rails.logger.debug "Memory Folder: #{@memory_folder.inspect}"
    Rails.logger.debug "Params: #{memory_folder_params.inspect}"
    Rails.logger.debug "Valid?: #{@memory_folder.valid?}"
    Rails.logger.debug "Errors: #{@memory_folder.errors.full_messages}"

    if @memory_folder.save
      redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: "フォルダを作成しました"
    else
      @memory_folders = @plan.memory_folders
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @memory_folder.update(memory_folder_params)
      redirect_to @memory_folder, notice: "フォルダを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @memory_folder.destroy
    redirect_to plan_memory_folders_path(@plan), notice: "フォルダを削除しました"
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  private

  def memory_params
    params.require(:memory).permit(:title, :description, media: [])
  end

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def set_memory_folder
    @memory_folder = @plan.memory_folders.find_by(id: params[:id])
    unless @memory_folder
      redirect_to plan_memory_folders_path, alert: "フォルダは削除されました"
    end
  end

  def memory_folder_params
    params.require(:memory_folder).permit(:name, media: [])
  end
end
