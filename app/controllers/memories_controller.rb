class MemoriesController < ApplicationController
  before_action :set_memory_folder
  before_action :set_memory, only: [:edit, :destroy]
  before_action :authorize_member!, only: [ :index, :create, :edit, :destroy ]

  def index
    @memories = @memory_folder.memories.with_attached_media
  end

  def create
    Rails.logger.debug "=== Media Upload Debug ==="
    Rails.logger.debug "Raw media params: #{params[:memory][:media].inspect}"
  
    @memory_folder = MemoryFolder.find(params[:memory_folder_id])
    @memory = @memory_folder.memories.new(memory_params.except(:media))
    @memory.user = current_user

    # 複数画像の処理
    if params[:memory][:media].present?
      # 空の値、nil、空文字列を確実に除外
      valid_files = params[:memory][:media].compact.reject { |file| 
        file.blank? || !file.respond_to?(:tempfile) 
      }
    
      Rails.logger.debug "Valid files count: #{valid_files.length}"
      Rails.logger.debug "Valid files: #{valid_files.map(&:original_filename)}"
    
      # 有効なファイルのみをアタッチ
      valid_files.each do |file|
        @memory.media.attach(file)
      end
    end

    if @memory.save
      Rails.logger.debug "Memory saved successfully with #{@memory.media.count} attachments"
      redirect_to plan_memory_folder_path(@memory_folder.plan, @memory_folder), 
                  notice: "思い出を追加しました（#{@memory.media.count}枚の画像）"
    else
      Rails.logger.debug "Memory save failed: #{@memory.errors.full_messages}"
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

   # 削除前にメディアファイルの存在確認
    if @memory.media.attached?
      @memory.media.purge
    end

    # メモリレコードの削除
    if @memory.destroy
      respond_to do |format|
        format.html { redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: '思い出が削除されました' }
        format.turbo_stream # app/views/memories/destroy.turbo_stream.erb を呼び出し
      end
    else
      redirect_to plan_memory_folder_path(@plan, @memory_folder), alert: '削除に失敗しました'
    end
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
    params.require(:memory).permit(:url, media: [])
  end
end
