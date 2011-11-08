class JqgridController < ApplicationController
  def index
  end

  #http://www.trirand.com/blog/jqgrid/jqgrid.html
  def get_data
    {:sidx=>"username",:sort=>"asc",:rows=>20}.each{|k,v| params[k]||=v}
    sql = "1=1"
    sql += " and #{params[:searchField]} = '#{params[:searchString]}'" unless params[:searchField].blank?
    @employees = Employee.paginate(:select=>"id,username,name_cn",:conditions=>sql,
      :order=>[params[:sidx],params[:sort]].join(" "),:page=>params[:page],:per_page=>params[:rows])
    ret = {:page=>params[:page],:total=>@employees.total_pages,:records=>@employees.total_entries,
      :rows=>@employees.map{|e| {:id=>e.id,:cell=>[e.id,e.username,e.name_cn]}}}
    render :text=>ret.to_json
  end

  def flex_grid
    @employees = Employee.all(:select=>"id,username,name_cn",:order=>"username")
  end

  def fancybox
    @title = "图片浏览插件"
  end

  def employee_edit
    unless params[:id].blank?
      @employee = Employee.find(params[:id])
    else
      @employee = Employee.new
    end
  end

  def employee_update
    unless params[:id].blank?
      @employee = Employee.find(params[:id])
      @employee.update_attributes(params[:employee])
    else
      @employee = Employee.new(params[:employee])
    end
    if @employee.valid?
      flash[:notice] = "成功保存！"
      redirect_to :action=>"employee_edit"
    else
      render :action=>"employee_edit"
    end
  end

end
