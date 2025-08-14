class MemoryAttachmentsController < ApplicationController
  before_action :set_memory

  def destroy
    # 特定のAttachmentを削除
    attachment = ActiveStorage::Attachment.find(params[:id])
    
    # セキュリティチェック：そのAttachmentが該当のMemoryに属するか確認
    if attachment.record == @memory
      attachment.purge
      @memory.reload

      if !@memory.media.attached?
        @memory.destroy
        @memory_deleted = true
      end

      respond_to do |format|
        format.html { redirect_to plan_memory_folder_path(@plan, @memory_folder), notice: '画像を削除しました' }
        format.turbo_stream # 非同期削除用
      end
    else
      redirect_to plan_memory_folder_path(@plan, @memory_folder), alert: '削除権限がありません'
    end
  end
  
  private
  
  def set_memory
    @plan = Plan.find(params[:plan_id])
    @memory_folder = @plan.memory_folders.find(params[:memory_folder_id])
    @memory = @memory_folder.memories.find(params[:memory_id])
  end
end
