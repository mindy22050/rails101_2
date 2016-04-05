class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create,:edit,:update,:destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path, notice: '你的廢文已經改好惹'
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: '已刪除你的廢文'
  end

  def join
      @group = Group.find(params[:id])

      if !current_user.is_member_of?(@group)
        current_user.join!(@group)
        flash[:notice] = "成功加入此廢文討論串"
      else
        flash[:warning] = "你已經是這個討論串的成員了啊，有事嗎"
      end

      redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      flash[:warning] = "你又不是本版成員"
    else
      current_user.quit!(@group)
      flash[:notice] = "你已成功退出本討論串"
    end

    redirect_to group_path(@group)
  end


  private

  def group_params
    params.require(:group).permit(:title, :description)
  end


end
