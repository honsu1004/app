class MemoryFoldersController < ApplicationController
  before_action :set_plan
  before_action :set_memory_folder, only: [ :show, :update, :destroy ]
  before_action :authorize_member!, only: [ :index, :create, :update, :destroy ]

  def index
    @plan = Plan.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.build
    @memory_folders = @plan.memory_folders.where.not(id: nil) # ← これが重要！
  end

  def show
    @memory = @memory_folder.memories.new
    @memories = @memory_folder.memories.includes(media_attachment: :blob)
  end

  def create
    @memory_folder = @plan.memory_folders.new(memory_folder_params)

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
    redirect_to plan_memory_folder_path(@plan), notice: "フォルダを削除しました"
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def set_memory_folder
    @memory_folder = @plan.memory_folders.find(params[:id])
  end

  def memory_folder_params
    params.require(:memory_folder).permit(:name, media: [])
  end
end
