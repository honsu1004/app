class NotesController < ApplicationController
  def index
    @plan = Plan.find(params[:plan_id]) # paramsからplan_idを取得して探す
    @notes = @plan.notes.order(created_at: :desc)
    @note = @plan.notes.new
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @note = @plan.notes.new(note_params)
    @note.user = current_user

    if @note.save
      redirect_to plan_notes_path(@plan), notice: 'ノートが作成されました！'
    else
      @notes = @plan.notes
      render :index
    end
  end

  def destroy
    @plan = Plan.find(params[:plan_id])  # まずはプランを取得
    @note = @plan.notes.find(params[:id])
    @note.destroy
    redirect_to plan_notes_path(@plan), notice: "ノートを削除しました"
  end

  private

  def note_params
    params.require(:note).permit(:title, :content) # 必要なパラメータを指定
  end
end
