defmodule PropManSrvs do
  use GenServer


  #Public APIs
  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  #Project APIs

  def create_project(pid, project_name) do
    GenServer.cast(pid, {:create_project, project_name})
  end

  def projects(pid) do
    GenServer.call(pid, {:list_projects})
  end


  #-----------------------------------------------------------#
  #Server Callbacks

  def handle_cast({:create_project, project_name}, _) do
    {:noreply, Project.create(project_name)}
  end


  def handle_call({:list_projects}, _, _) do
    {:reply, Project.projects() , :ok }
  end

end
