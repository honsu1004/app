class MemoriesController < ApplicationController
  before_action :set_plan_and_folder
  before_action :authorize_member!, only: [ :index, :create, :edit, :destroy ]

  def index
    @plan = Plan.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.find(params[:memory_folder_id])
    @memories = @memory_folder.memories.order(created_at: :desc)
  end

  def create
    @memory = @memory_folder.memories.build(memory_params.except(:media))
    @memory.user = current_user

    Rails.logger.debug "=== Memory Creation Debug ==="
    Rails.logger.debug "Raw media params: #{memory_params[:media].inspect}"

    # 空要素を除去してからファイル処理
    uploaded_files = memory_params[:media]&.reject(&:blank?) || []
    Rails.logger.debug "Filtered files: #{uploaded_files.inspect}"
    Rails.logger.debug "Valid files count: #{uploaded_files.count}"

    # 画像が選択されているかチェック
    if uploaded_files.empty?
      @memory.errors.add(:media, "画像を選択してください")
      @memories = @memory_folder.memories.order(created_at: :desc)
      render 'memory_folders/show', status: :unprocessable_entity
      return
    end

    # ファイルをアタッチ
    uploaded_files.each do |file|
      if file.present? && file.respond_to?(:original_filename) && file.original_filename.present?
        @memory.media.attach(file)
        Rails.logger.debug "Attached file: #{file.original_filename}"
      end
    end

    if @memory.save
      redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: "思い出を追加しました"
    else
      Rails.logger.debug "Memory save failed: #{@memory.errors.full_messages}"
      @memories = @memory_folder.memories.order(created_at: :desc)
      render 'memory_folders/show', status: :unprocessable_entity
    end
  end

  def edit
    @memory = @memory_folder.memories.find(params[:id])
  end

  def destroy
    @memory = @memory_folder.memories.find(params[:id])
    @memory.destroy
    redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: "思い出を削除しました"
  end

  private

  def set_plan_and_folder
    @plan = current_user.plans.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.find(params[:memory_folder_id])
  end

  def memory_params
    params.require(:memory).permit(:url, media: [])
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end
end
