class Api::V1::Admin::WxPublicsController < Api::V1::Admin::BaseController
  before_action :set_wx_public, only: [:show, :update, :destroy, :active]
  def index
    @wx_publics = WxPublic.all
    @wx_publics = @wx_publics.where(active: params[:active]) unless params[:active].blank?
    @wx_publics = @wx_publics.full_text_search(params[:search]) unless params[:search].blank?
    @wx_publics = @wx_publics.page(params[:page])
  end

  def show
    if !@wx_public
      return render json: {status: -1, notice: '数据不存在'}
    end
  end

  def create
    @wx_public = WxPublic.new(wx_public_params)
    if @wx_public.save
      render json: { status: 1, notice: "创建成功", id: @wx_public.id.to_s }
    else
      render json: { status: -1, notice: "创建失败", error_msg: @wx_public.errors.full_messages }
    end
  end
  
  def update
    result = @wx_public.update(wx_public_params)
    if result
      render json: { status: 1, notice: "更改成功！" }
    else
      render json: { status: -1, notice: "更改失败", error_msg: @wx_public.errors.full_messages }
    end
  end
  
  def destroy
    result = @wx_public.destroy
    render json: { status: 1, notice: "删除成功！"}
  end
  
  def active
    if params[:active] == 'open'
      @wx_public.update(active: true)
      render json: { status: 1, notice: "开启监控成功！" }
    elsif params[:active] == 'close'
      @wx_public.update(active: false)
      render json: { status: 1, notice: "关闭监控成功！" }
    else
      render json: { status: -1, notice: "错误！" }
    end
  end
  

  private
  def set_wx_public
    @wx_public = WxPublic.find(params[:id]) 
  end
  
  def wx_public_params
    params.require(:wx_public).permit(:name, :desc, :collect_count, :monitoring_rate, :monitoring_count, :end_at)
  end
  
end