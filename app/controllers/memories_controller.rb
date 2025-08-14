class MemoriesController < ApplicationController
  before_action :set_memory_folder
  before_action :set_memory, only: [:edit, :destroy]
  before_action :authorize_member!, only: [ :index, :create, :edit, :destroy ]

  def index
    @memories = @memory_folder.memories.with_attached_media
  end

  def create
    Rails.logger.debug "Received params: #{params[:memory][:media].inspect}"
    @memory_folder = MemoryFolder.find(params[:memory_folder_id])
    @memory = @memory_folder.memories.new(memory_params)
    @memory.user = current_user

    if params[:memory][:media].present?
      params[:memory][:media].each do |file|
        @memory.media.attach(file) if file.present?
      end
    end

    if @memory.save
      redirect_to plan_memory_folder_path(@memory_folder.plan, @memory_folder), notice: "思い出を追加しました"
    else
      @memories = @memory_folder.memories.with_attached_media
      render "memory_folders/show", status: :unprocessable_entity
    end
  end

  def edit
    @memory = @memory_folder.memories.find(params[:id])
  end

  def destroy
    @memory_folder = @memory.memory_folder
    @plan = @memory_folder.plan
    
    # 画像とメモリを削除
    @memory.media.purge if @memory.media.attached?
    @memory.destroy

    redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: '思い出が削除されました'
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
    params.require(:memory).permit(:url, media: []).tap do |whitelisted|
      if whitelisted[:media].present?
        whitelisted[:media] = whitelisted[:media].reject(&:blank?)
      end
    end
  end
end
