class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end


  def proxies
    @project = Project.find(params[:id])
    @proxies = Proxy.where(:project_id => @project.id)
    render 'proxies/index'
=begin
	  respond_to do |format|
		  format.html # show.html.erb
		  format.json { render json: @project }
	  end
=end
  end

  def start
    @project = Project.find(params[:id])
    @proxies = Proxy.where(:project_id => @project.id)
    @info=''

    #启动所有的代理
    require 'proxy_server'
    $proxy_servers ||={}
    $proxy_servers[params[:id]] ||={}
    @proxies.each do |proxy|
      if $proxy_servers[params[:id]][proxy.name]==nil
        $proxy_servers[params[:id]][proxy.name] = Proxys.new 'protocol' => proxy.protocol,
                                                             'forward_host' => proxy.forward_ip,
                                                             'forward_port' => proxy.forward_port,
                                                             'port' => proxy.bind_port,
                                                             'host' => '0.0.0.0'

        #每次请求时自动保存数据
        $proxy_servers[params[:id]][proxy.name].tc do |testcase|
          #data=JSON.pretty_generate({:req=>req, :res=>res})
          data=testcase.to_yaml

          tc=Testcase.new
          tc.name=''
          tc.data=data
          tc.project_id=params[:id]
          tc.save
        end
        $proxy_servers[params[:id]][proxy.name].start(:debug=>true)

        @info+=$proxy_servers[params[:id]][proxy.name].info
      else
        @info="Already Start, You should stop first"
      end

    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end


  def stop
    @project = Project.find(params[:id])
    @proxies = Proxy.where(:project_id => @project.id)

    #停止代理
    $proxy_servers[params[:id]].each do |k, v|
      v.stop
      $proxy_servers[params[:id]][k]=nil
    end
    p $proxy_servers[params[:id]]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def setup
    require 'rake'
    Replay::Application.load_tasks
    Rake::Task['db:setup'].invoke
  end

end
