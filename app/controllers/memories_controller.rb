class MemoriesController < ApplicationController
  before_action :authorize_member!, only: [:edit, :update, :destroy]
  before_action :set_memory_folder
  before_action :set_memory, only: [:edit, :destroy]

  def index
    @memories = @memory_folder.memories.includes(media_attachment: :blob)
  end

  def create
    @memory_folder = MemoryFolder.find(params[:memory_folder_id])
    @memory = @memory_folder.memories.new(memory_params)
    @memory.user = current_user

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
